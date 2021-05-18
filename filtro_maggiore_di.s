.section .rodata
fmt_num_in: .asciz "Inserire il filtro di ricerca (maggione di questa quantità): "
fmt_scan_filter:    .asciz "%d"
filename1:  .asciz "informazione.dat"
rmode:      .asciz "r"

.bss
n_ord:  .skip 4
n_filter .word 
.macro read_n_orders
ldr x0, =n_orders
mov x1, #4
mov x2, #1
mov x3, x19
bl fread
.endm

.macro read_orders
ldr x0, =orders
mov x1, order_size_aligned
mov x2, w20
mov x3, x19
bl fread
.endm

.macro scan_filter n
    adr x0, fmt_scan_filter
    adr x1, \n
    bl scanf
.endm

.text
.type no_filtro_maggiore_di, %function
.global no_filtro_maggiore_di
no_filtro_maggiore_di:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    adr x0, filename1
    adr x1, rmode
    bl fopen

    cmp x0, #0
    beq end

    mov x19, x0
    read_n_orders
    adr x0, =n_ord
    ldr w20, [x0]
    read_orders
    mov w21, #0

    adr x0, fmt_num_in
    bl printf
    scan n_filter
    ldr x22, n_filter
   
    loop:
        cmp w21, w20
        beq end

        ldr x0, =orders
        mov x1, order_size_aligned
        madd x0, x1, w21, x0

        ldr x2, [x0, size_order_quantity]
        cmp x2, x22
        blt end_loop

        mov x1, w21, #1
        add x2, x0, offset_order_name
        ldr x3, [x0, offset_order_quantity]
        ldr x4, [x0, offset_order_thickness]
        ldr x5, [x0, offset_order_unit_price]
        adr x0, fmt_menu_entry
        bl printf


        end_loop:
        add w21, w21, #1
        b loop
    


    end:
        mov w0, #0
        ldp x21, x22, [sp], #16
        ldp x19, x20, [sp], #16
        ldp x29, x30, [sp], #16
        ret
        .size no_filtro_maggiore_di, (. - no_filtro_maggiore_di)