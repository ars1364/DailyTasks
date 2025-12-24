# Useful commands: Hardware

```text
ipmitool -I lanplus -H 10.43.138.12 -L ADMINISTRATOR -p 6320 -U admin -R 3 -N 5 -P redhat power status
#add disk to raid0
hpssacli ctrl slot=0 create type=ld drives=1I:1:2 raid=0 && \
hpssacli ctrl slot=0 create type=ld drives=1I:1:5 raid=0 && \
hpssacli ctrl slot=0 create type=ld drives=1I:1:7 raid=0 && \
hpssacli ctrl slot=0 create type=ld drives=1I:1:8 raid=0 && \
hpssacli ctrl slot=0 create type=ld drives=1I:1:11 raid=0
hpssacli ctrl slot=0 create type=ld drives=1I:1:1-1I:1:4,2I:1:5-2I:1:8 raid=6
#### latest hp ilo firmware (extract the downloaded file twice)
```