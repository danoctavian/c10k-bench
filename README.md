

## Benchmarks

Conditions: 3000 concurrent connections for 30s.

Measuring the number of requests completed by the server.

The benchmark is not great. I am unsure if the request strategy is legit. i should measure latency average and standard deviation.

Here are some preliminary numbers.

#### rust coio

the server completed 261102
 3000 30  38.21s user 29.62s system 210% cpu 32.226 total

#### golang

the server completed 297555
 3000 30  39.70s user 32.89s system 214% cpu 33.897 total

#### haskell conduit

the server completed 192420
 3000 30  38.06s user 21.22s system 153% cpu 38.668 total

#### nodejs

the server completed 195653
 3000 30  33.23s user 23.44s system 165% cpu 34.171 total

#### ruby eventmachine

the server completed 294525
 3000 30  40.14s user 32.41s system 198% cpu 36.633 total

#### clojure aleph (netty)

the server completed 202087
 3000 30  30.22s user 22.82s system 171% cpu 30.992 total
