

## Benchmarks

Server type: Echo server.

Conditions:

CONN_COUNT = 3000 concurrent connections 
DURATION = 30s.

Running the echo server and the client on localhost.

The haskell client creates CONN_COUNT lightweight threads that each open
socket connections send data, receive the echoed data and close the socket.
They check the current time after each request and stop if DURATION have passed. 

Measuring the number of requests completed by the server.

The benchmark is not great. I am unsure if the request strategy is legit. i should measure latency average and standard deviation.

Here are some preliminary numbers.

Go-bencher runs 2000 clients.

#### rust coio

go-bencher

Speed: 27094 request/sec, 27091 response/sec
Requests: 812832
Responses: 812749
GOMAXPROCS=64 ./tcp_bencher -c=2000 -t=30 -a=""  20.68s user 34.45s system 176% cpu 31.227 total

bencher

the server completed 261102
 3000 30  38.21s user 29.62s system 210% cpu 32.226 total

#### rust mioco

go bencher

run out of tokens error.

bencher

times out on 3000 clients.

does ~66k requests with 128 clients. 

guessing there's some bugs currently that make it not deal correctly with closing
the sockets. also the lower request processing rate is because it runs on 1 kernel thread.
This is normal since i'm depending on bleeding edge implementation.

#### golang

go bencher

Speed: 26526 request/sec, 26526 response/sec
Requests: 795805
Responses: 795804
GOMAXPROCS=64 ./tcp_bencher -c=2000 -t=30 -a=""  30.94s user 33.52s system 214% cpu 30.118 total

the server completed 297555
 3000 30  39.70s user 32.89s system 214% cpu 33.897 total

#### haskell conduit

 go-bencher

 Speed: 27652 request/sec, 27637 response/sec
Requests: 829577
Responses: 829128
GOMAXPROCS=64 ./tcp_bencher -c=2000 -t=30 -a=""  18.45s user 27.39s system 145% cpu 31.417 total

Bencher

the server completed 192420
 3000 30  38.06s user 21.22s system 153% cpu 38.668 total

#### nodejs

go-bencher

Speed: 11086 request/sec, 11085 response/sec
Requests: 332582
Responses: 332575
GOMAXPROCS=64 ./tcp_bencher -c=2000 -t=30 -a=""  21.01s user 22.30s system 138% cpu 31.230 total

(note: node crashes at the end when connections are closed)

the server completed 195653
 3000 30  33.23s user 23.44s system 165% cpu 34.171 total

#### ruby eventmachine

go-bencher

it crashed with memory allocation errors.

the server completed 294525
 3000 30  40.14s user 32.41s system 198% cpu 36.633 total

#### cpython twisted

go-bencher

Speed: 7613 request/sec, 7607 response/sec
Requests: 228417
Responses: 228224
./tcp_bencher  6.73s user 10.78s system 55% cpu 31.456 total

Note: many of these errors occured
2015/09/11 17:56:14 read tcp 127.0.0.1:4000: connection reset by peer
2015/09/11 17:56:22 write tcp 127.0.0.1:4000: broken pipe


#### clojure aleph (netty)

go-bencher

Speed: 19323 request/sec, 19323 response/sec
Requests: 579716
Responses: 579710
GOMAXPROCS=64 ./tcp_bencher -c=2000 -t=30 -a=""  15.54s user 25.09s system 134% cpu 30.262 total

bencher

the server completed 202087
 3000 30  30.22s user 22.82s system 171% cpu 30.992 total

#### elixir

crashes with strange errors under heavy load. I am currently running it
with

```bash
elixirc server.ex
elixir -e Echo.Server.main
```

I am not familiar with elixir/erlang now so i am not sure this is the right way to run a beam file.


#### Google Dart

go-bencher

Speed: 16723 request/sec, 16708 response/sec
Requests: 501693
Responses: 501257
GOMAXPROCS=64 ./tcp_bencher -c=2000 -t=30 -a=""  21.12s user 24.95s system 147% cpu 31.320 total

A lot of broken pipe errors.

bencher

my test is flawed and stops whenever it gets a "connection reset by peer" exception.
