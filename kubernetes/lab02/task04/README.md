## 1. Create yaml deployment file. We execute sleep for 1d, otherwise POD creashes because of loop:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ubuntu-deployment
  labels:
    app: ubuntu
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ubuntu
  template:
    metadata:
      labels:
        app: ubuntu
    spec:
      containers:
      - name: ubuntu
        image: ubuntu:bionic
        command: ["/bin/sleep", "1d"]
```
## 2. Get information about running deployments on our cluster:
```bash
kubectl get deployment
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
ubuntu-deployment   1/1     1            1           39m
```
## 3. Get more detailed information about deployment:
```bash
kubectl describe deployments ubuntu-deployment
Name:                   ubuntu-deployment
Namespace:              default
CreationTimestamp:      Tue, 14 Dec 2021 11:35:41 +0200
Labels:                 app=ubuntu
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=ubuntu
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=ubuntu
  Containers:
   ubuntu:
    Image:      ubuntu:bionic
    Port:       <none>
    Host Port:  <none>
    Command:
      /bin/sleep
      1d
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   ubuntu-deployment-6c65959c77 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  41m   deployment-controller  Scaled up replica set ubuntu-deployment-cbc49c95c to 1
  Normal  ScalingReplicaSet  10m   deployment-controller  Scaled up replica set ubuntu-deployment-6c65959c77 to 1
  Normal  ScalingReplicaSet  10m   deployment-controller  Scaled down replica set ubuntu-deployment-cbc49c95c to 0
  ```
## 4. We can scale up the number of PODs using few different options. Also scaling doesn't create new Replicaset:
### 1. kubectl scale deploy ubuntu-deployment --replicas=6
### 2. kubectl edit deployments ubuntu-deployment
### 3. Apply new yaml file
```bash
kubectl get deployment,rs,pod
NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ubuntu-deployment   6/6     6            6           46m

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/ubuntu-deployment-6c65959c77   6         6         6       16m
replicaset.apps/ubuntu-deployment-cbc49c95c    0         0         0       46m

NAME                                     READY   STATUS    RESTARTS   AGE
pod/ubuntu-deployment-6c65959c77-9z882   1/1     Running   0          16m
pod/ubuntu-deployment-6c65959c77-fvls6   1/1     Running   0          11s
pod/ubuntu-deployment-6c65959c77-h2bcp   1/1     Running   0          11s
pod/ubuntu-deployment-6c65959c77-hvv9n   1/1     Running   0          11s
pod/ubuntu-deployment-6c65959c77-rnmjd   1/1     Running   0          11s
pod/ubuntu-deployment-6c65959c77-tpf55   1/1     Running   0          11s
```
## 5. Delete deployment:
```bash
kubectl delete deployments ubuntu-deployment
```
