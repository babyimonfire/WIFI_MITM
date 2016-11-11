# WiFi_MITM
## 0x01 环境
* 主机：ubuntu
* 设备:D-Link DWA-192
* 软件：squid、apache、hostapd

## 0x02 系统配置
首先把系统的网络转发功能打开，可以使用：
  echo 1 > /proc/sys/net/ipv4/ip_forward
暂时启用，也可以修改sysctl.conf永久转发。
然后，对无线网卡进行ip设定，这里设置为：
  ip:192.168.88.1 netmaks:255.255.255.0
## 0x03
## 0x04
