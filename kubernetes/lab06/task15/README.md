## Bash script that pings 5 times env variable MY_HOST
```bash
#!/usr/bin/env bash
while true; do
    ping -c5 $MY_HOST
    sleep 5
done
```
## 2. Create Docker image from bash and push to docker hub:
```Dockerfile
FROM bash:5

WORKDIR /app

COPY ./pinger.sh /app/

CMD ["bash", "pinger.sh"]
```
## 3. ConfigMap and POD YAML config files:
```YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap-pinger
data:
  # property-like keys; each key maps to a simple value
  host_name: "google.com"
```
### Scenario one Use configmap values as env variable on the pod
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pinger-deploy
spec:
  selector:
    matchLabels:
      app: pinger
  replicas: 1
  template:
    metadata:
      labels:
        app: pinger
    spec:
      containers:
        - name: pingerapp
          image: ilniko/pinger
          env:
            - name: MY_HOST
              valueFrom:
                configMapKeyRef:
                  name: configmap-pinger
                  key: host_name
```
#### We can see that the script pings google.com:
```bash
 kubectl logs pinger-deploy-5ddc6ff99c-9ltcj
PING google.com (142.250.187.174): 56 data bytes
64 bytes from 142.250.187.174: seq=0 ttl=36 time=4.128 ms
64 bytes from 142.250.187.174: seq=1 ttl=36 time=11.164 ms
64 bytes from 142.250.187.174: seq=2 ttl=36 time=3.673 ms
64 bytes from 142.250.187.174: seq=3 ttl=36 time=10.771 ms
64 bytes from 142.250.187.174: seq=4 ttl=36 time=11.896 ms
```
### Edit the POD YAML to run printenv MY_HOST
```YAML
          command: ["printenv"]
          args: ["MY_HOST"]
```
### Now it doesn't do the ping script as it changes the CMD from docker image with printenv, and only prints MY_HOST:
```bash
kubectl logs pinger-deploy-7c94d959d8-n2txc
google.com
```

### Scenario using Volumes:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pinger-deploy
spec:
  selector:
    matchLabels:
      app: pinger
  replicas: 1
  template:
    metadata:
      labels:
        app: pinger
    spec:
      volumes:
        - name: configmap-volume
          configMap:
            name: configmap-pinger
      containers:
        - name: pingerapp
          image: ilniko/pinger
          volumeMounts:
            - name: configmap-volume
              mountPath: /etc/pinger
```
#### We can see that there are no env variable MY_HOST but a file mounted in /etc/pinger:
```bash
kubectl exec -it pinger-deploy-56ff7f7d7b-tqjm4 -- bash
bash-5.1# ls /etc/pinger/
host_name
bash-5.1# cat /etc/pinger/host_name 
google.com
```