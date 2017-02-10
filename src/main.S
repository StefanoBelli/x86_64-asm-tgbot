	.text
	.globl main
init_ssl_ctx:
	call SSL_library_init
	call _impl_OpenSSL_add_all_algorithms
	call SSLv23_client_method
	call SSL_CTX_new
	ret

main:
	call init_ssl_ctx

	xor %eax,%eax
	ret
