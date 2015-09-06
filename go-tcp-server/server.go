package main

import (
    "io"
    "log"
    "net"
)

func main() {
    l, err := net.Listen("tcp", "localhost:4000")
    if err != nil {
        log.Fatal(err)
    }
    defer l.Close()
    for {
        conn, err := l.Accept()
        if err != nil {
            log.Fatal(err)
        }
        go func(c net.Conn) {
            defer c.Close()
            io.Copy(conn, c)
        }(conn)
    }
}