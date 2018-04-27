package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"sync"
	"sync/atomic"
	"time"
)

var (
	targetAddr  = flag.String("a", "127.0.0.1:4000", "target echo server address")
	testMsgLen  = flag.Int("l", 26, "test message length")
	testConnNum = flag.Int("c", 2000, "test connection number")
	testSeconds = flag.Int("t", 30, "test duration in seconds")
)

func main() {
	flag.Parse()

	var (
		outNum uint64
		inNum  uint64
		stop   uint64
	)

	msg := make([]byte, *testMsgLen)

	go func() {
		time.Sleep(time.Second * time.Duration(*testSeconds))
		atomic.StoreUint64(&stop, 1)
	}()

	wg := new(sync.WaitGroup)

	for i := 0; i < *testConnNum; i++ {
		wg.Add(1)

		go func() {
			if conn, err := net.Dial("tcp", *targetAddr); err == nil {
				l := len(msg)
				recv := make([]byte, l)

				for {
					for rest := l; rest > 0 ; {
						i, err := conn.Write(msg);
						rest -= i
						if err != nil {
							log.Println(err)
							break
						}
					}

					atomic.AddUint64(&outNum, 1)

					if atomic.LoadUint64(&stop) == 1 {
						break
					}

					for rest := l; rest > 0 ; {
						i, err := conn.Read(recv)
						rest -= i
						if err != nil {
							log.Println(err)
							break
						}
					}

					atomic.AddUint64(&inNum, 1)

					if atomic.LoadUint64(&stop) == 1 {
						break
					}
				}
			} else {
				log.Fatal(err)
			}

			wg.Done()
		}()
	}

	wg.Wait()

	fmt.Println("Benchmarking:", *targetAddr)
	fmt.Println(*testConnNum, "clients, running", *testMsgLen, "bytes,", *testSeconds, "sec.")
	fmt.Println()
	fmt.Println("Speed:", outNum/uint64(*testSeconds), "request/sec,", inNum/uint64(*testSeconds), "response/sec")
	fmt.Println("Requests:", outNum)
	fmt.Println("Responses:", inNum)
}
