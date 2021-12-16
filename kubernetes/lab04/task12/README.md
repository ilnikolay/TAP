## 1. Create the docker file with our static html in app folder:
```Dockerfile
FROM nginx:stable-alpine
COPY ./app /usr/share/nginx/html
```
## 2. Build the docker image:
```bash
docker build -t ilniko/statichtml .
[+] Building 0.9s (7/7) FINISHED             
```
## 3. Push the image to our docker hub
```bash
docker image push ilniko/statichtml
```
## 4. Start a tunnel in minikube as we will use Loadbalancer service
```bash
minikube tunnel
```
## 5. Create deployment with YAML file for the static html:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  selector:
    matchLabels:
      app: webapp
  replicas: 1
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: myweb
        image: ilniko/statichtml
        ports:
        - containerPort: 80
```
## 6. Create Loadbalancer service with YAML:
```YAML
apiVersion: v1
kind: Service
metadata:
  name: frontend
  labels:
    app: webapp
spec:
  type: LoadBalancer 
  ports:
  - port: 8080
    targetPort: 80
  selector:
    app: webapp
```
## 7. We can see what External IP was assigned for our Loadbalancer service. In our case is 127.0.0.1 on port 8080:
```bash
NAME                            READY   STATUS    RESTARTS   AGE
pod/frontend-57b957cb78-pcsp9   1/1     Running   0          55s

NAME                 TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/frontend     LoadBalancer   10.97.178.44   127.0.0.1     8080:32591/TCP   47s
service/kubernetes   ClusterIP      10.96.0.1      <none>        443/TCP          22h

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/frontend   1/1     1            1           55s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/frontend-57b957cb78   1         1         1       55s
```
## 8. Open browser and go to 127.0.0.1:8080:
![Original template](https://github.com/ilnikolay/TAP/blob/main/kubernetes/lab04/task12/Original_site.png?raw=true "Original template")

## 9. We attach to the container:
```bash
kubectl exec -it frontend-57b957cb78-pcsp9 /bin/sh
/ # 
```
## 10. Change the index.html in our container /usr/share/nginx/html:
![Edited index](https://github.com/ilnikolay/TAP/blob/main/kubernetes/lab04/task12/edited_site.png "edited index")