## 1. Create the chart with:
```bash
helm create task17chart
Creating task17chart
```
## 2. Clean up and edit the chart files:
### Chart.yaml
```YAML
apiVersion: v2
name: task17chart
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1"
```
### values.yaml
```YAML
image:
  repository: nginx
  tag: latest
```
### deployment.yaml
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginxchart
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
```
## 3. Install the app using Chart and helm:
```bash
helm install task17chart task17chart
NAME: task17chart
LAST DEPLOYED: Tue Dec 21 10:58:02 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```
## 4. List releases and check deployment in our cluster:
```bash
helm list
NAME       	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART            	APP VERSION
task17chart	default  	1       	2021-12-21 10:58:02.358979 +0200 EET	deployed	task17chart-0.1.0	1

kubectl get all
NAME                              READY   STATUS    RESTARTS   AGE
pod/nginxchart-569b6f895d-tvkjb   1/1     Running   0          3m39s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d22h

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginxchart   1/1     1            1           3m39s

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/nginxchart-569b6f895d   1         1         1       3m39s
```
## 5. Change the image to redis, we can see the Revision incremented:
```bash
helm upgrade task17chart task17chart
Release "task17chart" has been upgraded. Happy Helming!
NAME: task17chart
LAST DEPLOYED: Tue Dec 21 11:08:16 2021
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None
```