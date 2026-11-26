# Docker multi-stage build lab

Build a small Go program in one Docker stage, then copy only the compiled binary into a minimal runtime image.

## Goal

See how multi-stage builds keep compilers and source files out of the final image.

## Prerequisites

- Docker Engine with BuildKit support (enabled by default in current Docker releases).
- A terminal with `docker`.

## 1. Create the application

Make a new empty directory and save this as `main.go`:

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello from a multi-stage image")
}
```

Save this as `Dockerfile` in the same directory:

```dockerfile
FROM golang:1.26-alpine AS build
WORKDIR /src
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/hello main.go

FROM scratch AS runtime
COPY --from=build /out/hello /hello
ENTRYPOINT ["/hello"]
```

The named `build` stage contains the Go compiler. The final `runtime` stage starts from `scratch`, an empty base image, and copies in only the static executable.

## 2. Build and run

```sh
docker build -t hello-multistage:local .
docker run --rm hello-multistage:local
```

Expected output:

```text
Hello from a multi-stage image
```

Inspect the final image:

```sh
docker image ls hello-multistage:local
docker image inspect hello-multistage:local --format '{{.Os}}/{{.Architecture}} {{.Size}} bytes'
```

The image should contain the executable and have no Go SDK. Its size is platform-dependent, so compare the reported size on your own machine rather than relying on a fixed number.

## 3. Inspect the build stage

Build only the named build stage:

```sh
docker build --target build -t hello-multistage:build .
docker image ls hello-multistage
```

This stage includes the Go toolchain and is much larger than the runtime image. Build targets are useful when debugging compilation without changing the production image.

## 4. Cleanup

```sh
docker image rm hello-multistage:local hello-multistage:build
```

This removes only the two images created in this lab. Docker will report an error if a container is still using either image; stop that lab container first.

## Key takeaway

Multi-stage builds let you use build tools in an earlier stage and copy selected artifacts into a separate final stage. This can reduce the runtime image contents, but it does not by itself verify that the copied application or dependencies are secure.

## Reference

- [Docker Docs: Multi-stage builds](https://docs.docker.com/build/building/multi-stage/)
