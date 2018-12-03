# docker-passenger-issue

Docker image to demonstrate an issue with bionic+passenger+crystal.

## How to use

Build and run containers:
```
docker-compose up
```

Get a user-level shell:
```
docker-compose exec -u app web bash
```

Then, the actual problem reproduction steps:

```
# build the test program:
crystal build httpserver.cr

# run it using passenger gls:
passenger start --app-start-command='env PORT=$PORT ./httpserver'
```

### Result:

Within a few seconds, PassengerAgent and httpserver should go to 100% cpu (or as close as they can get):

```
top - 06:24:48 up 4 days, 10:32,  0 users,  load average: 0.81, 0.72, 0.56
Tasks:  18 total,   1 running,  17 sleeping,   0 stopped,   0 zombie
%Cpu(s): 19.2 us, 59.3 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.0 hi, 21.5 si,  0.0 st
KiB Mem :  1530980 total,   360768 free,   213108 used,   957104 buff/cache
KiB Swap:   524284 total,   364972 free,   159312 used.  1131312 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
  138 app       20   0  689732  18532  14968 S 57.6  1.2   0:17.41 PassengerAgent
  170 app       20   0  219324  10872   4932 S 39.4  0.7   0:11.90 httpserver
```
