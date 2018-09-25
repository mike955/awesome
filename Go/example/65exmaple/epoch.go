package main

import "fmt"
import "time"

func main() {
	now := time.Now()
	secs := now.Unix()
	nanos := now.UnixNano()
	fmt.Println(now)

	millis := nanos / 1000000
	fmt.Println(secs)
	fmt.Println(millis)
	fmt.Println(nanos)

	fmt.Println(time.Unix(secs, 0))
	fmt.Println(time.Unix(0, nanos))
}

/*  
output:

2018-09-25 07:42:47.345283 +0800 CST m=+0.000411596
1537832567
1537832567345
1537832567345283000
2018-09-25 07:42:47 +0800 CST
2018-09-25 07:42:47.345283 +0800 CST
*/