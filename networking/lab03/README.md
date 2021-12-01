1. Together with server1 from LAB01 created new server listening on localhost:81 with following config:
```
server {
  listen  127.0.0.1:81;
  index   index.html;
  
  root    /home/ec2-user/websrv1/;
}
```
2. Will reuse the proxy.conf from LAB02 and will add load balancing functionality to it:
```
upstream backendservers {
	server 127.0.0.1:80;
	server 127.0.0.1:81;
}

server {
  listen 172.31.10.24:8080;
  server_name _;
  
  location / {
    proxy_pass http://backendservers/;
  }
}
```
3. There is tcpdump capture log.
```
tcpbump -vv -i lo

Request to port 80:
11:02:31.863015 IP (tos 0x0, ttl 64, id 22406, offset 0, flags [DF], proto TCP (6), length 60)
    localhost.53482 > localhost.http: Flags [S], cksum 0xfe30 (incorrect -> 0xb514), seq 1993793290, win 65495, options [mss 65495,sackOK,TS val 2849032704 ecr 0,nop,wscale 7], length 0

Request to port 81:
11:02:34.832179 IP (tos 0x0, ttl 64, id 5145, offset 0, flags [DF], proto TCP (6), length 60)
    localhost.49920 > localhost.81: Flags [S], cksum 0xfe30 (incorrect -> 0xb9e6), seq 133516138, win 65495, options [mss 65495,sackOK,TS val 2849035673 ecr 0,nop,wscale 7], length 0
```
5. Here is a netstat:

![netstat](https://github.com/ilnikolay/TAP/blob/main/networking/lab03/Screenshot%202021-12-01%20at%2012.58.43.png?raw=true "netstat")
