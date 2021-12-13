## 1. You can specify CPU and memory resoureces allocated to the minikube node. by default it is 2 CPUs and 2G of memory.
### Set them to default values
```bash
minikube config set memory 4096 
minikube config set cpus 4
minikube start
```
### Set just for one instance
```bash
minikube start --memory 4096 --cpus 4
```
## 2. List all services ion the cluster
```bash
kubectl get services
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   8m58s
```
### View detailed information on services
```bash
kubectl describe services kubernetes
Name:              kubernetes
Namespace:         default
Labels:            component=apiserver
                   provider=kubernetes
Annotations:       <none>
Selector:          <none>
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.96.0.1
IPs:               10.96.0.1
Port:              https  443/TCP
TargetPort:        8443/TCP
Endpoints:         192.168.49.2:8443
Session Affinity:  None
Events:            <none>
```

## 3. List all pods in the cluster:
```bash
kubectl get pods -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS      AGE
default       nginx-dpfile-6998699cfc-5tvmt      1/1     Running   0             13m
default       nginx-lab-f6bc678c8-jsqq9          1/1     Running   0             60m
kube-system   coredns-78fcd69978-rzvfq           1/1     Running   0             86m
kube-system   etcd-minikube                      1/1     Running   0             86m
kube-system   kube-apiserver-minikube            1/1     Running   0             86m
kube-system   kube-controller-manager-minikube   1/1     Running   0             86m
kube-system   kube-proxy-t472w                   1/1     Running   0             86m
kube-system   kube-scheduler-minikube            1/1     Running   0             86m
kube-system   storage-provisioner                1/1     Running   1 (85m ago)   86m
```
### View detailed information on pods:
```bash
kubectl describe pods nginx-lab-f6bc678c8-jsqq9
Name:         nginx-lab-f6bc678c8-jsqq9
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Mon, 13 Dec 2021 14:28:17 +0200
Labels:       app=nginx-lab
              pod-template-hash=f6bc678c8
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:           172.17.0.3
Controlled By:  ReplicaSet/nginx-lab-f6bc678c8
```
