## 1. Enable minikube metrics-server addon:
```bash
minikube addons enable metrics-server
    ▪ Using image k8s.gcr.io/metrics-server/metrics-server:v0.4.2
```
## 2. Creating new namespace:
```YAML
kind: Namespace
apiVersion: v1
metadata:
  name: mem-default
```
## 3. Create POD via YAML deployment:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: memstress
  namespace: mem-default
spec:
  selector:
    matchLabels:
      app: memtest
  replicas: 1
  template:
    metadata:
      labels:
        app: memtest
    spec:
      containers:
      - name: polinuxstress
        image: polinux/stress
        resources:
          requests:
            memory: 100Mi
          limits:
            memory: 200Mi
        command: ["/usr/local/bin/stress"]
        args: ["--vm", "1", "--vm-bytes", "150M", "--vm-hang", "1"]
```
## 4. Detailed information for the POD where you can see namespace and memory limits and requests:
```bash
kubectl describe pod memstress-5f9d744d7-wh5px --namespace=mem-default
Name:         memstress-5f9d744d7-wh5px
Namespace:    mem-default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Wed, 15 Dec 2021 14:20:53 +0200
Labels:       app=memtest
              pod-template-hash=5f9d744d7
Annotations:  <none>
Status:       Running
IP:           172.17.0.4
Containers:
    State:          Running
      Started:      Wed, 15 Dec 2021 14:20:58 +0200
    Ready:          True
    Restart Count:  0
    Limits:
      memory:  200Mi
    Requests:
      memory:     100Mi
```
## 5. With top we can see CPU and memory for the POD:
```bash
kubectl top pod memstress-5f9d744d7-wh5px --namespace=mem-default 
W1215 14:23:57.867376    3302 top_pod.go:140] Using json format to get metrics. Next release will switch to protocol-buffers, switch early by passing --use-protocol-buffers flag
NAME                        CPU(cores)   MEMORY(bytes)   
memstress-5f9d744d7-wh5px   69m          150Mi           
```