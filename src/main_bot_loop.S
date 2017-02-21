	.global main_bot_loop

	.extern https_get_request
	
## SEGMENT ##
	.data
op_getupdates_fmt:
	.asciz "getUpdates?offset=%lld&timeout=30"

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
	#jmp main_bot_loop
