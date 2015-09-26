package bootstrapping

import (
	"os"
	"runtime"
)

var BuildTime = ""
var GoVersion = ""
var CodeRev = ""
var Tag = ""
var Branch = ""
var ModifiedSources = ""
var Deps = ""
var BuildOption=""

// okay... you see yourself - it is quite a simple file

func Bootstrap(mainFunc func() int, buildVars map[string]string) {

	buildVars["BuildTime"] = Opt(BuildTime, "<undefined>")
	buildVars["GoVersion"] = Opt(GoVersion, runtime.Version())
	buildVars["CodeRev"] = Opt(CodeRev, "<undefined>")
	buildVars["ModifiedSources"] = Opt(ModifiedSources, "")
	buildVars["Deps"] = Opt(Deps, "")
	buildVars["Tag"] = Opt(Tag, "<undefined>")
	buildVars["Branch"] = Opt(Branch, "<undefined>")
	buildVars["BuildOption"] = Opt(BuildOption, "<undefined>")

	os.Exit(mainFunc())
}

func Opt(s string, alt string) string {
	if s == "" {
		return alt
	}
	return s
}
