## 1. Will reuse the name space from task08 and now just create new POD
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
            memory: 50Mi
          limits:
            memory: 100Mi
        command: ["/usr/local/bin/stress"]
        args: ["--vm", "1", "--vm-bytes", "250M", "--vm-hang", "1"]
```
## 2. Get information for the POD. We can see that it is constantly restarted and killed:
```JSON
kubectl get pod memstress-695ffb7568-cfghx -o=json  --namespace=mem-default
        "containerStatuses": [
            {
                "containerID": "docker://160c7bd241604ebd3da116a05e8eae17c239fc132b54e633a0bc2fe5ff19454f",
                "image": "polinux/stress:latest",
                "imageID": "docker-pullable://polinux/stress@sha256:b6144f84f9c15dac80deb48d3a646b55c7043ab1d83ea0a697c09097aaad21aa",
                "lastState": {
                    "terminated": {
                        "containerID": "docker://1afd78be0d037dc72ac1c88f207a8afe54091a879693501525e62d6430d2414c",
                        "exitCode": 1,
                        "finishedAt": "2021-12-15T13:05:11Z",
                        "reason": "OOMKilled",
                        "startedAt": "2021-12-15T13:05:11Z"
                    }
                },
                "name": "polinuxstress",
                "ready": false,
                "restartCount": 4,
                "started": false,
                "state": {
                    "terminated": {
                        "containerID": "docker://160c7bd241604ebd3da116a05e8eae17c239fc132b54e633a0bc2fe5ff19454f",
                        "exitCode": 1,
                        "finishedAt": "2021-12-15T13:06:06Z",
                        "reason": "OOMKilled",
                        "startedAt": "2021-12-15T13:06:06Z"
                    }
                }
            }
        ],
```
