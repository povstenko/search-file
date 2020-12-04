include WINDOWS.inc

include user32.inc
include kernel32.inc

includelib user32.lib
includelib kernel32.lib

.data

	find_ptrn db "*.*", 0
	dir db 'c:/lab2_test/',0
	hFind dd 0
	fi WIN32_FIND_DATA <0>
	ft FILETIME <0>
	syt SYSTEMTIME <0>
	
	f_cr_date_res db 200 dup(0)
	message_format db "File: '%s'",13,10,"Created: %d:%d:%d",0
	message_title db "Do you want to change creation date?",0
	success_title db "Creation time was changed",0
	hFile dd 0