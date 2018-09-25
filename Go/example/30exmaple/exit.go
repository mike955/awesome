package main

import "fmt"
import "os"

func main() {
	defer fmt.Println("!")
	os.Exit(3)
}

/*  
output:

exit status 3
*/