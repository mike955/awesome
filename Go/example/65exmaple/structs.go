package main

import "fmt"

type person struct {
	name string
	age int
}

func main() {
	fmt.Println(person{"Bob", 20})
	fmt.Println(person{name:"Alice", age: 30})
	fmt.Println(person{name: "fred"})
	fmt.Println(&person{name:"ann", age: 40})

	s := person{name: "sean", age: 50}
	fmt.Println(s.name)

	sp := &s
	fmt.Println(sp.age)

	sp.age = 51
	fmt.Println(sp.age)
}
