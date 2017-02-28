	.global failure
	.global https_get_request
	.global parse_http_response
	.global logev

	.extern _impl_compose_http_get_query
	.extern SSL_write
	.extern SSL_read

	//MACRO: sys_write
	//MACRO: sys_open
	//MACRO: sys_close

	.macro sys_write text,bytes,fd
	movq $4,%rax #SYS_write
	movq \fd,%rbx
	movq \text,%rcx
	movq \bytes,%rdx
	int $0x80
	.endm

	.macro sys_open filename
	movq $5,%rax #SYS_open
	movq \filename,%rbx
	#mode edx
	#flags ecx
	#interrupt
	.endm

	.macro sys_close fd
	movq $6,%rax #SYS_close
	movq \fd,%rbx
	int $0x80
	.endm

	//ENDMACRO: sys_close
	//ENDMACRO: sys_open
	//ENDMACRO: sys_write

## SEGMENT ##
	.bss
	.lcomm http_get_query 4096 #change this if strictly required
	.lcomm http_get_response 8192 #I suggest not to change this size

## SEGMENT ##
	.text
failure: #exit with failure code
	movq $1,%rbx
	movq $1,%rax
	int $0x80

/* Required:
	- RDI register: SSL context 
	- RSI register: telegram bot api requested operation
*/
https_get_request:
	pushq %rdi

	movq %rsi, %rdi
	leaq (http_get_query),%rsi
	call _impl_compose_http_get_query

	movq $http_get_query,%rdi
	call strlen
	movq %rax,%rdx
	movq $http_get_query, %rsi
	popq %rdi
	pushq %rdi
	call SSL_write
	cmp $0,%rax
	jle failure

	popq %rdi
	leaq (http_get_response),%rsi
	movq $8192,%rdx
	call SSL_read
	cmp $0,%rax
	jle failure

	movq $http_get_response,%rax
	ret

## INTERNAL UNCONDITIONAL JUMPS ##
log_to_stdout:
	sys_write %rdi,%rsi,$0
	ret

log_to_stderr:
	sys_write %rdi,$4096,$1
	ret

/* Required:
	- RDI register: string to be logged
	- RSI register: where
*/
logev:
	jmp log_to_stdout
