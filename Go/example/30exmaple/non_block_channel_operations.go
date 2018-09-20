package main

import "fmt"

func print(args... string){
	fmt.Println(args)
}

func main() {
	messages := make(chan string)
	signals := make(chan bool)

	select {
	case msg:= <- messages:
		fmt.Println("received message", msg)
	default:
		fmt.Println("no message received")
	}

	msg := "hi"
	select {
	case messages <- msg:
		print("sent message", msg)
	default:
		print("no message sent")
	}

	select {
	case msg := <- messages:
		print("received message", msg)
	case sig := <- signals:
		fmt.Println("received signal", sig)
	default:
		print("no activity")
	}
}

/*  
output:

no message received
[no message sent]
[no activity]
*/