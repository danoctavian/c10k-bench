# Notes on runtimes


## Ocaml
M:1
runs in 1 kernel thread, think python GIL.

This is Ocaml's nodejs:

https://github.com/janestreet/async

## Nodejs

M:1

## Ruby eventmachine

like nodejs. but not exactly somehow it outperforms it. and i see it using up
all kernel threads. so it probably offloads blocking tasks to a pool of worker
threads.

## Clojure async

M:N

On top of netty, very similar golang and haskell. multiplexes green threads
on all cores.

## Golang

M:N

## Haskell

M:N

### Rust

1:1

https://mail.mozilla.org/pipermail/rust-dev/2013-November/006550.html

https://msdn.microsoft.com/en-us/library/windows/desktop/dd627187(v=vs.85).aspx

it seems that ideally you have OS level support for userland thread scheduling
(and stack management maybe)

right now there is no such thing on linux.

### Dart

M:N

Dart uses a different model running an event loop per isolate.

An isolate maps to one kernel thread.

No green threads really. isolates communicate through ports.