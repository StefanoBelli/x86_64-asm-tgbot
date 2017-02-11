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

	.extern init_ssl_ctx
	.extern __connect
	.extern get_ssl
	.extern __ssl_disconnect
	
	.globl main

## SEGMENT ##
	.data
op_req_getupdates:
	.asciz "getUpdates?offset=%lld&timeout=30"

## SEGMENT ##
	.text
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

	popq %rax
	xor %eax,%eax
	ret
