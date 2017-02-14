	.global failure
	.global https_get_request

	.extern __connect
	.extern get_ssl
	.extern __ssl_disconnect

## SEGMENT ##
	.text
failure: #exit with failure code
	movq $1,%rbx
	movq $1,%rax
	int $0x80

https_get_request:
	pushq %rdi
	pushq %rsi

  call _impl_get_tghost_addr
    
#movq $socklen %rdi
#movq $addr %rsi
	call __connect
	pushq %rax

	movq %rax,%rsi
	popq %rax
	popq %rdi
	pushq %rax
	call get_ssl
	pushq %rax

	# SSL_connect

	# SSL_write 

	# SSL_read

	popq %rsi
	popq %rdi
	call __ssl_disconnect

	popq %rdi

	movq $0,%rax
	ret