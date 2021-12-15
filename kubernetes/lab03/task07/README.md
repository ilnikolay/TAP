# 1. Using declarative approach:
## 1. Deployment YAML file:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  selector:
    matchLabels:
      app: webapp
  replicas: 1
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: k8s-static-web-app
        image: joji95/k8s-static-web-app
        ports:
        - containerPort: 80
```
## 2. NodePort Service YAML file:
```YAML
apiVersion: v1
kind: Service
metadata:
  name: frontend
  labels:
    app: webapp
spec:
  type: NodePort 
  ports:
  - port: 8080
    targetPort: 80
  selector:
    app: webapp
```
## 3. Starting tunnel with minikube host to service:
```bash
minikube service --url frontend
```
## 4. Oprah Winfrey gives away k8s clusters :D

# 2. Using imperative approach:
## 1. Create deployment:
```bash
kubectl create deployment frontend --image=joji95/k8s-static-web-app --port=80
```
## 2. Create the NodePort service and expose the deployment
```bash
kubectl expose deployment frontend --protocol=TCP --port=8080 --target-port=80 --name=frontendsrv --type=NodePort
```
## 3. Starting tunnel with minikube host to service:
```bash
minikube service --url frontendsrv
```
## 4. Oprah Winfrey gives away k8s clusters :D