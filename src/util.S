	.global failure

	.text
failure: #exit with failure code
	movq $1,%rbx
	movq $1,%rax
	int $0x80
