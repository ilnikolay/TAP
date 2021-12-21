## 1. Create a helm chart:
### Values YAML
```YAML
image:
  repository: nginx
  tag: latest

namespace: test
var1: 5
var2: 6
```
### Namespace YAML
```YAML
kind: Namespace
apiVersion: v1
metadata:
  name: {{ .Values.namespace}}
```
### ConfigMap YAML
```YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Chart.Name }}-configmap
  namespace: {{ .Values.namespace }}
data:
  var1: "{{ .Values.var1 }}"
```
### Secret YAML
```YAML
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Chart.Name }}-secret
  namespace: {{ .Values.namespace }}
type: Opaque
stringData:
  var2: "{{ .Values.var2 }}"
```
### Deployment YAML
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: {{ .Values.namespace }}
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
          env:
            - name: myvar
              valueFrom:
                configMapKeyRef:
                  name: {{ .Chart.Name }}-configmap
                  key: var1
            - name: myvar2
              valueFrom:
                secretKeyRef:
                  name: {{ .Chart.Name }}-secret
                  key: var2
```

## 2. Install the chart:
```bash
helm install task18chart task18chart
NAME: task18chart
LAST DEPLOYED: Tue Dec 21 12:18:46 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None

helm list
NAME       	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART            	APP VERSION
task17chart	default  	2       	2021-12-21 11:08:16.214572 +0200 EET	deployed	task17chart-0.1.0	1          
task18chart	default  	1       	2021-12-21 12:18:46.789002 +0200 EET	deployed	task18chart-0.1.0	1.16.0  
```
## 3. Check if it is deployed in the cluster:
```bash
kubectl -n test get all
NAME                                READY   STATUS    RESTARTS   AGE
pod/nginx-deploy-68d6df9f9c-gznj5   1/1     Running   0          73s

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deploy   1/1     1            1           73s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deploy-68d6df9f9c   1         1         1       73s
```
## 4. Check env variables inside the container
```bash
kubectl -n test exec nginx-deploy-68d6df9f9c-gznj5 -- printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=nginx-deploy-68d6df9f9c-gznj5
myvar=5
myvar2=6
KUBERNETES_PORT_443_TCP_PROTO=tcp
```