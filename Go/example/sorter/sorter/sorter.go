package main

import "flag"
import "fmt"


var infile *string = flag.String("i", "infile", "File contains values for sorting")
var outfile *string = flag.String("o","outfile","File to receive sorted values")
var algorithm *string = flag.String("a", "qsort", "Sort algorithm")

func main() {
	flag.Parse()

	if infile != nil {
		fmt.Println("infile=", *infile, "outfile=", *outfile, "algorithm", *algorithm)
		return
	}

	defer file.Close()

	br := bufio.NewReader(file)

	values = make([]int, 0)

	for {
		line, isPrefxi, err1 := br,ReadLine()

		if err1 != nil {
			if err1 != io.EOF  {
				err= err1
			}
		}
	}
}