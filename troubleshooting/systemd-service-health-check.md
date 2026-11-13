# Troubleshoot a Linux service that will not respond

**Goal:** Find whether a web service is stopped, listening on the wrong port, or returning an HTTP error.

**Prerequisites:** A Linux host with systemd and a service you are allowed to inspect. The examples use `nginx`; replace it with your service name.

## 1. Check the service state

```bash
systemctl status nginx --no-pager
```

Look for `Active: active (running)`. If it is failed or inactive, inspect the recent service logs before changing anything.

## 2. Read recent logs

```bash
sudo journalctl -u nginx -n 50 --no-pager
```

The last 50 entries often show a configuration error, missing file, permission problem, or failed dependency. Avoid restarting repeatedly before reading the error.

## 3. Confirm the port is listening

```bash
sudo ss -ltnp
```

Find the expected port, commonly `:80` or `:443`, and confirm the service is bound to the right address. A service bound only to `127.0.0.1` cannot accept connections directly from other machines.

## 4. Make a local HTTP request

```bash
curl -i --max-time 5 http://127.0.0.1/
```

- An HTTP status such as `200`, `301`, or `403` means the request reached an HTTP server; investigate the response and application configuration.
- `Connection refused` usually means nothing is listening at that address and port.
- A timeout suggests a network path or firewall issue, or a service that is not responding.

## 5. Check from another host

From a machine that should have access, run:

```bash
curl -i --max-time 5 http://SERVER_IP/
```

If the local request works but this request fails, check the host firewall, cloud security rules, routing, and the service's bind address.

## Practice exercise

Stop a test service only on a disposable lab machine, then use the commands above to identify the failure. Start it again and verify the local request succeeds:

```bash
sudo systemctl start nginx
systemctl is-active nginx
curl -I --max-time 5 http://127.0.0.1/
```

Expected result: `systemctl is-active` prints `active`, and `curl` prints an HTTP response status line.

## Key takeaway

Troubleshoot from the inside out: service state, service logs, listening socket, local request, then remote network path. This narrows the fault without making speculative configuration changes.
