	.global main_bot_loop

	.extern https_get_request
	.extern parse_http_response
	.extern _impl_get_value_from_kvpair
	.extern _impl_compose_botop
	.extern atol
	.extern strstr
	.extern strtok
	.extern _impl_get_value_from_kvpair
	.extern _impl_compose_botop
	.extern _impl_ltoa

	.macro match_key haystack,needle,kvsep,endkvsep,dest
	movq \haystack,%rdi
	movq \needle,%rsi
	call strstr

	cmp $0,%rax
	je failure

	movq %rax,%rdi
	movq \kvsep,%rsi
	call strtok

	cmp $0,%rax
	je failure
	
	movq $0,%rdi
	movq \kvsep,%rsi
	call strtok

	cmp $0,%rax
	je failure

	movq %rax,%rdi
	movq \endkvsep,%rsi
	leaq (\dest),%rdx
	call _impl_get_value_from_kvpair
	.endm
	

## SEGMENT ##
	.data
update_id:
	.asciz "\"update_id\""
kv_pair_sepr:
	.asciz ":"
kv_pair_end:
	.asciz ","

## SEGMENT ##
	.bss
	.lcomm query 100
	.lcomm updateid_dest 50

## SEGMENT ##
	.text
main_bot_loop:
	pushq %rdi
	
	movq $updateid_dest,%rdi
	leaq (query),%rsi
	call _impl_compose_botop

	popq %rdi
	pushq %rdi
	movq $query,%rsi
	call https_get_request

	match_key %rax,$update_id,$kv_pair_sepr,$kv_pair_end,updateid_dest
	
	movq $updateid_dest,%rdi
	call atol

	inc %rax

	movq %rax,%rdi
	leaq (updateid_dest),%rsi
	call _impl_ltoa

	popq %rdi
	jmp main_bot_loop
