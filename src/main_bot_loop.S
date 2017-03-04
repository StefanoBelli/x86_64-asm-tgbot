	.global main_bot_loop

	.extern https_get_request
	.extern parse_http_response
	.extern _impl_get_value_from_kvpair
	.extern _impl_compose_botop
	.extern atol
	.extern strstr
	.extern strtok
	.extern _impl_get_value_from_kvpair
	.extern _impl_getupdates_botop
	.extern _impl_ltoa

	.macro match_key haystack,needle,kvsep,endkvsep,dest
	movq \haystack,%rdi
	movq \needle,%rsi
	call strstr

	cmp $0,%rax
	je reloop

	movq %rax,%rdi
	movq \kvsep,%rsi
	call strtok

	cmp $0,%rax
	je reloop
	
	movq $0,%rdi
	movq \kvsep,%rsi
	call strtok

	cmp $0,%rax
	je reloop

	movq %rax,%rdi
	movq \endkvsep,%rsi
	leaq (\dest),%rdx
	call _impl_get_value_from_kvpair
	.endm

## SEGMENT ##
	.data
text:
	.asciz "\"text\""
update_id:
	.asciz "\"update_id\""
kv_pair_sepr:
	.asciz ":"
update_kv_pair_end:
	.asciz ","
text_kv_pair_end:
	.asciz "}"
id:
	.asciz "\"id\""
expected_noupdates:
	.asciz "\"result\":[]"
expected_apiret_ok:
	.asciz "\"ok\":true"
got_an_update:
	.asciz "Update received\n"

#filename:
#  .asciz "fname"

## SEGMENT ##
	.bss
	.lcomm query 100
	.lcomm updateid_dest 50
	.lcomm text_dest 500
	.lcomm id_dest 50

## SEGMENT ##
	.text
main_bot_loop:	
	pushq %rdi

	movq $updateid_dest,%rdi
	leaq (query),%rsi
	call _impl_getupdates_botop

	popq %rdi
	pushq %rdi
	movq $query,%rsi
	call https_get_request

	pushq %rax

	movq %rax,%rdi
	movq $expected_apiret_ok,%rsi
	call strstr
	cmp $0,%rax
	je reloop_noupdates

	popq %rax
	pushq %rax
    
	movq %rax,%rdi
	movq $expected_noupdates,%rsi
	call strstr
	cmp $0,%rax
	jne reloop_noupdates

	popq %rax
	pushq %rax
	match_key %rax,$text,$kv_pair_sepr,$text_kv_pair_end,text_dest

	popq %rax
	pushq %rax
	match_key %rax,$id,$kv_pair_sepr,$update_kv_pair_end,id_dest

	popq %rax
	match_key %rax,$update_id,$kv_pair_sepr,$update_kv_pair_end,updateid_dest

	movq $updateid_dest,%rdi
	call atol

	inc %rax

	movq %rax,%rdi
	leaq (updateid_dest),%rsi
	call _impl_ltoa

	jmp reloop

reloop:
	popq %rdi
	jmp main_bot_loop

reloop_noupdates:
	popq %rax
	popq %rdi
	jmp main_bot_loop
