# Kubernetes health probes lab

Practice the difference between startup, liveness, and readiness checks with a small NGINX Deployment.

## What you will learn

- A startup probe gives a slow-starting container time to initialize.
- A liveness probe restarts a container after repeated health-check failures.
- A readiness probe controls whether a Pod receives Service traffic.

Kubernetes does not run liveness or readiness probes until a configured startup probe succeeds. A failed readiness probe removes the Pod from matching Service endpoints; a failed liveness probe can restart its container. Use a liveness check only for failures an application cannot recover from itself, since overly aggressive restarts can make an outage worse.

## Requirements

- A working Kubernetes context and `kubectl`.
- Permission to create a Deployment in the current namespace.

Check the context before changing cluster resources:

```sh
kubectl config current-context
kubectl get nodes
```

## 1. Create a Deployment with all three probes

Save this as `probes.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: probe-demo
  template:
    metadata:
      labels:
        app: probe-demo
    spec:
      containers:
        - name: nginx
          image: nginx:1.27-alpine
          ports:
            - name: http
              containerPort: 80
          startupProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 2
            failureThreshold: 30
          livenessProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 10
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 5
            failureThreshold: 2
```

The startup probe allows up to 60 seconds of failed checks before Kubernetes treats startup as unsuccessful (30 checks × 2 seconds). Once it succeeds, liveness and readiness checks begin. In a real application, use health endpoints that reflect the intended condition rather than assuming that every HTTP 200 means the app is healthy.

Apply the Deployment and wait for it to become available:

```sh
kubectl apply -f probes.yaml
kubectl rollout status deployment/probe-demo
kubectl get pods -l app=probe-demo
```

## 2. Inspect probe results

```sh
kubectl describe pod -l app=probe-demo
kubectl get pod -l app=probe-demo -o wide
```

Look at the Events and container state. A successful readiness probe makes the Pod ready for traffic; startup and liveness successes appear in the Pod events as checks run.

## 3. Observe readiness through a Service

Create a ClusterIP Service:

```sh
kubectl expose deployment probe-demo --port=80 --target-port=http --name=probe-demo
kubectl get endpointslice -l kubernetes.io/service-name=probe-demo
```

The endpoint should include the Pod while it is ready. A readiness failure would make it unavailable for regular Service traffic, while leaving the container running.

## 4. Cleanup

```sh
kubectl delete service probe-demo
kubectl delete deployment probe-demo
rm probes.yaml
```

## Troubleshooting

- **Pod stays in `Running` but is not ready:** inspect `kubectl describe pod -l app=probe-demo` and verify the probe path and port.
- **Container keeps restarting:** check the `Liveness` and `Startup` events and container logs with `kubectl logs -l app=probe-demo --previous`.
- **Probe times out:** confirm the application listens on the configured port and that the endpoint responds from inside the Pod.

## References

- [Kubernetes: Liveness, Readiness, and Startup Probes](https://kubernetes.io/docs/concepts/workloads/pods/probes/)
- [Kubernetes: Configure Liveness, Readiness, and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
