.386
.model flat,STDCALL
option casemap :none  ;case sensitive

include file-find.inc

.code
Begin:
	call main
	
invoke ExitProcess,NULL


main proc
	
	invoke SetCurrentDirectory, addr dir
	invoke FindFirstFile, addr find_ptrn, addr fi
	cmp eax, INVALID_HANDLE_VALUE
	je exit
	mov hFind, eax
	
l1:
	cmp fi.cFileName, '.'
	je next
	
	test fi.dwFileAttributes, FILE_ATTRIBUTE_HIDDEN
	jnz next
	
	invoke FileTimeToLocalFileTime, addr fi.ftCreationTime, addr ft
	invoke FileTimeToSystemTime, addr ft, addr syt
	xor eax, eax
	mov ax, syt.wSecond
	push eax
	mov ax, syt.wMinute
	push eax
	mov ax, syt.wHour
	push eax
	mov eax, offset fi.cFileName
	push eax
	push offset message_format
	push offset f_cr_date_res
	call wsprintf
	
	invoke MessageBox, 0, addr f_cr_date_res, addr message_title, MB_ICONQUESTION+MB_OKCANCEL
	cmp eax, IDOK
	jne next
	
	invoke GetSystemTime, addr syt
	invoke SystemTimeToFileTime,addr syt, addr ft
	invoke CreateFile, addr fi.cFileName, GENERIC_WRITE,FILE_SHARE_WRITE,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	mov hFile, eax
	invoke SetFileTime, hFile, addr ft, 0,0
	invoke CloseHandle,hFile
	
	xor eax, eax
	mov ax, syt.wSecond
	push eax
	mov ax, syt.wMinute
	push eax
	mov ax, syt.wHour
	push eax
	mov eax, offset fi.cFileName
	push eax
	push offset message_format
	push offset f_cr_date_res
	call wsprintf
	
	invoke MessageBox, 0, addr f_cr_date_res, addr success_title, MB_ICONQUESTION+MB_OK
	
next:
	invoke FindNextFile,hFind, addr fi
	cmp eax, 0
	jnz l1
	
	invoke FindClose, hFind
	
exit:
	
	ret

main endp

end Begin
