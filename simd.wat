(module
    (import "env" "memory" (memory 0x00010000 0x00010000 shared))

    (func $f32_add (export "f32_add")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (param $valByteOffset i32)
        (param $valLength i32)         

        (local $splat v128)   
        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $valByteOffset))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)
        
        (if (i32.eq (i32.const 1) (local.get $valLength))
            (then
                (local.set $splat 
                    (v128.load32_splat offset=0x26e22a98
                        (i32x4.extract_lane 2 (local.get $iterate))
                    )
                )

                (loop $v128a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.add 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (local.get $splat)
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 0 -4)
                                )
                            )

                            (br $v128a) 
                        )
                    )
                )

                (loop $i32a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.add 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32x4.extract_lane 0 (local.get $splat))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 0 -1)
                                )
                            )

                            (br $i32a) 
                        )
                    )
                )

                (return)
            )
        )

        (if (i32.eq (local.get $valLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.add 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 16 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.add 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 4 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )

    (func $f32_sub (export "f32_sub")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (param $valByteOffset i32)
        (param $valLength i32)        

        (local $splat v128)   
        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $valByteOffset))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)

        (if (i32.eq (i32.const 1) (local.get $valLength))
            (then
                (local.set $splat 
                    (v128.load32_splat offset=0x26e22a98
                        (i32x4.extract_lane 2 (local.get $iterate))
                    )
                )

                (loop $v128a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.sub 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (local.get $splat)
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 0 -4)
                                )
                            )

                            (br $v128a) 
                        )
                    )
                )

                (loop $i32a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.sub 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32x4.extract_lane 0 (local.get $splat))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 0 -1)
                                )
                            )

                            (br $i32a) 
                        )
                    )
                )

                (return)
            )
        )

        (if (i32.eq (local.get $valLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.sub 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 16 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.sub 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 4 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )

    (func $f32_mul (export "f32_mul")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (param $valByteOffset i32)
        (param $valLength i32)        

        (local $splat v128)   
        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $valByteOffset))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)

        (if (i32.eq (i32.const 1) (local.get $valLength))
            (then
                (local.set $splat 
                    (v128.load32_splat offset=0x26e22a98
                        (i32x4.extract_lane 2 (local.get $iterate))
                    )
                )

                (loop $v128a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.mul 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (local.get $splat)
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 0 -4)
                                )
                            )

                            (br $v128a) 
                        )
                    )
                )

                (loop $i32a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.mul 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32x4.extract_lane 0 (local.get $splat))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 0 -1)
                                )
                            )

                            (br $i32a) 
                        )
                    )
                )

                (return)
            )
        )

        (if (i32.eq (local.get $valLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.mul 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 16 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.mul 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 4 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )

    (func $f32_div (export "f32_div")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (param $valByteOffset i32)
        (param $valLength i32)       

        (local $splat v128)   
        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $valByteOffset))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)

        (if (i32.eq (i32.const 1) (local.get $valLength))
            (then
                (local.set $splat 
                    (v128.load32_splat offset=0x26e22a98
                        (i32x4.extract_lane 2 (local.get $iterate))
                    )
                )

                (loop $v128a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.div 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (local.get $splat)
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 0 -4)
                                )
                            )

                            (br $v128a) 
                        )
                    )
                )

                (loop $i32a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.div 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32x4.extract_lane 0 (local.get $splat))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 0 -1)
                                )
                            )

                            (br $i32a) 
                        )
                    )
                )

                (return)
            )
        )

        (if (i32.eq (local.get $valLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.div 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 16 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.div 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 4 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )

    (func $f32_min (export "f32_min")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (param $valByteOffset i32)
        (param $valLength i32)         

        (local $splat v128)   
        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $valByteOffset))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)

        (if (i32.eq (i32.const 1) (local.get $valLength))
            (then
                (local.set $splat 
                    (v128.load32_splat offset=0x26e22a98
                        (i32x4.extract_lane 2 (local.get $iterate))
                    )
                )

                (loop $v128a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.min 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (local.get $splat)
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 0 -4)
                                )
                            )

                            (br $v128a) 
                        )
                    )
                )

                (loop $i32a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.min 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32x4.extract_lane 0 (local.get $splat))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 0 -1)
                                )
                            )

                            (br $i32a) 
                        )
                    )
                )

                (return)
            )
        )

        (if (i32.eq (local.get $valLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.min 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 16 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.min 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 4 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )

    (func $f32_max (export "f32_max")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (param $valByteOffset i32)
        (param $valLength i32)         

        (local $splat v128)   
        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $valByteOffset))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)

        (if (i32.eq (i32.const 1) (local.get $valLength))
            (then
                (local.set $splat 
                    (v128.load32_splat offset=0x26e22a98
                        (i32x4.extract_lane 2 (local.get $iterate))
                    )
                )

                (loop $v128a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.max 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (local.get $splat)
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 0 -4)
                                )
                            )

                            (br $v128a) 
                        )
                    )
                )

                (loop $i32a
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.max 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32x4.extract_lane 0 (local.get $splat))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 0 -1)
                                )
                            )

                            (br $i32a) 
                        )
                    )
                )

                (return)
            )
        )

        (if (i32.eq (local.get $valLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.max 
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (v128.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 16 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.max 
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate)))
                                    (f32.load offset=0x26e22a98 (i32x4.extract_lane 2 (local.get $iterate)))
                                )
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 4 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )

    (func $f32_abs (export "f32_abs")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $srcLength))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)

        (if (i32.eq (local.get $srcLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.abs (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate))))
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 -4 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.abs (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate))))
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 -1 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )

    (func $f32_neg (export "f32_neg")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $srcLength))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)

        (if (i32.eq (local.get $srcLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.neg (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate))))
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 -4 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.neg (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate))))
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 -1 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )

    (func $f32_sqrt (export "f32_sqrt")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $srcLength))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)

        (if (i32.eq (local.get $srcLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.sqrt (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate))))
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 -4 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.sqrt (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate))))
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 -1 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )

    (func $f32_ceil (export "f32_ceil")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $srcLength))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)

        (if (i32.eq (local.get $srcLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.ceil (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate))))
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 -4 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.ceil (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate))))
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 -1 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )

    (func $f32_floor (export "f32_floor")
        (param $dstByteOffset i32)
        (param $dstLength i32)

        (param $srcByteOffset i32)
        (param $srcLength i32)

        (local $iterate v128)   

        (local.get $iterate)
        (i32x4.replace_lane 0 (local.get $dstByteOffset))
        (i32x4.replace_lane 1 (local.get $srcByteOffset))
        (i32x4.replace_lane 2 (local.get $srcLength))
        (i32x4.replace_lane 3 (local.get $dstLength))
        (local.set $iterate)

        (if (i32.eq (local.get $srcLength) (local.get $dstLength))
            (then
                (loop $v128b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 4))
                        (then
                            (v128.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32x4.floor (v128.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate))))
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 16 16 -4 -4)
                                )
                            )

                            (br $v128b) 
                        )
                    )
                )

                (loop $i32b
                    (if (i32.ge_u (i32x4.extract_lane 3 (local.get $iterate)) (i32.const 1))
                        (then
                            (f32.store offset=0x26e22a98 
                                (i32x4.extract_lane 0 (local.get $iterate))
                                (f32.floor (f32.load offset=0x26e22a98 (i32x4.extract_lane 1 (local.get $iterate))))
                            )

                            (local.set $iterate
                                (i32x4.add 
                                    (local.get $iterate) 
                                    (v128.const i32x4 4 4 -1 -1)
                                )
                            )

                            (br $i32b) 
                        )
                    )
                )

                (return)
            )
        )

        (unreachable)
    )
)