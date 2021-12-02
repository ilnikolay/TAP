# 1. Create namespaces, veths and assign IPs:

## Create both namespaces:
```
sudo ip netns add nsA
sudo ip netns add nsB
```


## Create veth links:
```
sudo ip link add eth0-A type veth peer name veth-A
sudo ip link add eth0-B type veth peer name veth-B
```


## Set one end of the veth links to newly created namespaces:
```
sudo ip link set veth-A netns nsA
sudo ip link set veth-B netns nsB
```


## Set the IP addresses for all veth interfaces in nsA, nsB and default NS:
```
sudo ip address add 192.168.100.1/28 dev eth0-A
sudo ip netns exec nsA ip address add 192.168.100.2/28 dev veth-A

sudo ip address add 192.168.200.1/28 dev eth0-B
sudo ip netns exec nsB ip address add 192.168.200.2/28 dev veth-B
```


## Enable all interfaces:
```
sudo ip link set eth0-A up
sudo ip netns exec nsA ip link set dev veth-A up

sudo ip link set eth0-B up
sudo ip netns exec nsB ip link set dev veth-B up
```


## Add default gateways to nsA and nsB:
```
sudo ip netns exec nsA ip route add default via 192.168.100.1 dev veth-A
sudo ip netns exec nsB ip route add default via 192.168.200.1 dev veth-B
```

# 2. Create two servers in nsA and nsB using python3:

```
sudo ip netns exec nsA python3 -m http.server 80 --directory /home/ec2-user/websrv1/ --bind 192.168.100.2
sudo ip netns exec nsB python3 -m http.server 81 --directory /home/ec2-user/websrv2/ --bind 192.168.200.2
```

# 3. NGINX configuration:

## Enable forwarding and non local IPs able to be bind in NGINX:
```
sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.ip_nonlocal_bind=1
```

## Create the proxy and load balancer using NGINX in default namespace. We no longer can use TCP 8080 port, because we will use it for the VPN.
```
upstream backendservers {
        server 192.168.100.2:80;
        server 192.168.200.2:81;
}

server {
  listen 172.31.10.139:80;
  server_name _;
  
  location / {
    proxy_pass http://backendservers/;
  }
}
```

# 4. VPN config TO DO...
