	.file	"finaltestiot1.c"
	.section	.data
.LC0:
	.string	"Data"
.test:
	.long 0xdeadbeef
.test1:
	.long 0x1234abcd
.ans:
	.long 0x44c9eb2c
.ans1:
	.long 0xd9700b65
.checksum:
	.int 0
.key:
	.long 0x9a6455c3
.key1:
	.long 0xcb44a0a8
	.text
	.globl	print_secure
	.type	print_secure, @function
print_secure:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$2, -16(%ebp)
	movl	-16(%ebp), %eax
	addl	%eax, %eax
	addl	$5, %eax
	movl	%eax, -16(%ebp)
	movl	$0, -12(%ebp)
	movl 	.key,%edi
	xorl	.test,%edi #xor tester
	cmpl	%edi,.ans
	je	guard
	addl	%ebx,%ebp
	guard:
		movl .checksum,%ebx	#initialising ebx(checksum reg) to 0
		movl  $client_start,%ecx
	for:
		cmpl $client_end,%ecx	#if ecx greater than client_end
		jg end
		addl (%ecx),%ebx 
		addl $4,%ecx
		jmp for
	end:
		cmpl .key,%ebx	#comparing calculated checksum with existing value
		je succ
		addl %ebx,%ebp	#corrupting ebp if tampering found
	succ:
	jmp	.L2

.L3:
	client_start: #code to be protected
	movl	$.LC0, (%esp)
	call	puts
	addl	$1, -12(%ebp)
.L2:
	cmpl	$4, -12(%ebp)
	jle	.L3
	
	guard1:
		movl .checksum,%ebx	#initialising ebx(checksum reg) to 0
		movl  $guard,%ecx	#guard to verify the first guard
	for1:
		cmpl $succ,%ecx	#if ecx greater than succ(client end)
		jg end1
		addl (%ecx),%ebx 
		addl $4,%ecx
		jmp for1
	end1:
		cmpl .key1,%ebx	#comparing calculated checksum with existing value
		je succ1
	client_end:
		addl %ebx,%ebp
	succ1:
	movl 	.key1,%edi
	xorl	.test1,%edi
	cmpl	%edi,.ans1
	je	ver
	addl	%ebx,%ebp
	ver:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	print_secure, .-print_secure
	.section	.rodata
	.align 4
.LC1:
	.string	"AAAAAAAAAAAAAAAABBBB\337\202\004\b\357\276\255\336C\204\004\b"
	.text
	.globl	verify
	.type	verify, @function
verify:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$.LC1, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	verify, .-verify
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	call	verify
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc

.LFE2:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
