## 1. Create Service Account test-user with manifest file:
```YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test-user
```
## 2. Create the Role that will have only POD access:
```YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-access
rules:
- apiGroups: [""]
  resources: ["pods", "pods/exec"]
  verbs: ["get", "watch", "list", "create", "delete"]
```
## 3. Create the Rolebind in default name space that binds Service Account to the Role:
```YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: access-pods
  namespace: default
subjects:
- kind: ServiceAccount
  name: test-user
roleRef:
  kind: Role
  name: pod-access
  apiGroup: rbac.authorization.k8s.io
```
## 4. Deploy a POD with kubectl installed on it. With Service Account name test-user:
```YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bitnamikubectl
spec:
  selector:
    matchLabels:
      app: podkubectl
  replicas: 1
  template:
    metadata:
      labels:
        app: podkubectl
    spec:
      containers:
      - name: bitnami
        image: bitnami/kubectl
        command: ["/bin/sleep", "1d"]
      serviceAccountName: test-user
```
## 5. Attach to the pod and perform kubectl get pods:
```bash
kubectl exec -it bitnamikubectl-6c4d7d44cd-flsww bash
I have no name!@bitnamikubectl-6c4d7d44cd-flsww:/$ kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
bitnamikubectl-6c4d7d44cd-flsww   1/1     Running   0          46s
```
## 6. Perform kubectl command related to deployment and we see that we dont have access:
```bash
I have no name!@bitnamikubectl-6c4d7d44cd-flsww:/$ kubectl get deployments
Error from server (Forbidden): deployments.apps is forbidden: User "system:serviceaccount:default:test-user" cannot list resource "deployments" in API group "apps" in the namespace "default"
```
## 7. Check the auth can-i inside the POD:
```bash
I have no name!@bitnamikubectl-6c4d7d44cd-flsww:/$ kubectl auth can-i delete pods --namespace=default
yes
I have no name!@bitnamikubectl-6c4d7d44cd-flsww:/$ kubectl auth can-i delete deployment --namespace=default
no
```