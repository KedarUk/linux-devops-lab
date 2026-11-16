# Run and inspect a Docker container

**Goal:** Start a web server in a container, inspect its state and logs, and clean up the container.

**Prerequisites:** Docker Engine or Docker Desktop running, plus `curl`.

## 1. Start a container

```bash
docker run -d --name devops-web-lab -p 127.0.0.1:8080:80 nginx:alpine
```

Docker downloads the image if needed, starts it in the background, and prints a container ID. The port mapping sends requests from this machine's `127.0.0.1:8080` to port `80` in the container. Binding to loopback keeps this practice service from listening on external network interfaces.

## 2. Check status and logs

```bash
docker ps --filter name=devops-web-lab
docker logs devops-web-lab
```

The status should show the container as running and list the `8080->80` port mapping. Logs may be empty until a request reaches the web server.

## 3. Send a request and inspect state

```bash
curl -I --max-time 5 http://127.0.0.1:8080/
docker inspect --format '{{.State.Status}}' devops-web-lab
```

Expected results: `curl` prints an HTTP response such as `HTTP/1.1 200 OK`, and `docker inspect` prints `running`.

## 4. Stop and remove the lab container

```bash
docker stop devops-web-lab
docker rm devops-web-lab
```

This removes the named container. It does not remove the downloaded image. The commands do not delete other containers.

## Key takeaway

An image is the packaged template; a container is a running instance of it. Use `docker ps` for running containers, `docker logs` for application output, and `docker inspect` for detailed state. The `nginx:alpine` tag can change over time; production builds should use a reviewed, pinned image version or digest for repeatable deployments.
