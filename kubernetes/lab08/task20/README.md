## 1. Check the hostname label for each NODE:
```bash
kubectl get nodes  -L kubernetes.io/hostname
NAME           STATUS   ROLES                  AGE     VERSION   HOSTNAME
minikube       Ready    control-plane,master   7d1h    v1.22.3   minikube
minikube-m02   Ready    <none>                 3h24m   v1.22.3   minikube-m02
```
## 2. We will match hostname affinity to our second node  minikube-m02:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                - minikube-m02
```
## 3. We can see that both PODs are running on the node with hostname=minikube-m02
```bash
kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
nginx-6bc576848c-5rcv5   1/1     Running   0          7s    172.17.0.2   minikube-m02   <none>           <none>
nginx-6bc576848c-tggt4   1/1     Running   0          7s    172.17.0.3   minikube-m02   <none>           <none>
```