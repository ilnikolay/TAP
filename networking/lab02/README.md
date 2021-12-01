1. Changed the conf from LAB01 /etc/nginx/conf.d/server1.conf with following config
```
server {
  listen  127.0.0.1:80;
  index   index.html;
  
  root    /home/ec2-user/websrv/;
}
```

2. Then created new proxy.conf file in /etc/nginx/conf.d/ with following config:
```
server {
  listen 172.31.10.24:8080;
  server_name _;
  
  location / {
    proxy_pass http://127.0.0.1:80;
  }
}
```
3. Used tcpdump to capture traffic on port 80 with any interface, you can check whats captured in the output file.
```
sudo tcpdump -i any -vv port 80
```
4. Also there is a screenshot from netstat.
![netstat](https://github.com/ilnikolay/TAP/blob/main/networking/lab02/Screenshot%202021-12-01%20at%2011.48.19.png?raw=true "netstat")
