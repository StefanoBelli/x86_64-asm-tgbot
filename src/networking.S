	.global init_ssl_ctx
	.global __connect
	.global __ssl_disconnect
	.global get_ssl

	.extern SSL_library_init
	.extern _impl_OpenSSL_add_all_algorithms
	.extern SSLv23_client_method
	.extern SSL_CTX_new
	.extern SSL_free
	.extern SSL_set_fd
	.extern socket
	.extern connect
	.extern close
	.extern _impl_resolve_and_connect
	.extern failure
	.extern _impl_enable_tcp_keepalive

## SEGMENT ##
	.text
/* Required: none */
init_ssl_ctx:
	call SSL_library_init
	call _impl_OpenSSL_add_all_algorithms
	call SSLv23_client_method

	movq %rax,%rdi
	call SSL_CTX_new
	
	ret

__connect:
	movq $2, %rdi
	movq $1, %rsi
	movq $0, %rdx
	call socket
	cmp $0,%rax
	jl failure

	pushq %rax

	movq %rax,%rdi
	call _impl_enable_tcp_keepalive
	cmp $1,%rax
	je failure

	popq %rdi
	pushq %rdi
	
	call _impl_resolve_and_connect
	cmp $0,%rax
	jl failure

	popq %rax
	ret

/* Required:
   - RDI register: socket descriptor
	- RSI register: SSL wrapper
*/
__ssl_disconnect:
	call close
	cmp $0,%rax
	jne failure

	cmp $0,%rsi
	je failure

	movq %rsi,%rdi
	call SSL_free

	ret

/* Required:
	- RDI register: SSL context
	- RSI register: socket descriptor
*/
get_ssl:
	pushq %rsi

	cmp $0,%rdi
	je failure

	call SSL_new
	pushq %rax

	cmp $0,%rax
	je failure

	popq %rbx
	popq %rsi
	pushq %rbx
	movq %rbx,%rdi
	call SSL_set_fd

	popq %rax
	ret
