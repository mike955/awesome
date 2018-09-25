package main

import "fmt"
import b64 "encoding/base64"

func main() {
	data := "abc123!?#$@&*#"

	sEnc := b64.StdEncoding.EncodeToString([]byte(data))
	fmt.Println(sEnc)

	sDec, _ := b64.StdEncoding.DecodeString(sEnc)
	fmt.Println(string(sDec))
	fmt.Println()

	uEnc := b64.URLEncoding.EncodeToString([]byte(data))
	fmt.Println(uEnc)
	uDec, _ := b64.URLEncoding.DecodeString(uEnc)
	fmt.Println(string(uDec))
}

/*  
output:

YWJjMTIzIT8jJEAmKiM=
abc123!?#$@&*#

YWJjMTIzIT8jJEAmKiM=
abc123!?#$@&*#
*/