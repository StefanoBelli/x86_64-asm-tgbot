	.global main_bot_loop

	.extern https_get_request
	.extern parse_http_response

## SEGMENT ##
	.data
op_getupdates_fmt:
	.asciz "getUpdates?timeout=30&limit=1"

## SEGMENT ##
	.text
main_bot_loop:
	#snprintf
	# (do the stuffs)
	#call https_get_request
	#take the value from https_get_request
	#pass to the json parser
	movq $op_getupdates_fmt,%rsi
	call https_get_request
	movq %rax,%rdi
	call parse_http_response

	#jmp main_bot_loop
