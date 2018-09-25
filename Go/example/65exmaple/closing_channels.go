package main

import "fmt"

func main () {
	jobs := make(chan int, 5)
	done := make(chan bool)

	go func() {
		for {
			j, more := <- jobs
			if more {
				fmt.Println("received job", j)
			} else {
				fmt.Println("received all jobs")
				done <- true
				return
			}
		}
	}()

	for j := 1; j <= 3; j++ {
		jobs <- j
		fmt.Println("sent job", j)
	}
	close(jobs)
	fmt.Println("send all jobs")
	<- done
}

/*  
output:

sent job 1
sent job 2
sent job 3
send all jobs
received job 1
received job 2
received job 3
received all jobs
*/