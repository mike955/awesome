package main

import "fmt"
import "time"

func main() {
	ticker := time.NewTicker(500 * time.Millisecond)
	go func() {
		for t := range ticker.C {
			fmt.Println("Tick at", t)
		}
	}()

	time.Sleep(1600 * time.Millisecond)
	ticker.Stop()
	fmt.Println("Ticker stopped")
}

/*  
output:

Tick at 2018-09-21 08:17:00.564205 +0800 CST m=+0.503280608
Tick at 2018-09-21 08:17:01.065803 +0800 CST m=+1.004862116
Tick at 2018-09-21 08:17:01.564891 +0800 CST m=+1.503936831
Ticker stopped
*/