# Triage Linux CPU and memory pressure

**Goal:** Collect a short, read-only snapshot to decide whether a slow Linux host may be limited by CPU, memory, or I/O.

**Prerequisites:** A Linux host with `procps` tools installed. These commands inspect the system; they do not stop processes or change configuration.

## 1. Compare load with available CPUs

```bash
uptime
nproc
```

`uptime` shows load averages for the last 1, 5, and 15 minutes. Compare them with the logical CPU count from `nproc`. Load includes runnable tasks and tasks in uninterruptible sleep, so a high load alone does not prove CPU saturation.

## 2. Check available memory and swap

```bash
free -h
```

Look at `available`, which estimates memory that can be used by new applications without swapping. Linux may use otherwise idle RAM for cache, so the `free` column by itself is not a measure of memory pressure.

## 3. Sample CPU, run queue, I/O wait, and swapping

```bash
vmstat 1 5
```

The first report is an average since boot; use the later reports to inspect the one-second samples. Pay attention to:

- `r`: runnable processes waiting for CPU time. A value that stays above the CPU count can indicate CPU contention.
- `b`: processes blocked while waiting for I/O.
- `si` and `so`: memory swapped in from or out to disk during the sample. Repeated nonzero values together with low available memory can indicate memory pressure.
- `us` and `sy`: CPU time spent in user and kernel code.
- `wa`: CPU time waiting for I/O.

## 4. Find processes using CPU or memory

```bash
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 11
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 11
```

These show the header and up to ten processes, first sorted by CPU and then by memory. The readings are a snapshot; compare with another sample before deciding a process is the cause.

## Interpret the evidence

- High `r` across several samples, relative to `nproc`, plus busy CPU processes points toward CPU contention.
- Low `available` memory together with ongoing `si`/`so` activity points toward memory pressure.
- High `wa` or `b` suggests investigating storage or another I/O dependency; adding CPU may not help.
- One isolated spike is not enough to diagnose a bottleneck. Capture the time, repeat the samples, and correlate with application logs and traffic.

## Key takeaway

Check multiple signals before taking action. This quick triage helps narrow the next investigation while avoiding speculative process kills or configuration changes.

References: [vmstat manual](https://man7.org/linux/man-pages/man8/vmstat.8.html) · [free manual](https://man7.org/linux/man-pages/man1/free.1.html)
