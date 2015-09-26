# go-any-project-bootstrap

Start your new Golang project in professional way! :)

1. use script `go-setup-project` in future project dir

====================================

What script is actually doing

1. place files like `build.sh` and `Makefile` in the root of your new project
2. ask about app name, author, and site and update `build.sh` accordingly
2. create `code` dir 
3. create `code/main.go` looking like this:

```go
package code

var BuildVars = map[string]string{
	"DebugMode": you can replace this with call to debugMode() if you have such func :)
}

// Main func is real entry point
func Main() int {
    // do something here!
}
```

5. create `code/debug.go` looking like this:

```
package code

func isForProduction() bool {
	return false
}

func debugMode() string {
	if isForProduction() {
		return "false"
	}
	return "SOME CONSTANTS HAVE UNUSUAL VALUES"
}
```
