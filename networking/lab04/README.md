1. Created two network namespaces and veth interfaces with ip addresses 192.168.100.1 and 192.168.200.1 in /28 networks:

#nsA namespace:
```
[ec2-user@ip-172-31-10-24 conf.d]$ sudo ip netns exec nsA ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
3: veth-A@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether fe:4d:29:02:d9:01 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.100.1/28 scope global veth-A
       valid_lft forever preferred_lft forever
    inet6 fe80::fc4d:29ff:fe02:d901/64 scope link 
       valid_lft forever preferred_lft forever
```

#nsB namespace:
```
[ec2-user@ip-172-31-10-24 conf.d]$ sudo ip netns exec nsB ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
5: veth-B@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 52:82:01:e8:f3:e5 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.200.1/28 scope global veth-B
       valid_lft forever preferred_lft forever
    inet6 fe80::5082:1ff:fee8:f3e5/64 scope link 
       valid_lft forever preferred_lft forever
```

2. Assigned IP addresses to the two global/default veth interfaces and made them defaulth gateways.
3. Enabled ip forwarding on the linux machine:
``` 
sysctl -w net.ipv4.ip_forward=1
```
4. Ran traceroute from nsA to nsB:
```
[ec2-user@ip-172-31-10-24 conf.d]$ sudo ip netns exec nsA traceroute 192.168.200.1
traceroute to 192.168.200.1 (192.168.200.1), 30 hops max, 60 byte packets
 1  gateway (192.168.100.2)  0.039 ms  0.005 ms  0.003 ms
 2  192.168.200.1 (192.168.200.1)  0.018 ms  0.006 ms  0.005 ms
 ```
