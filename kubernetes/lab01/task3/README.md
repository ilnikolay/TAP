## 1. Create a pod from image nginx:stable on port 80 using imperative kubectl command:
```bash
kubectl create deployment nginx-lab --image=nginx:stable --port=80
deployment.apps/nginx-lab created
```
## 2. Create a pod from image nginx:stable on port 80 using declerative configuration file:
### First we create the YAML file with the config:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-dpfile
  name: nginx-dpfile
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-dpfile
  template:
    metadata:
      labels:
        app: nginx-dpfile
    spec:
      containers:
      - image: nginx:stable
        name: nginx
        ports:
        - containerPort: 80
          protocol: TCP
```

### We run kubectl apply
```bash
kubectl apply -f nginx_deply.yml
deployment.apps/nginx-dpfile created
```
### And now we have two PODs one created with imperative approach and one with declerative:
```bash
kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
nginx-dpfile-6998699cfc-5tvmt   1/1     Running   0          28s
nginx-lab-f6bc678c8-jsqq9       1/1     Running   0          46m
```
