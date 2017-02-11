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
	.extern failure

## SEGMENT ##
	.text
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
