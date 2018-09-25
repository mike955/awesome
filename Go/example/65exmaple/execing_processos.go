package main

import "syscall"
import "os"
import "os/exec"

func main() {

    binary, lookErr := exec.LookPath("ls")
    if lookErr != nil {
        panic(lookErr)
    }
    args := []string{"ls", "-a", "-l", "-h"}
    env := os.Environ()

    execErr := syscall.Exec(binary, args, env)
    if execErr != nil {
        panic(execErr)
    }
}

/* output

total 520
drwxr-xr-x  66 clx  staff   2.1K  9 25 08:38 .
drwxr-xr-x   5 clx  staff   160B  9 20 08:35 ..
-rw-r--r--   1 clx  staff   358B  9 19 16:51 array.go
-rw-r--r--   1 clx  staff   347B  9 21 08:36 atomic_counters.go
-rw-r--r--   1 clx  staff   501B  9 25 08:18 base64_encoding.go
-rw-r--r--   1 clx  staff   211B  9 20 14:56 channel_buffering.go
-rw-r--r--   1 clx  staff   362B  9 20 18:03 channel_directions.go
-rw-r--r--   1 clx  staff   269B  9 20 18:04 channel_synchronization.go
-rw-r--r--   1 clx  staff   176B  9 20 14:56 channels.go
-rw-r--r--   1 clx  staff   531B  9 21 08:06 closing_channels.go
-rw-r--r--   1 clx  staff   261B  9 20 08:11 closures.go
-rw-r--r--   1 clx  staff   1.3K  9 21 17:19 collection_functions.go
-rw-r--r--   1 clx  staff   370B  9 25 08:34 command-line_arguments.go
-rw-r--r--   1 clx  staff   929B  9 25 08:35 command-line_flags.go
-rw-r--r--   1 clx  staff   212B  9 19 16:22 constants.go
-rw-r--r--   1 clx  staff   449B  9 21 16:32 defer.go
-rw-r--r--   1 clx  staff   562B  9 25 08:36 environment_variables.go
-rw-r--r--   1 clx  staff   477B  9 25 07:42 epoch.go
-rw-r--r--   1 clx  staff   962B  9 20 14:57 errors.go
-rw-r--r--   1 clx  staff   344B  9 25 08:38 execing_processos.go
-rw-r--r--   1 clx  staff   292B  9 19 16:30 for.go
-rw-r--r--   1 clx  staff   246B  9 20 08:01 functions.go
-rw-r--r--   1 clx  staff   263B  9 20 14:57 goroutines.go
-rw-r--r--   1 clx  staff    74B  9 19 16:02 hello_world.go
-rw-r--r--   1 clx  staff   351B  9 19 16:34 if_else.go
-rw-r--r--   1 clx  staff   713B  9 20 08:49 interfaces.go
-rw-r--r--   1 clx  staff   1.7K  9 21 18:49 json.go
-rw-r--r--   1 clx  staff   405B  9 25 08:31 line_filters.go
-rw-r--r--   1 clx  staff   345B  9 20 07:46 maps.go
-rw-r--r--   1 clx  staff   382B  9 20 08:36 methods.go
-rw-r--r--   1 clx  staff   166B  9 20 08:04 multiple_return_values.go
-rw-r--r--   1 clx  staff   987B  9 21 08:46 mutexes.go
-rw-r--r--   1 clx  staff   632B  9 20 19:33 non_block_channel_operations.go
-rw-r--r--   1 clx  staff   467B  9 25 08:04 number_parsing.go
-rw-r--r--   1 clx  staff   245B  9 21 16:24 panic.go
-rw-r--r--   1 clx  staff   269B  9 20 08:19 pointers.go
-rw-r--r--   1 clx  staff   726B  9 25 07:59 random_numbers.go
-rw-r--r--   1 clx  staff   442B  9 20 07:54 range.go
-rw-r--r--   1 clx  staff   197B  9 21 08:11 range_over_channels.go
-rw-r--r--   1 clx  staff   1.3K  9 21 08:30 rate_limiting.go
-rw-r--r--   1 clx  staff   951B  9 25 08:28 reading_files.go
-rw-r--r--   1 clx  staff   140B  9 20 08:15 recursion.go
-rw-r--r--   1 clx  staff   1.0K  9 21 17:52 regular_express.go
-rw-r--r--   1 clx  staff   431B  9 20 18:10 select.go
-rw-r--r--   1 clx  staff   263B  9 25 08:13 sha1.go
-rw-r--r--   1 clx  staff   719B  9 20 07:42 slices.go
-rw-r--r--   1 clx  staff   334B  9 21 09:35 sorting.go
-rw-r--r--   1 clx  staff   402B  9 21 16:21 sorting_by_functions.go
-rw-r--r--   1 clx  staff   5.1K  9 25 08:38 spawning_processes.go
-rw-r--r--   1 clx  staff   1.2K  9 21 09:31 stateful_goroutines.go
-rw-r--r--   1 clx  staff   1.1K  9 21 17:34 string_formatting.go
-rw-r--r--   1 clx  staff   859B  9 21 17:27 string_functions.go
-rw-r--r--   1 clx  staff   369B  9 20 08:29 structs.go
-rw-r--r--   1 clx  staff   810B  9 19 16:46 switch.go
-rw-r--r--   1 clx  staff    61B  9 20 18:05 template.go
-rw-r--r--   1 clx  staff   483B  9 21 08:17 tickers.go
-rw-r--r--   1 clx  staff   916B  9 25 07:40 time.go
-rw-r--r--   1 clx  staff   856B  9 25 07:49 time_formatting_parsing.go
-rw-r--r--   1 clx  staff   520B  9 20 19:12 timeouts.go
-rw-r--r--   1 clx  staff   372B  9 21 08:14 timers.go
-rw-r--r--   1 clx  staff   658B  9 25 08:11 url_parsing.go
-rw-r--r--   1 clx  staff   211B  9 19 16:06 values.go
-rw-r--r--   1 clx  staff   221B  9 19 16:16 variables.go
-rw-r--r--   1 clx  staff   240B  9 20 08:08 variadic_functions.go
-rw-r--r--   1 clx  staff   731B  9 21 08:23 worker_pools.go
-rw-r--r--   1 clx  staff   732B  9 25 08:30 writing_file.go
*/