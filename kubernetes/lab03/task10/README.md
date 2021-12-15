## 1. Create new namespace:
```YAML
kind: Namespace
apiVersion: v1
metadata:
  name: cpu-default
```
```bash
kubectl get namespaces 
NAME              STATUS   AGE
cpu-default       Active   6m51s
default           Active   4h
kube-node-lease   Active   4h
kube-public       Active   4h
kube-system       Active   4h
```
## 2. Creating POD with the CPU stress test:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpustress
  namespace: cpu-default
spec:
  selector:
    matchLabels:
      app: cputest
  replicas: 1
  template:
    metadata:
      labels:
        app: cputest
    spec:
      containers:
      - name: vishstress
        image: vish/stress
        resources:
          requests:
            cpu: 0.5
          limits:
            cpu: 1
        args: ["-cpus", "2"]
```
### We can see the POD is running:
```bash
kubectl get all --namespace=cpu-default 
NAME                             READY   STATUS    RESTARTS   AGE
pod/cpustress-5c88cb76f5-pvd62   1/1     Running   0          26s
```
## 3. Here is a snipped of the POD describe:
```bash
kubectl describe pod cpustress-5c88cb76f5-pvd62 --namespace=cpu-default 
Name:         cpustress-5c88cb76f5-pvd62
Namespace:    cpu-default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Wed, 15 Dec 2021 16:20:27 +0200
Labels:       app=cputest
              pod-template-hash=5c88cb76f5
Annotations:  <none>
Status:       Running
IP:           172.17.0.4
Containers:
  vishstress:
    State:          Running
      Started:      Wed, 15 Dec 2021 16:20:31 +0200
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:  1
    Requests:
      cpu:        500m
```
## 4. And from top pod command we can see cpu and memory usage:
```bash
kubectl top pod cpustress-5c88cb76f5-pvd62 --namespace=cpu-default 
W1215 16:22:27.806997    4083 top_pod.go:140] Using json format to get metrics. Next release will switch to protocol-buffers, switch early by passing --use-protocol-buffers flag
NAME                         CPU(cores)   MEMORY(bytes)   
cpustress-5c88cb76f5-pvd62   1002m        1Mi             
```