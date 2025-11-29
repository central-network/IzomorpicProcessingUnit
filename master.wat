(module
    (import "self" "memory" (memory $malloc 100 65536 shared))
    (import "self" "postMessage" (func $postMessage<i32> (param $taskid i32)))

    (start $loop
        (call $postMessage<i32> i32(2))
    )
)