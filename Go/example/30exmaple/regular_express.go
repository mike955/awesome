package main

import "fmt"
import "bytes"
import "regexp"

func main() {
	match, _ := regexp.MatchString("p([a-z]+)ch", "pench")
	fmt.Println(match)

	r, _ := regexp.Compile("p([a-z]+)ch")

	fmt.Println(r.MatchString("peach"))
	fmt.Println(r.FindString("pench punch"))
	fmt.Println(r.FindStringIndex("pench punch"))
	fmt.Println(r.FindStringSubmatch("pench punch"))

	fmt.Println(r.FindStringSubmatchIndex("pench punch"))
	fmt.Println(r.FindAllString("pench punch pinch", -1))

	fmt.Println(r.FindAllStringSubmatchIndex("peach punch pinch", -1))
	fmt.Println(r.FindAllString("pench punch pinch", 2))
	fmt.Println(r.Match([]byte("pench")))

	r = regexp.MustCompile("p([a-z]+)ch")
	fmt.Println(r)

	fmt.Println(r.ReplaceAllString("a peach", "<fruit>"))

	in := []byte("a peach")
	out := r.ReplaceAllFunc(in, bytes.ToUpper)
	fmt.Println(string(out))
}

/*  
output:

true
true
pench
[0 5]
[pench en]
[0 5 1 3]
[pench punch pinch]
[[0 5 1 3] [6 11 7 9] [12 17 13 15]]
[pench punch]
true
p([a-z]+)ch
a <fruit>
a PEACH
*/