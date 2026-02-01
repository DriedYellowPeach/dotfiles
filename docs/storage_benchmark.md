# Storage Benchmark Results

- Date: 2026-01-31
- Tool: fio 3.41, hdparm

## HDD - WD Gold 20TB

- Interface: SATA III (6.0 Gbps)
- Device: /dev/sda
- Mount: /mnt/wd20t

### hdparm Results
```
Timing cached reads:   90198 MB in  2.00 seconds = 45201.36 MB/sec
Timing buffered disk reads: 810 MB in  3.02 seconds = 268.62 MB/sec
```

### fio Sequential Read
```
read: IOPS=265, BW=265MiB/s (278MB/s)(1024MiB/3859msec)
  clat (usec): min=2793, max=27119, avg=3768.00, stdev=1703.35
  lat (msec): 4=97.85%, 10=1.46%, 20=0.10%, 50=0.59%
```

| Test | Result |
|------|--------|
| Sequential Read (hdparm) | 268.62 MB/s |
| Sequential Read (fio) | 265 MiB/s (278 MB/s) |
| IOPS | 265 |

## SSD - Samsung 990 Pro 4TB (NVMe)

- Interface: NVMe PCIe 4.0
- Device: /dev/nvme1n1

### fio Random 4K Read (libaio, iodepth=64, numjobs=4)
```
Run status group 0 (all jobs):
   READ: bw=8063MiB/s (8455MB/s), 2016MiB/s-2103MiB/s (2114MB/s-2205MB/s), io=4096MiB (4295MB), run=487-508msec
```

Per job results:
```
Job 1: IOPS=538k, BW=2103MiB/s (2205MB/s), clat avg=114.50us
Job 2: IOPS=529k, BW=2065MiB/s (2165MB/s), clat avg=116.95us
Job 3: IOPS=530k, BW=2069MiB/s (2169MB/s), clat avg=116.54us
Job 4: IOPS=516k, BW=2016MiB/s (2114MB/s), clat avg=119.69us
```

| Test | Result |
|------|--------|
| Random 4K Read (total) | 8,063 MiB/s (8,455 MB/s) |
| Random 4K IOPS (total) | ~2,113,000 |
| Average Latency | ~117 us |

## Summary

| Drive | Type | Capacity | Sequential Read | Random 4K IOPS |
|-------|------|----------|-----------------|----------------|
| WD Gold | HDD | 20TB | 268 MB/s | N/A |
| Samsung 990 Pro | NVMe SSD | 4TB | N/A | 2,113,000 |

## Test Commands

```bash
# HDD sequential read
sudo hdparm -Tt /dev/sda
fio --name=seq-read --rw=read --bs=1M --size=1G --numjobs=1 --direct=1

# SSD random 4K read
fio --name=rand-read --rw=randread --bs=4k --size=1G --numjobs=4 --direct=1 --iodepth=64 --ioengine=libaio
```
