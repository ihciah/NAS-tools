### Samba Forwarder

用于端口转发解决 `Windows` 平台无法指定 SMB 端口问题的简易端口转发器。

推荐使用 `nssm` 注册启动服务。

需要关闭系统的 `445` 监听，然后创建 Loopback interface 并将 ip 传入该程序。

UPDATE:

在新版本 `Windows` 上关闭 445 真的太蛋疼了。每次大更新都会帮我重新搞开。

放弃了，用 RaiDrive 吧，走 `WebDAV` 使用体验还可以，就是开了 SSL 有点吃 CPU。