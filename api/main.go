package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, Cardmarket! Here we go again!")
	})
	http.ListenAndServe(":8001", nil)
}