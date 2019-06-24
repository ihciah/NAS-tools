# 路由透明代理

为了不影响 NAS 的速度，本代理只对网内其他非路由器设备有效。

1. 修改 `make_ipset_17mon.sh` 或 `make_ipset_apnic.sh` 中的 `VPN_SERVER`, `SETNAME`, `SETFILE`, 来生成国内 `ipset` 文件，然后将该文件放置在指定的位置，如`/etc/free-route/chnroute.ipset`。

2. 之后修改 `up.sh` 中的 `LOCAL_IP`, `ROUTER_IP`, `LOCAL_NETWORK`, `VPN_INTERFACE`, `SETFILE` (即Step1中的文件位置), `SETNAME`，然后将 `up.sh` 添加可执行位并加入 `Tinc` 的启动脚本。

IP 数据源：

china_ip_list.txt: <https://github.com/17mon/china_ip_list>

另一份: http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest



