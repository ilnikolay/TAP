# 1. IP address and netstat for nsA

```
ec2-user@ip-172-31-10-139 conf.d]$ sudo ip netns exec nsA ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
3: veth-A@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 32:55:ac:dd:fb:1c brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.100.2/28 scope global veth-A
       valid_lft forever preferred_lft forever
    inet6 fe80::3055:acff:fedd:fb1c/64 scope link 
       valid_lft forever preferred_lft forever
 ```
 ## Netstat
 ```
 [ec2-user@ip-172-31-10-139 conf.d]$ sudo ip netns exec nsA netstat -tupan
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 192.168.100.2:80        0.0.0.0:*               LISTEN      2655/python3  
```

# 2. IP address and netstat for nsB
```
[ec2-user@ip-172-31-10-139 conf.d]$ sudo ip netns exec nsB ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
5: veth-B@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 36:d8:17:a0:3e:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.200.2/28 scope global veth-B
       valid_lft forever preferred_lft forever
    inet6 fe80::34d8:17ff:fea0:3e02/64 scope link 
       valid_lft forever preferred_lft forever
```
## Netstat
```
[ec2-user@ip-172-31-10-139 conf.d]$ sudo ip netns exec nsB netstat -tupan
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 192.168.200.2:81        0.0.0.0:*               LISTEN      2693/python3        
```
