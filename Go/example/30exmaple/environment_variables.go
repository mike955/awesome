package main

import "os"
import "strings"
import "fmt"

func main() {
    os.Setenv("FOO", "1")
    fmt.Println("FOO:", os.Getenv("FOO"))
    fmt.Println("BAR:", os.Getenv("BAR"))

    fmt.Println()
    for _, e := range os.Environ() {
        pair := strings.Split(e, "=")
        fmt.Println(pair[0])
    }
}

/*  
output:

.go
FOO: 1
BAR:

TERM_PROGRAM
NVM_CD_FLAGS
TERM
SHELL
TMPDIR
Apple_PubSub_Socket_Render
TERM_PROGRAM_VERSION
NVM_DIR
USER
SSH_AUTH_SOCK
__CF_USER_TEXT_ENCODING
PATH
PWD
LANG
XPC_FLAGS
XPC_SERVICE_NAME
SHLVL
HOME
LOGNAME
OLDPWD
_
FOO
*/