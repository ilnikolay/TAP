# All interfaces on the VM default name space:

```
[ec2-user@ip-172-31-10-139 conf.d]$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 0a:fb:b3:3f:a6:a4 brd ff:ff:ff:ff:ff:ff
    inet 172.31.10.139/20 brd 172.31.15.255 scope global dynamic eth0
       valid_lft 2358sec preferred_lft 2358sec
    inet6 fe80::8fb:b3ff:fe3f:a6a4/64 scope link 
       valid_lft forever preferred_lft forever
```

## Both Veth interfaces:
```
4: eth0-A@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 76:d0:39:97:41:0c brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.100.1/28 scope global eth0-A
       valid_lft forever preferred_lft forever
    inet6 fe80::74d0:39ff:fe97:410c/64 scope link 
       valid_lft forever preferred_lft forever
6: eth0-B@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 36:32:49:dd:ee:f4 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet 192.168.200.1/28 scope global eth0-B
       valid_lft forever preferred_lft forever
    inet6 fe80::3432:49ff:fedd:eef4/64 scope link 
       valid_lft forever preferred_lft forever
```

## VPN interface:
```
8: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none 
    inet 10.8.0.1/24 brd 10.8.0.255 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::521:52a4:f784:f28/64 scope link stable-privacy 
       valid_lft forever preferred_lft forever
```

## From netstat you can see NGINX listening on port 172.31.10.139:80 and openVPN listening on 8080
