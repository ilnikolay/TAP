## 1. We have two nodes in our cluster:
```bash
kubectl get nodes
NAME           STATUS   ROLES                  AGE     VERSION
minikube       Ready    control-plane,master   6d22h   v1.22.3
minikube-m02   Ready    <none>                 24m     v1.22.3
```
## 2. Taint the worker node:
```bash
kubectl taint nodes minikube-m02 ssd=true:NoSchedule
node/minikube-m02 tainted
NodeName       TaintKey   TaintValue   TaintEffect
minikube       <none>     <none>       <none>
minikube-m02   ssd        true         NoSchedule
```
## 3. Deploy POD with toleration key matching the value:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx-equal
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-eqaul
  template:
    metadata:
      labels:
        app: nginx-eqaul
    spec:
      containers:
      - image: nginx
        name: nginx-eqaul
      tolerations:
      - key: ssd
        value: "true"
        operator: Equal
        effect: "NoSchedule"
```
### We can see that the POD is deployed on the NODE with the taint:
```bash
kubectl get pods -o wide
NAME                           READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
nginx-equal-6db64dd5df-tpqld   1/1     Running   0          52s   172.17.0.2   minikube-m02   <none>           <none>
```
## 4. Deploy a POD with tolaration operator Exist:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx-exist
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-exist
  template:
    metadata:
      labels:
        app: nginx-exist
    spec:
      containers:
      - image: nginx
        name: nginx-exist
      tolerations:
      - key: ssd
        operator: Exists
        effect: "NoSchedule"
```
### We can see both PODs are deployed on tainted NODE:
```bash
kubectl get pods
NAME                           READY   STATUS    RESTARTS   AGE
nginx-equal-6db64dd5df-tpqld   1/1     Running   0          3m59s
nginx-exist-5d665b6fb5-4fwdx   1/1     Running   0          5s
```