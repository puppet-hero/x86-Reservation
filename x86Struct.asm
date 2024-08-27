extern printf
global main

section .data
format_specifier_name:
	db 'Band Name: %s', 10, 0

format_specifier_email:
	db 'Contact Email: %s', 10, 0

format_specifier_float:
	db 'Ticket Price: %f', 10, 0

format_specifier_num:
	db 'Seat available: %hd', 10, 0

format_specifier_id:
	db 'Venue ID: %d', 10, 0

format_specifier_res:				; placeholder to separate outputs.
	db 'Seat has been reserved', 10, 0

struc Performance					; the struc framework
	s_id resb 10
	s_name resb 25
	s_manager_email resb 30
    s_ticket_price resb 30
	s_seats_array resb 10
	s_num_avail_b resb 10
endstruc

band istruc Performance				; an instance of the struct
	at s_id, dd 123456789,
	at s_name, db "Lovejoy",
	at s_manager_email, db "manager@domain.com",
	at s_ticket_price, dq 3.45,
	at s_seats_array, dw 400, 1070, 10032, 721, 547,
	at s_num_avail_b, db 10
iend

section .text
main:
	push rbp						; this chunk prints the price
	movsd xmm0, [band + s_ticket_price]
	mov rdi, format_specifier_float
	mov rax, rax
	call printf
	pop rbp
	mov rdi, format_specifier_id	; this chunk prints the id
	mov rsi, [band + s_id]
	xor rax, rax
    call printf
    mov rdi, format_specifier_name	; prints the name
	mov rsi, band + s_name
	xor rax, rax
    call printf
    mov rdi, format_specifier_email	; prints the manager's email for the show
	mov rsi, band + s_manager_email
	xor rax, rax
    call printf
	mov rbx, 0						; start a count in rbx
Availability_loop:
	mov rdi, format_specifier_num	; print each element in the array
	mov rsi, [band + s_seats_array + rbx]
	xor rax, rax
	push rbx
	call printf
	pop rbx
	add rbx, 2						; increment the counter by two (because the size each entry takes, must be two)

	cmp rbx, [band + s_num_avail_b]	; has it reached the end of the array yet?
	jne Availability_loop			; if not, bring back to the start of the loop

reserve:							; here is where the change happens
	mov rdi, format_specifier_res	; print that it's happening to separate output
	xor rax, rax
    call printf
	mov rcx, [band + s_num_avail_b]	; change the number available down one entry
	sub rcx, 2
	mov rbx, 0
reserve_output:						; print the array again
	push rcx
	mov rdi, format_specifier_num
	mov rsi, [band + s_seats_array + rbx]
	xor rax, rax
	push rbx
	call printf
	pop rbx
	add rbx, 2						; increment the count
	pop rcx

	cmp rbx, rcx					; are we at the end of the array again?
	jne reserve_output				; if not, do another loop

	mov rax, 60						; exit code
	syscall