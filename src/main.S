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
	
	.extern failure
	.extern init_ssl_ctx
	.extern main_bot_loop
	#.extern _impl_daemon

	.globl main

## SEGMENT ##
	.text
main: #entry point
	#call _impl_daemon

	call init_ssl_ctx
	cmp $0,%rax #checks if NULL 
	je failure

	movq %rax,%rdi
	call main_bot_loop

	xor %eax,%eax
	ret
