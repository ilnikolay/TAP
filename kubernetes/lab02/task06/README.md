## 1. Creating Jobs using YAML file that spaws 5 PODs with busybox
```YAML
apiVersion: batch/v1
kind: Job
metadata:
  name: echojob
spec:
  completions: 5
  template:
    metadata:
      name: echojob
    spec:
      containers:
      - name: echojob
        image: busybox
        command: ["/bin/sh", "-c"]
        args: ["for i in 1 2 3; do echo Random messages!!!; sleep 1; done"]
      restartPolicy: OnFailure
```
## 2. Here are PODs completed and the JOB:
```bash
kubectl get jobs,pods
NAME                COMPLETIONS   DURATION   AGE
job.batch/echojob   5/5           30s        15m

NAME                   READY   STATUS      RESTARTS   AGE
pod/echojob--1-5dwjx   0/1     Completed   0          14m
pod/echojob--1-g4ljl   0/1     Completed   0          15m
pod/echojob--1-mrj7w   0/1     Completed   0          14m
pod/echojob--1-s8vcf   0/1     Completed   0          14m
pod/echojob--1-v6mxv   0/1     Completed   0          14m
```
## 3. Also log from one POD:
```bash
kubectl logs echojob--1-g4ljl
Random messages!!!
Random messages!!!
Random messages!!!
```
