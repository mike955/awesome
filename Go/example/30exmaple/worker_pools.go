package main

import "fmt"
import "time"

func worker(id int, jobs <- chan int, result chan <- int){
	for j := range jobs {
		fmt.Println("wokk", id, "started job", j)
		time.Sleep(time.Second)
		fmt.Println("work", id, "finished job", j)
		result <- j * 2
	}
}

func main() {
	jobs := make(chan int, 100)
	results := make(chan int, 100)

	for w := 1; w <= 3; w++ {
		go worker(w, jobs, results)
	}

	for j := 1; j <= 5; j++ {
		jobs <- j
	}
	close(jobs)

	for a:=1; a <= 5; a++ {
		<- results
	}
}

/*  
output:

wokk 3 started job 1
wokk 1 started job 2
wokk 2 started job 3
work 3 finished job 1
work 1 finished job 2
wokk 1 started job 4
work 2 finished job 3
wokk 3 started job 5
work 3 finished job 5
work 1 finished job 4
*/