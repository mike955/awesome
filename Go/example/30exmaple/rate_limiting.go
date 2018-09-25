package main

import "fmt"
import "time"

func main() {
	requests := make(chan int, 5)
	for i := 1; i <= 5; i++ {
		requests <- i
	}
	close(requests)

	limiter := time.Tick(200 * time.Millisecond)

	for req := range requests {
		<- limiter
		fmt.Println("request", req, time.Now())
	}

	burstyLimiter := make(chan time.Time, 3)

	for i := 0; i < 3; i++ {
		burstyLimiter <- time.Now()
	}

	go func() {
		for t := range time.Tick(200 * time.Millisecond) {
			burstyLimiter <- t
		}
	}()

	burstyRequests := make(chan int, 5)
	for i := 1; i <= 5; i++ {
		burstyRequests <- i
	}
	close(burstyRequests)

	for req := range burstyRequests {
		<- burstyLimiter
		fmt.Println("request", req, time.Now())
	}
}

/*  
output:

request 1 2018-09-21 08:30:06.22413 +0800 CST m=+0.203679304
request 2 2018-09-21 08:30:06.424257 +0800 CST m=+0.403799718
request 3 2018-09-21 08:30:06.624123 +0800 CST m=+0.603659754
request 4 2018-09-21 08:30:06.824157 +0800 CST m=+0.803687378
request 5 2018-09-21 08:30:07.021403 +0800 CST m=+1.000927964
request 1 2018-09-21 08:30:07.021453 +0800 CST m=+1.000978410
request 2 2018-09-21 08:30:07.021469 +0800 CST m=+1.000994510
request 3 2018-09-21 08:30:07.021476 +0800 CST m=+1.001000921
request 4 2018-09-21 08:30:07.221612 +0800 CST m=+1.201131713
request 5 2018-09-21 08:30:07.42202 +0800 CST m=+1.401532827
*/