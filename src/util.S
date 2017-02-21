	.global failure
	.global https_get_request

	.extern __connect
	.extern get_ssl
	.extern __ssl_disconnect
	.extern SSL_connect
	.extern _impl_compose_http_get_query
	.extern SSL_write
	.extern SSL_read
	
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

	call __connect
	pushq %rax

	popq %rax
	popq %rdi
	pushq %rax
	movq %rax,%rsi
	call get_ssl
	pushq %rax

	movq %rax,%rdi
	call SSL_connect
	cmp $1,%rax
	jne failure

	popq %rdi 
	pushq %rdi 
	movq $http_get_query, %rsi
	movq $4096, %rdx 
	call SSL_write
	cmp $0,%rax
	jle failure

	popq %rdi
	pushq %rdi
	leaq (http_get_response),%rsi
	movq $8192,%rdx
	call SSL_read
	cmp $0,%rax
	jle failure

	popq %rax
	movq %rax,%rsi #ssl
	popq %rdi #sfd
	call __ssl_disconnect

	ret
