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

	.extern get_ssl
	.extern SSL_connect
	.extern X509_free
	.extern SSL_get_peer_certificate
	.extern failure
	.extern init_ssl_ctx
	.extern main_bot_loop
	.extern __connect
	#.extern _impl_daemon

	.globl main

## SEGMENT ##
	.text
main: #entry point
	#call _impl_daemon

	call init_ssl_ctx
	cmp $0,%rax #checks if NULL 
	je failure
	pushq %rax

	call __connect
	pushq %rax

	popq %rsi
	popq %rdi
	call get_ssl
	pushq %rax

	movq %rax,%rdi
	call SSL_connect
	cmp $1,%rax
	jne failure

	popq %rdi
	pushq %rdi
	call SSL_get_peer_certificate
	cmp $0,%rax
	je failure

	movq %rax,%rdi
	call X509_free

	popq %rdi
	call main_bot_loop

	xor %eax,%eax
	ret
