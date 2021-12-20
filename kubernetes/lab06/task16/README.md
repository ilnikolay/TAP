## 1. We reuse the docker image from previous task.
## 2. Create the secret with YAML:
```YAML
apiVersion: v1
kind: Secret
metadata:
  name: pinger-secret
type: Opaque
stringData:
  host_name: google.com
```
## 3. Create the POD deployment:
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
                secretKeyRef:
                  name: pinger-secret
                  key: host_name
```
## 4. We can see log from the POD:
```bash
kubectl logs pinger-deploy-c4dc5c8fc-x9s6p
PING google.com (172.217.169.174): 56 data bytes
64 bytes from 172.217.169.174: seq=0 ttl=36 time=5.533 ms
64 bytes from 172.217.169.174: seq=1 ttl=36 time=11.270 ms
64 bytes from 172.217.169.174: seq=2 ttl=36 time=4.747 ms
64 bytes from 172.217.169.174: seq=3 ttl=36 time=14.172 ms
64 bytes from 172.217.169.174: seq=4 ttl=36 time=13.150 ms
```
## 5. Edit the deployment to run printenv to display the value of MY_HOST
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
          command: ["printenv"]
          args: ["MY_HOST"]
          env:
            - name: MY_HOST
              valueFrom:
                secretKeyRef:
                  name: pinger-secret
                  key: host_name
```
### We can see that it runs only printenv, because it replaced the CMD from the docker image:
```bash
kubectl logs pinger-deploy-55f46c99c4-9mlxz
google.com
```
## 6. Scenario two with mount and Volumes. Create the deployment:
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
          secret:
            secretName: pinger-secret
      containers:
        - name: pingerapp
          image: ilniko/pinger
          volumeMounts:
            - name: configmap-volume
              mountPath: /etc/pinger
```
### We can see that we mounted a file in /etc/pinger. And there is no MY_HOST env variable.
```bash
kubectl exec -it pinger-deploy-686b85b884-b2g2h -- bash
bash-5.1# ls /etc/pinger/
host_name
bash-5.1# cat /etc/pinger/host_name 
google.com
```