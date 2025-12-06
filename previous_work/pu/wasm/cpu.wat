(module
    (import "console" "log"             (func $log<i32> (param i32)))
    (import "console" "log"             (func $log<f32> (param f32)))
    (import "console" "log"             (func $log<f64> (param f64)))
    (import "console" "log"             (func $log<ref> (param externref)))
    (import "console" "warn"            (func $warn<i32> (param i32)))
    (import "console" "warn"            (func $warn<ref> (param externref)))
    (import "console" "warn"            (func $self.console.warn<ref> (param externref)))

    (import "Reflect" "construct"       (func $self.Reflect.construct<refx2>ref     (param externref externref) (result externref)))
    (import "Reflect" "getPrototypeOf"  (func $self.Reflect.getPrototypeOf<ref>ref  (param externref) (result externref)))
    (import "Reflect" "getOwnPropertyDescriptor"  (func $self.Reflect.getOwnPropertyDescriptor<refx2>ref  (param externref externref) (result externref)))
    (import "Reflect" "apply"           (func $self.Reflect.apply<refx3>ref         (param externref externref externref) (result externref)))
    (import "Reflect" "apply"           (func $self.Reflect.apply<refx3>i32         (param externref externref externref) (result i32)))
    (import "Reflect" "apply"           (func $self.Reflect.apply<refx3>            (param externref externref externref)))
    (import "Reflect" "get"             (func $self.Reflect.get<refx2>i32           (param externref externref) (result i32)))
    (import "Reflect" "get"             (func $self.Reflect.get<refx2>ref           (param externref externref) (result externref)))
    (import "Reflect" "set"             (func $self.Reflect.set<ref.i32x2>          (param externref i32 i32) (result)))
    (import "Array" "of"                (func $self.Array.of<i32>ref                (param i32) (result externref)))
    (import "Array" "of"                (func $self.Array.of<ref>ref                (param externref) (result externref)))
    (import "Array" "of"                (func $self.Array.of<ref.i32x2>ref          (param externref i32 i32) (result externref)))
    (import "Array" "of"                (func $self.Array.of<ref.i32>ref            (param externref i32) (result externref)))
    (import "Array" "of"                (func $self.Array.of<i32x3>ref              (param i32 i32 i32) (result externref)))
    (import "Array" "of"                (func $self.Array.of<i32x2>ref              (param i32 i32) (result externref)))
    (import "Array" "of"                (func $self.Array.of<refx2>ref              (param externref externref) (result externref)))
    (import "Array" "from"              (func $self.Array.from<ref>ref              (param externref) (result externref)))
    (import "self" "Array"              (func $self.Array<>ref                      (param) (result externref)))

    (import "self" "self"               (global $self externref))
    (import "String" "fromCharCode"     (global $self.String.fromCharCode externref))

    (start $start)

    (memory $shared 10 10 shared)
    
    (func $start
        (local $1 i32)

        ;; (text "Hello me \"asd\" king..")
        (ref.null extern)
        (console $warn<ref>)

        ;; (async
        ;;     (call $self.fetch<ref>ref 
        ;;         (local.get $url)
        ;;     )
        ;;     (then $toText
        ;;         (param $buffer ref)
        ;;         (result ref)
        ;;     )
        ;;     (then $toJSON
        ;;         (param $json ref)
        ;;     )
        ;;     (catch $reject
        ;;         (param $error ref)
        ;;     )
        ;;     (finally $done
        ;;         (param $result ref)
        ;;     )
        ;; )

        ;; (local.set $arg0 
        ;;     (await $self.fetch<ref>ref 
        ;;         (local.get $url)
        ;;     )
        ;; )
    )

)