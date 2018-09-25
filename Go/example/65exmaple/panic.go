package main

import "os"

func main() {
	panic("a problem")

	_, err := os.Create("/tmp/file")
	if err != nil {
		panic(err)
	}
}

/*  
output:

panic: a problem

goroutine 1 [running]:
main.main()
        /.../panic.go:6 +0x39
exit status 2
*/