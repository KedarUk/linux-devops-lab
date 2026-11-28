# Trace HTTP connectivity with curl

When an endpoint is unavailable, identify whether the failure occurs during name resolution, connection setup, TLS, or the HTTP response. This lab uses one request to a host you are allowed to access; it does not scan ports or change server state.

## Goal

Use DNS lookup and curl timing details to narrow down a web connectivity problem.

## Prerequisites

- A terminal with curl.
- An HTTPS endpoint that you are permitted to query. The examples use example.com.

## 1. Set the target

In a POSIX shell:

```sh
HOST=example.com
URL="https://$HOST/"
```

In PowerShell:

```powershell
$HOSTNAME = "example.com"
$URL = "https://$HOSTNAME/"
```

## 2. Check name resolution

On Linux or macOS:

```sh
getent ahosts "$HOST"
```

On Windows PowerShell:

```powershell
Resolve-DnsName $HOSTNAME
```

Expected result: one or more IP addresses. If lookup fails, investigate the resolver, VPN, or DNS configuration before troubleshooting the web server.

## 3. Make one bounded HTTPS request

On Linux or macOS:

```sh
curl --verbose --output /dev/null \
  --connect-timeout 5 --max-time 10 \
  --write-out '\nhttp_code=%{http_code} remote_ip=%{remote_ip} dns=%{time_namelookup}s tcp=%{time_connect}s tls=%{time_appconnect}s total=%{time_total}s\n' \
  "$URL"
```

On PowerShell, use curl.exe explicitly to avoid any shell alias:

```powershell
curl.exe --verbose --output NUL --connect-timeout 5 --max-time 10 --write-out "\nhttp_code=%{http_code} remote_ip=%{remote_ip} dns=%{time_namelookup}s tcp=%{time_connect}s tls=%{time_appconnect}s total=%{time_total}s\n" $URL
```

The request is capped at five seconds for connection setup and ten seconds overall. The verbose output shows protocol progress; the write-out format prints timing and response details after the transfer. A successful request will show a remote IP, timing values, and an HTTP status such as 200 or a redirect such as 301.

## 4. Read the stage where it stopped

- **DNS lookup error:** the hostname did not resolve. Check the host spelling and resolver settings.
- **Connection timeout:** curl did not finish connecting within the limit. Check routing, firewall rules, proxy settings, and whether the destination is reachable from this network.
- **Connection refused:** the destination was reached, but the port rejected the connection or no service is listening there.
- **TLS or certificate error:** TCP connected, but HTTPS negotiation or certificate validation failed. Check system time, certificate chain, hostname, and any configured TLS inspection.
- **HTTP 4xx or 5xx:** DNS, TCP, and TLS completed and the server returned an HTTP response. Investigate the URL, authentication, application, or upstream service.

An HTTP error response is still evidence that the HTTP exchange succeeded; curl does not treat every 4xx or 5xx response as a transport failure by default.

## 5. Cleanup

No files or remote resources were created. In PowerShell, clear the variables if desired:

```powershell
Remove-Variable HOSTNAME, URL
```

## References

- [curl man page: connection and transfer timeouts](https://curl.se/docs/manpage.html)
- [curl FAQ: HTTP response codes](https://curl.se/docs/faq.html)
