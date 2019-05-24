package main

import (
	"flag"
	"io"
	"log"
	"net"
	"os"
	"time"
)

func main() {
	log.Println("Port forwarder for Samba service by ihciah.")

	var listen string
	var dest string
	var verbose bool
	flag.StringVar(&listen, "listen", "", "listen addr(for example, 100.100.100.1:445)")
	flag.StringVar(&dest, "dest", "", "destination addr with port(for example, 1.1.1.1:11445)")
	flag.BoolVar(&verbose, "verbose", false, "if print log")
	flag.Parse()

	logger := MakeLogger(verbose)
	localaddr, err := net.ResolveTCPAddr("tcp4", listen)
	if err != nil {
		logger.Fatalf("cannot resolve listen addr %s", listen)
	}

	listener, err := net.ListenTCP("tcp", localaddr)
	if err != nil {
		logger.Fatalf("cannot listen %s", listen)
	}
	logger.Printf("listening on %s\n", listen)

	for {
		conn, err := listener.Accept()
		if err != nil {
			logger.Println("recv connection error")
			continue
		}
		go handle(conn, dest, logger)
	}
}

type Logger struct {
	Logger *log.Logger
	Verbose bool
}
func (L *Logger)Printf(s string, x ...interface{}){
	if L.Verbose{
		L.Logger.Printf(s, x...)
	}
}
func (L *Logger)Fatalf(s string, x ...interface{}){
	if L.Verbose{
		L.Logger.Fatalf(s, x...)
	}
}
func (L *Logger)Println(s string){
	if L.Verbose{
		L.Logger.Printf(s)
	}
}
func MakeLogger(verbose bool) *Logger{
	l := Logger{
		Logger: log.New(os.Stdout, "PortFw", log.LstdFlags),
		Verbose: verbose,
	}
	return &l
}

func handle(conn net.Conn, dest string, logger *Logger){
	defer conn.Close()
	conn.(*net.TCPConn).SetKeepAlive(true)
	logger.Printf("recv connection from %s\n", conn.RemoteAddr())
	remoteconn, err := net.DialTimeout("tcp", dest, time.Second * 10)
	if err != nil {
		logger.Println("dial remote addr fail.")
		conn.Close()
		return
	}
	defer remoteconn.Close()
	remoteconn.(*net.TCPConn).SetKeepAlive(true)
	logger.Println("connection established.")
	relay(conn, remoteconn)
}

func relay(left, right net.Conn) (int64, int64, error) {
	type res struct {
		N   int64
		Err error
	}
	ch := make(chan res)

	go func() {
		n, err := io.Copy(right, left)
		right.SetDeadline(time.Now())
		left.SetDeadline(time.Now())
		ch <- res{n, err}
	}()

	n, err := io.Copy(left, right)
	right.SetDeadline(time.Now())
	left.SetDeadline(time.Now())
	rs := <-ch

	if err == nil {
		err = rs.Err
	}
	return n, rs.N, err
}
