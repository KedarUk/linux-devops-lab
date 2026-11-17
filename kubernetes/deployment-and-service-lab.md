# Deploy a web app with Kubernetes

**Goal:** Deploy two web-server replicas and reach them through a Kubernetes Service without exposing the app publicly.

**Prerequisites:** `kubectl` configured for a local practice cluster such as kind or minikube. Check the target before making changes:

```bash
kubectl config current-context
kubectl cluster-info
```

Use a disposable learning cluster, not a production context.

## 1. Save the manifest

Create a file named `web.yaml` with these three resources. The dedicated namespace keeps the lab's objects together.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: devops-lab
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: devops-lab
spec:
  replicas: 2
  selector:
    matchLabels:
      app: demo-web
  template:
    metadata:
      labels:
        app: demo-web
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
          ports:
            - name: http
              containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: devops-lab
spec:
  type: ClusterIP
  selector:
    app: demo-web
  ports:
    - name: http
      port: 80
      targetPort: http
```

The Deployment keeps two matching Pods running. The Service selects those Pods by label and gives them a stable in-cluster address.

## 2. Apply and inspect

```bash
kubectl apply -f web.yaml
kubectl rollout status deployment/web -n devops-lab
kubectl get pods,service -n devops-lab
```

Expected result: the rollout completes, two Pods show `Running`, and the `web` Service shows type `ClusterIP`.

## 3. Test the service locally

In one terminal, forward a local port to the Service:

```bash
kubectl port-forward -n devops-lab service/web 8080:80
```

In another terminal, make a request:

```bash
curl -I --max-time 5 http://127.0.0.1:8080/
```

Expected result: an HTTP response such as `HTTP/1.1 200 OK`. The forwarding command listens on localhost by default; stop it with Ctrl+C when finished.

## 4. Clean up the lab

```bash
kubectl delete -f web.yaml
kubectl delete namespace devops-lab
```

The second command removes the now-empty lab namespace. It also deletes anything else someone may have added to that specifically named namespace, so keep this namespace dedicated to the exercise.

## Troubleshooting hint

If the Pods are running but the Service has no endpoints, compare the Service selector (`app: demo-web`) with the Pod template labels. They must match.

## Key takeaway

A Deployment manages the desired number of Pods. A Service selects Pods by labels and provides a stable way to reach them. Port forwarding lets you test the service from your machine without creating a public load balancer.

The example uses the moving `nginx:alpine` tag for convenience. For repeatable production deployments, pin an image version or digest that your team has reviewed.
