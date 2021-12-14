## 1. Create YAML file with the cronjob:
```YAML
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            command:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```
## 2. View Jobs and Cronjobs:
```bash
kubectl get jobs,cronjob
NAME                       COMPLETIONS   DURATION   AGE
job.batch/hello-27324669   1/1           4s         2m43s
job.batch/hello-27324670   1/1           3s         103s
job.batch/hello-27324671   1/1           3s         43s

NAME                  SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/hello   */1 * * * *   False     0        43s             8m5s
```
## 3. We can check the log of that POD of the last job:
```bash
kubectl logs hello-27324671--1-lqnpt
Tue Dec 14 11:11:02 UTC 2021
Hello from the Kubernetes cluster
```
## 4. Delete the cronjob:
```bash
kubectl delete cronjob hello
```
