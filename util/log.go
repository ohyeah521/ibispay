package util

import (
	"fmt"
	"log"

	"reqing.org/ibispay/config"
)

//LogDebug 在debug时打印
func LogDebug(str string) {
	if config.Public.Debug {
		log.Println(str)
	}
}

//LogDebugAll 在debug时打印interface
func LogDebugAll(in interface{}) {
	if config.Public.Debug {
		fmt.Printf("%+v\n", in)
	}
}
