# x86_64 Assembly Telegram Bot
# USE GCC TO ASSEMBLE!
# (For your own *mental* safety)
# 
# AT&T / GNU Assembler syntax
#
# Some things may be implemented in impls.c file
# So, you may want to look at the C source code
# +---------------------------------------------------+
# <(C) COPYLEFT, Stefano Belli <stefano9913@gmail.com>
# +---------------------------------------------------+
	.extern SSL_library_init
	.extern _impl_OpenSSL_add_all_algorithms
	.extern SSLv23_client_method
	.extern SSL_CTX_new
	.extern SSL_free
	.extern SSL_set_fd
	.extern socket
	.extern connect
	.extern close

## SEGMENT ##
	.data
	
op_req_getupdates:
	.asciz "getUpdates?offset=%lld&timeout=30"

## SEGMENT ##
	.text
	.globl main

failure: #exit with failure code
	movl $1,%ebx
	movl $1,%eax #SYS_EXIT
	int $0x80 

init_ssl_ctx:
	call SSL_library_init
	call _impl_OpenSSL_add_all_algorithms
	call SSLv23_client_method

	movq %rax,%rdi
	call SSL_CTX_new
	
	ret

__connect:
	pushq %rdi
   pushq %rsi

	movq $2, %rdi
	movq $1, %rsi
	movq $0, %rdx
	call socket
	pushq %rax

	cmp $0,%rax
	jl failure

	movq %rax,%rdi
	popq %rax
	popq %rdx
	popq %rsi
	pushq %rax
	call connect
	cmp $0,%rax
	jne failure

	popq %rax
	ret

__ssl_disconnect:
	call close
	cmp $0,%rax
	jne failure

	cmp $0,%rsi
	je failure

	movq %rsi,%rdi
	call SSL_free

	ret

get_ssl:
	cmp $0,%rdi
	je failure

	call SSL_new
	pushq %rax

	movq %rax,%rdi
	call SSL_set_fd

	popq %rax
	ret

##
main: #entry point
	call init_ssl_ctx
	cmp $0,%rax #checks if NULL 
	je failure
	pushq %rax

	call __connect
	pushq %rax

	movq %rax, %rsi
	popq %rbx
	popq %rax
	pushq %rbx
	movq %rax, %rdi
	call get_ssl

	movq %rax,%rsi
	popq %rax
	movq %rax,%rdi
	call __ssl_disconnect

	xor %eax,%eax
	ret
