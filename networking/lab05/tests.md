## 1. My Local computer ip add. and you can see VPN interface which is tun0:
```
student@pop-os:~$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000

3: wlxf81a67099a9f: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether f8:1a:67:09:9a:9f brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.107/24 brd 192.168.1.255 scope global dynamic noprefixroute wlxf81a67099a9f
       valid_lft 83626sec preferred_lft 83626sec
    inet6 fe80::e537:16ef:d87c:2e39/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
    link/none 
    inet 10.8.0.2/24 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::ea19:a52b:65da:7203/64 scope link stable-privacy 
       valid_lft forever preferred_lft forever
```

## 2. This is test from my local PC towards the VM local IP on port 80 where the NGINX is configured as a load balancer and proxy. All is passign through the VPN:

```
student@pop-os:~$ curl 172.31.10.139:8080
<html>
<body>
	TEST1
</body>
</html>
student@pop-os:~$ curl 172.31.10.139:8080
<html>
<body>
	TEST2
	TEST2
</body>
</html>
```

## 3. Here is a ping and traceroute test from my local PC towards the VM network namespaces through the VPN:

### Pinging nsA
```
student@pop-os:~$ ping 192.168.100.2
PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
64 bytes from 192.168.100.2: icmp_seq=1 ttl=63 time=31.2 ms
64 bytes from 192.168.100.2: icmp_seq=2 ttl=63 time=32.4 ms
64 bytes from 192.168.100.2: icmp_seq=3 ttl=63 time=35.1 ms
^C
--- 192.168.100.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 31.232/32.928/35.123/1.627 ms
```
### Pinging nsB
```
student@pop-os:~$ ping 192.168.200.2
PING 192.168.200.2 (192.168.200.2) 56(84) bytes of data.
64 bytes from 192.168.200.2: icmp_seq=1 ttl=63 time=34.4 ms
64 bytes from 192.168.200.2: icmp_seq=2 ttl=63 time=31.8 ms
64 bytes from 192.168.200.2: icmp_seq=3 ttl=63 time=30.9 ms
^C
--- 192.168.200.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 30.870/32.331/34.359/1.479 ms
```
### Pinging VM local IP
```
student@pop-os:~$ ping 172.31.10.139
PING 172.31.10.139 (172.31.10.139) 56(84) bytes of data.
64 bytes from 172.31.10.139: icmp_seq=1 ttl=64 time=33.7 ms
64 bytes from 172.31.10.139: icmp_seq=2 ttl=64 time=32.6 ms
64 bytes from 172.31.10.139: icmp_seq=3 ttl=64 time=33.6 ms
64 bytes from 172.31.10.139: icmp_seq=4 ttl=64 time=31.1 ms
^C
--- 172.31.10.139 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 31.121/32.755/33.738/1.044 ms
```

### Traceroutes:
```
student@pop-os:~$ traceroute 192.168.100.2
traceroute to 192.168.100.2 (192.168.100.2), 30 hops max, 60 byte packets
 1  10.8.0.1 (10.8.0.1)  31.453 ms  31.745 ms  32.350 ms
 2  192.168.100.2 (192.168.100.2)  32.350 ms  32.347 ms  32.344 ms
 
student@pop-os:~$ traceroute 192.168.200.2
traceroute to 192.168.200.2 (192.168.200.2), 30 hops max, 60 byte packets
 1  10.8.0.1 (10.8.0.1)  31.405 ms  33.599 ms  34.066 ms
 2  192.168.200.2 (192.168.200.2)  34.759 ms  34.732 ms  34.702 ms
 
student@pop-os:~$ traceroute 172.31.10.139
traceroute to 172.31.10.139 (172.31.10.139), 30 hops max, 60 byte packets
 1  172.31.10.139 (172.31.10.139)  61.052 ms  61.488 ms  64.533 ms
```
