package main

import (
	"fmt"
	"runtime"
)

func main() {
	hello()
}

func hello() {
	fmt.Println("Hello, World!")
	fmt.Println("Go version: ", runtime.Version())
}
