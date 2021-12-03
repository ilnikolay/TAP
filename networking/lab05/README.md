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

## Enable forwarding:
```
sudo sysctl -w net.ipv4.ip_forward=1
```

## Create the proxy and load balancer using NGINX in default namespace.
```
upstream backendservers {
        server 192.168.100.2:80;
        server 192.168.200.2:81;
}

server {
  listen 172.31.10.139:8080;
  server_name _;
  
  location / {
    proxy_pass http://backendservers/;
  }
}
```

# 4. We will use openVPN, also it comes with easyrsa, that will use to create PKI and necessary certs and keys.

## First build PKI folder and CA:
```
[ec2-user@ip-172-31-10-139 easy-rsa]$ ./easyrsa init-pki
[ec2-user@ip-172-31-10-139 easy-rsa]$ ./easyrsa build-ca
/home/ec2-user/easy-rsa/pki/ca.crt
```
## Create server private key and request for certificate for public key:
```
[ec2-user@ip-172-31-10-139 easy-rsa]$ ./easyrsa gen-req server1 nopass
req: /home/ec2-user/easy-rsa/pki/reqs/server1.req
key: /home/ec2-user/easy-rsa/pki/private/server1.key
```
## Sign the request for cert:
```
[ec2-user@ip-172-31-10-139 easy-rsa]$ ./easyrsa sign-req server server1
Certificate: /home/ec2-user/easy-rsa/pki/issued/server1.crt
```

## We need to repeat same steps for the client side:
```
[ec2-user@ip-172-31-10-139 easy-rsa]$ ./easyrsa gen-req client1 nopass
req: /home/ec2-user/easy-rsa/pki/reqs/client1.req
key: /home/ec2-user/easy-rsa/pki/private/client1.key

[ec2-user@ip-172-31-10-139 easy-rsa]$ ./easyrsa sign-req client client1
Certificate: /home/ec2-user/easy-rsa/pki/issued/client1.crt
```

## Generate Diffie-Hellman parameters:
```
[ec2-user@ip-172-31-10-139 easy-rsa]$ ./easyrsa gen-dh
DH parameters of size 2048 created at /home/ec2-user/easy-rsa/pki/dh.pem
```

## Create server.conf and copy ca.crt, server1.crt, server1.key and dh.pem to /etc/openvpn/
### server.conf
```
local 172.31.10.139
port 1194
proto udp
dev tun
ca ca.crt
cert server1.crt
key server1.key  # This file should be kept secret
dh dh.pem
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "route 192.168.100.0 255.255.255.240"
push "route 192.168.200.0 255.255.255.240"
push "route 172.31.0.0 255.255.240.0"
keepalive 10 120
cipher AES-256-CBC
persist-key
persist-tun
status openvpn-status.log
verb 3
explicit-exit-notify 1
```
## Create client.ovpn file
```
client
dev tun
proto udp
remote 18.194.37.2 1194
nobind
user nobody
group nobody
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
verb 3
<ca>
-----BEGIN CERTIFICATE-----
        ......
-----END CERTIFICATE-----
</ca>
<cert>
-----BEGIN CERTIFICATE-----
        ......
-----END CERTIFICATE-----
</cert>
<key>
-----BEGIN PRIVATE KEY-----
        ......
-----END PRIVATE KEY-----
</key>
```

## Start the openvpn server with server.conf
```
systemctl start openvpn@server
```
