    
    (func $onscheduledclose<>
        (global.set $postTask.isScheduled false)
        (log<ref> text('on scheduledclose called'))
        (call $terminate_all_workers<>)
    )

    (func $schedule_close_task<>
        (if (false === global($postTask.isScheduled)) 
            (then
                (log<ref> text('schedule close task called'))

                (apply $self.Promise.prototype.catch<fun>
                    (call $self.Reflect.apply<ref.ref.ref>ref
                        global($self.Scheduler:postTask)
                        global($self.scheduler)
                        global($postTask.arguments)
                    )
                    (param func($void))
                )
                (global.set $postTask.isScheduled true)
            )
        )
    )

    (func $create_task_scheduler<>
        (log<ref> text('creating task scheduler (only once)'))

        (global.set $postTask.delay i32(3000))
        (global.set $postTask.options new($self.Object<>ref))
        (global.set $postTask.arguments new($self.Array<>ref))

        (call $self.Reflect.set<ref.i32.fun>
            global($postTask.arguments) 
            i32(0) 
            func($onscheduledclose<>) 
        )

        (call $self.Reflect.set<ref.i32.ref>
            global($postTask.arguments)
            i32(1) 
            global($postTask.options) 
        )

        (call $self.Reflect.set<ref.ref.i32>
            global($postTask.options) 
            text('delay') 
            global($postTask.delay) 
        )

        (call $create_abort_controller<>)
    )

    (func $create_abort_controller<>  
        (local $signal ref)

        (log<ref> text('create abort controller called'))

        (global.set $abortController 
            (call $self.Reflect.construct<ref.ref>ref
                global($self.AbortController) self
            )
        )

        (local.set $signal
            (call $self.Reflect.apply<ref.ref.ref>ref
                global($self.AbortController:signal/get)
                global($abortController)
                self
            )
        )

        (call $self.Reflect.apply<ref.ref.ref>
            global($self.AbortSignal:onabort/set)
            local($signal) 
            (call $self.Array.of<fun>ref
                func($create_abort_controller<>)
            )
        )

        (call $self.Reflect.set<ref.ref.ref>
            global($postTask.options) 
            text('signal') 
            local($signal)
        )
    )

    (func $abort_scheduled_task<>
        (if (true === global($postTask.isScheduled)) 
            (then
                (log<ref> text('abort scheduled task called'))

                (call $self.Reflect.apply<ref.ref.ref>
                    global($self.AbortController:abort)
                    global($abortController) 
                    self
                )

                (global.set $postTask.isScheduled false)
            )
        )
    )
