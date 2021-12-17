## 1. As we are using minikube we will open shell to our node and create new dir /mnt/data:
```bash
minikube ssh
docker@minikube:/mnt$ sudo mkdir data
docker@minikube:/mnt/data$ pwd
/mnt/data
```
## 2. Now we will create hostpath PersistentVolume with size 2G:
```YAML
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
```
```bash
kubectl get pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
pv-volume   2Gi        RWO            Retain           Available           manual                  13s
```
## 3. Create PVC:
```YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```
```
kubectl get pvc
NAME             STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mysql-pv-claim   Bound    pv-volume   2Gi        RWO            manual         5s
```
## 4. Deploy the POD with MySQL image using volume:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deploy
spec:
  selector:
    matchLabels:
      app: mysqldb
  replicas: 1
  template:
    metadata:
      labels:
        app: mysqldb
    spec:
      volumes:
        - name: mysql-pv-storage
          persistentVolumeClaim:
            claimName: mysql-pv-claim
      containers:
        - name: mysql
          image: mysql:5.6
          ports:
            - containerPort: 3306
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: qwerty
          volumeMounts:
            - mountPath: "/var/lib/mysql"
              name: mysql-pv-storage
```
```bash
kubectl get all
NAME                                READY   STATUS    RESTARTS   AGE
pod/mysql-deploy-7d6cc58d6f-559mx   1/1     Running   0          3s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   2d3h

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mysql-deploy   1/1     1            1           2m23s
```
## 5. In order to use DNS we need to bind ClusterIP service to our POD. THe name of the service is very important as this will be the domain name:
```YAML
apiVersion: v1
kind: Service
metadata:
  name: mysql-srv
  labels:
    app: mysql
spec:
  type: ClusterIP 
  ports:
  - port: 3306
  selector:
    app: mysqldb
```
```bash
kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP    2d3h
mysql-srv    ClusterIP   10.100.89.234   <none>        3306/TCP   8s
```
## 6. Verify that the Persistent Volume works. Connect to minikube and check the /mnt/data:
```bash
minikube ssh
Last login: Fri Dec 17 14:25:05 2021 from 192.168.49.1
docker@minikube:~$ ls /mnt/data/
auto.cnf  ib_logfile0  ib_logfile1  ibdata1  mysql  performance_schema
```
## 7. Verify that ClusterIP service and DNS are working.
    - ### First we create new POD with alpine linux:
```bash
kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
alpine-5d888845dd-zstmw         1/1     Running   0          9m5s
mysql-deploy-7d6cc58d6f-559mx   1/1     Running   0          16m
```
    - ### Attach to the alpine linux and use netcat to check if port 3306 on mysql-srv is open:
```bash
kubectl exec -it alpine-5d888845dd-zstmw -- sh
/ # nc -vz mysql-srv 3306
mysql-srv (10.100.89.234:3306) open
```
   ### As you can see it resolved the mysql-srv to 10.100.89.234 which is the correct IP for the ClusterIP service.