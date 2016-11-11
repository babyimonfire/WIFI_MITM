# WiFi_MITM
## 0x01 环境
* 主机：ubuntu
* 设备:D-Link DWA-192
* 软件：squid、apache、hostapd、udhcpd

## 0x02 系统配置
首先把系统的网络转发功能打开，可以使用：

    echo 1 > /proc/sys/net/ipv4/ip_forward
    
暂时启用，也可以修改sysctl.conf永久转发。

然后修改`/etc/network/interface`托管无线网卡设备：
```
auto wlan0
iface wlan0 inet static
    address 192.168.88.1
    netmask 255.255.255.0
```
## 0x03 软件设置
### squid
```
##本配置文件不全，仅着重指出需要修改的重要地点。

#============change the proxy port========================
http_port 3128  #这里指定自己的代理端口
#=========================================================

#============change the access configure==================
http_access allow all #这里需要修改默认配置
#http_access deny all #此处将默认的拒绝全部连接注释掉
==========================================================

#============change cache configure=======================
cache_mem 1000  #根据自己的需要进行适当修改
cache_dir ufs /var/spool/squid3 1000 16 256 #这里指定缓存地址，记得第一个缓存大小不得低于上面的mem大小，否则会报错
#=========================================================

#============change log configure=========================
access_log /var/log/squid3/access.log squid
cache_store_log /var/log/squid3/store.log
cache_log /var/log/squid3/cache.log
#=========================================================

#============this is url_rewrite_program code=============
redirect_program /etc/squid3/test.pl  #此处为重定向器的地址，即代理脚本
redirect_rewrites_host_header off     #是否更新host头信息
redirect_children 200                 #自行指定子进程数量
#=========================================================
```
### hostapd
```
#open WiFi config file

interface=wlan0
driver=rtl871xdrv
ssid=Your WiFi SSID
hw_mode=g
channel=6
macaddr_acl=0
ignore_broadcast_ssid=0
rsn_pairwise=CCMP
macaddr_acl=0
```
### udhcpd
```
##本配置文件不全，仅着重指出需要修改的重要地点。
start           192.168.88.100
end             192.168.88.140
interface       wlan0
opt     dns     114.114.114.114 8.8.8.8
option  subnet  255.255.255.0
opt     router  192.168.88.1
```
## 0x04 注意事项
1. 注意apache网站目录文件夹的权限和隶属于的用户，最好是能与squid用户相同的用户组。如果不是，可以使用chown进行修改。例：`chown proxy.proxy xxx`
1. 注意脚本文件的权限。脚本文件必须是可以被squid用户执行的。
1. 注意log文件的权限，关于log文件一共有三个，位于`/var/log/squid3/`下，分别是`cache.log`、`store.log`、`access.log`，这三个文件必须是可写的，同时也可以直接用`chown`改变用户所有权限。
1. 遇到更多打不开网页的问题，可以查阅`/var/log/squid3/cache.log`，会给出很详细的说明。
