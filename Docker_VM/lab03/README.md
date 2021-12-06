### Installed NGINX with following config

```
server {
  listen 192.168.1.103:8000;
  root /home/niki/Documents/server/hextris/;
  
  ssl on;
  ssl_certificate /home/niki/Documents/server/certs/cert.pem;
  ssl_certificate_key /home/niki/Documents/server/certs/privkey.pem;
}
```
