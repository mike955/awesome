package main

import "fmt"
import "time"

func main() {
	p := fmt.Println

	now := time.Now()
	p(now)

	then := time.Date(
		2009, 11, 17, 20, 34, 58, 651387237, time.UTC)
	p(then)

	p(then.Year)
	p(then.Month())
	p(then.Day())
	p(then.Hour())
	p(then.Minute())
	p(then.Second())
	p(then.Nanosecond())
	p(then.Location())

	p(then.Weekday())
	p(then.Before(now))
	p(then.After(now))
	p(then.Equal(now))

	diff := now.Sub(then)
	p(diff)

	p(diff.Hours())
	p(diff.Minutes())
	p(diff.Seconds())
	p(diff.Nanoseconds())

	p(then.Add(diff))
	p(then.Add(-diff))
}

/*  
output:

2018-09-25 07:39:43.457303 +0800 CST m=+0.000359964
2009-11-17 20:34:58.651387237 +0000 UTC
0x1096450
November
17
20
34
58
651387237
UTC
Tuesday
true
false
false
77595h4m44.805915763s
77595.07911275438
4.655704746765262e+06
2.793422848059158e+08
279342284805915763
2018-09-24 23:39:43.457303 +0000 UTC
2001-01-10 17:30:13.845471474 +0000 UTC
*/