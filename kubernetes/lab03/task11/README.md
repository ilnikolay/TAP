## 1. We will reuse the namespace from task10. And will only create new POD with stress test:
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
            cpu: 100
          limits:
            cpu: 100
        args: ["-cpus", "2"]
```
## 2. We can see POD cannot be deployed:
```bash
kubectl get all --namespace=cpu-default 
NAME                             READY   STATUS    RESTARTS   AGE
pod/cpustress-58bb95cfdd-sj7sf   0/1     Pending   0          19s
```
## 3. From kubectl describe pod we see the reason is Insufficient cpu:
```bash
Name:           cpustress-58bb95cfdd-sj7sf
Namespace:      cpu-default
Priority:       0
Node:           <none>
Labels:         app=cputest
                pod-template-hash=58bb95cfdd
Annotations:    <none>
Status:         Pending
IP:             
IPs:            <none>
Controlled By:  ReplicaSet/cpustress-58bb95cfdd
Containers:
  vishstress:
    Image:      vish/stress
    Port:       <none>
    Host Port:  <none>
    Args:
      -cpus
      2
    Limits:
      cpu:  100
    Requests:
      cpu:        100
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-pfb8q (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  kube-api-access-pfb8q:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  56s   default-scheduler  0/1 nodes are available: 1 Insufficient cpu.
```