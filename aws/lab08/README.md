eksctl create cluster -f cluster.yml
## 1. Crete the EKS with eksctl and manifest file:
```YML
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: tap-nik-cluster
  region: eu-west-1

iam:
  withOIDC: true

nodeGroups:
  - name: tap-nik-ng-1
    instanceType: t3.small
    minSize: 2
    maxSize: 4
    desiredCapacity: 2
    volumeSize: 20
    privateNetworking: true
    iam:
      withAddonPolicies:
        autoScaler: true
        efs: true
    tags:
      # EC2 tags required for cluster-autoscaler auto-discovery
      k8s.io/cluster-autoscaler/enabled: "true"
      k8s.io/cluster-autoscaler/cluster-13: "owned"
```
## 2. Create IAM autoscaler policy and attach it to the role:
```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
```
```
eksctl create iamserviceaccount \
  --cluster=tap-nik-cluster \
  --namespace=kube-system \
  --name=cluster-autoscaler \
  --attach-policy-arn=arn:aws:iam::<account number>:policy/tap-nik-eks-autoscale \
  --override-existing-serviceaccounts \
  --approve \
  --region eu-west-1
```
```bash
kubectl annotate serviceaccount cluster-autoscaler \
  -n kube-system \
  eks.amazonaws.com/role-arn=arn:aws:iam::<account number>:role/eksctl-tap-nik-cluster-addon-iamserviceaccou-Role1-3K15O7OU43JT
```
```
kubectl set image deployment cluster-autoscaler \
  -n kube-system \
  cluster-autoscaler=k8s.gcr.io/autoscaling/cluster-autoscaler:v1.21.2
```
## 3. Create workload:
 - Namespace
 - POD with nginx
```YAML
apiVersion: v1
kind: Namespace
metadata:
  name: nginx-app

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: nginx-app
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: public.ecr.aws/nginx/nginx:latest
        ports:
        - name: http
          containerPort: 80
```

## 4. Create IAM policy for the AWS Load Balancer Controller and attach to role
```
aws iam create-policy \
    --policy-name AWSLoadBalancerController-NIK-Policy \
    --policy-document file://iam_policy.json
```
```
eksctl create iamserviceaccount \
  --cluster=tap-nik-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::<....>:policy/AWSLoadBalancerController-NIK-Policy \
  --override-existing-serviceaccounts \
  --approve \
  --region eu-west-1
```
## 5. Install cert-manager and the AWS Load Balancer Controller
```bash
kubectl apply \
    --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
```
```bash
kubectl apply -f v2_3_1_full.yaml
```
### we can see the controller is available:
```bash
~/Work/TAP/aws/lab08$ kubectl get deployment -n kube-system aws-load-balancer-controller
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
aws-load-balancer-controller   1/1     1            1           16s
```
## 6. Create NodePort service and Ingress:
```YAML
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: nginx-app
  labels:
    app: nginx
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

---

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: nginx-app
  name: nginx-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
    - http:
        paths:
          - path: /*
            backend:
              serviceName: nginx-service
              servicePort: 80
```
## 7. Now we can access the loadbalancer and we see it forwards the traffic to the POD
```bash
~/Work/TAP/aws/lab08$ curl k8s-nginxapp-nginxing-78032f9e43-385127802.eu-west-1.elb.amazonaws.com
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```