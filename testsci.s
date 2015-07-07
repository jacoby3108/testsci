	.file	"testsci.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Unknown Cmd "
	.text
	.p2align 4,,15
	.globl	Unknown_Cmd
	.type	Unknown_Cmd, @function
Unknown_Cmd:
.LFB45:
	.cfi_startproc
	subl	$28, %esp
	.cfi_def_cfa_offset 32
	movl	$.LC0, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE45:
	.size	Unknown_Cmd, .-Unknown_Cmd
	.section	.rodata.str1.1
.LC1:
	.string	"End of messages "
	.text
	.p2align 4,,15
	.globl	Cmd_No_more_msj
	.type	Cmd_No_more_msj, @function
Cmd_No_more_msj:
.LFB46:
	.cfi_startproc
	subl	$28, %esp
	.cfi_def_cfa_offset 32
	movl	$.LC1, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE46:
	.size	Cmd_No_more_msj, .-Cmd_No_more_msj
	.section	.rodata.str1.1
.LC2:
	.string	"Set text Cmd :"
	.text
	.p2align 4,,15
	.globl	Cmd_Set_Text
	.type	Cmd_Set_Text, @function
Cmd_Set_Text:
.LFB44:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	subl	$40, %esp
	.cfi_def_cfa_offset 48
	movl	$.LC2, 4(%esp)
	leal	31(%esp), %ebx
	movl	$1, (%esp)
	call	__printf_chk
	jmp	.L8
	.p2align 4,,7
	.p2align 3
.L15:
	movl	%ebx, (%esp)
	call	PullQueue
	movb	%al, result
	movzbl	31(%esp), %eax
	movl	%eax, (%esp)
	call	putchar
	cmpb	$0, 31(%esp)
	je	.L5
.L8:
	call	QueueStatus
	testl	%eax, %eax
	jne	.L15
.L5:
	addl	$40, %esp
	.cfi_def_cfa_offset 8
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	.p2align 4,,2
	ret
	.cfi_endproc
.LFE44:
	.size	Cmd_Set_Text, .-Cmd_Set_Text
	.section	.rodata.str1.1
.LC3:
	.string	"SCI FSM: End Of Transmision"
.LC4:
	.string	"SCI FSM: End Of message"
.LC5:
	.string	"SCI FSM: Unexpected Event\n "
	.text
	.p2align 4,,15
	.globl	irq_sci
	.type	irq_sci, @function
irq_sci:
.LFB40:
	.cfi_startproc
	subl	$28, %esp
	.cfi_def_cfa_offset 32
	movzbl	Sci_State, %eax
	cmpb	$1, %al
	je	.L18
	jb	.L19
	cmpb	$2, %al
	je	.L20
	movl	$.LC5, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
.L16:
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,7
	.p2align 3
.L20:
	.cfi_restore_state
	movzbl	rxdata, %eax
	cmpb	$3, %al
	je	.L27
	movl	%eax, (%esp)
	call	PushQueue
	movb	%al, result
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,7
	.p2align 3
.L19:
	.cfi_restore_state
	movzbl	rxdata, %eax
	cmpb	$5, %al
	je	.L28
	cmpb	$2, %al
	jne	.L16
	movb	$1, Sci_State
	jmp	.L16
	.p2align 4,,7
	.p2align 3
.L18:
	movzbl	rxdata, %eax
	cmpb	$3, %al
	je	.L29
	movl	%eax, (%esp)
	call	PushQueue
	movb	$2, Sci_State
	movb	%al, result
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,7
	.p2align 3
.L29:
	.cfi_restore_state
	movl	$.LC3, (%esp)
	call	puts
	movl	$4, (%esp)
	call	PushQueue
	movb	$0, Sci_State
	movb	%al, result
	jmp	.L16
	.p2align 4,,7
	.p2align 3
.L27:
	movl	$.LC4, (%esp)
	call	puts
	movl	$0, (%esp)
	call	PushQueue
	movb	$0, Sci_State
	movb	%al, result
	jmp	.L16
	.p2align 4,,7
	.p2align 3
.L28:
	movl	$6, (%esp)
	call	send
	jmp	.L16
	.cfi_endproc
.LFE40:
	.size	irq_sci, .-irq_sci
	.p2align 4,,15
	.globl	testbench_1
	.type	testbench_1, @function
testbench_1:
.LFB41:
	.cfi_startproc
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	QueueInit
	movl	i, %eax
	.p2align 4,,7
	.p2align 3
.L31:
	leal	1(%eax), %edx
	movl	testdata(,%eax,4), %eax
	movl	%edx, i
	testl	%eax, %eax
	movl	%eax, ptestdata
	je	.L30
	leal	1(%eax), %ecx
	movl	%ecx, ptestdata
	movzbl	(%eax), %eax
	testb	%al, %al
	movb	%al, rxdata
	je	.L39
	.p2align 4,,7
	.p2align 3
.L37:
	call	irq_sci
	movl	ptestdata, %eax
	leal	1(%eax), %edx
	movl	%edx, ptestdata
	movzbl	(%eax), %eax
	testb	%al, %al
	movb	%al, rxdata
	jne	.L37
	movl	i, %eax
	jmp	.L31
.L30:
	addl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4
	ret
.L39:
	.cfi_restore_state
	movl	%edx, %eax
	.p2align 4,,2
	jmp	.L31
	.cfi_endproc
.LFE41:
	.size	testbench_1, .-testbench_1
	.section	.rodata.str1.1
.LC6:
	.string	"r+"
.LC7:
	.string	"/dev/rfcomm0"
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC8:
	.string	"Error while opening the file.\n"
	.section	.rodata.str1.1
.LC9:
	.string	"Hello Droid"
	.text
	.p2align 4,,15
	.globl	testbench_2
	.type	testbench_2, @function
testbench_2:
.LFB42:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	subl	$24, %esp
	.cfi_def_cfa_offset 32
	movl	$.LC6, 4(%esp)
	movl	$.LC7, (%esp)
	call	fopen
	testl	%eax, %eax
	movl	%eax, %ebx
	je	.L45
	movl	%eax, 12(%esp)
	movl	$11, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC9, (%esp)
	call	fwrite
	jmp	.L42
	.p2align 4,,7
	.p2align 3
.L43:
	movsbl	%al, %edx
	movl	%edx, (%esp)
	call	putchar
.L42:
	movl	%ebx, (%esp)
	call	fgetc
	cmpb	$-1, %al
	jne	.L43
	movl	%ebx, (%esp)
	call	fclose
	addl	$24, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
.L45:
	.cfi_restore_state
	movl	$.LC8, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE42:
	.size	testbench_2, .-testbench_2
	.p2align 4,,15
	.globl	command_parser
	.type	command_parser, @function
command_parser:
.LFB43:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	subl	$40, %esp
	.cfi_def_cfa_offset 48
	movl	48(%esp), %ebx
	call	QueueStatus
	movl	$-1, %edx
	testl	%eax, %eax
	jne	.L60
	addl	$40, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	movl	%edx, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,7
	.p2align 3
.L60:
	.cfi_restore_state
	leal	31(%esp), %eax
	movl	%eax, (%esp)
	call	PullQueue
	movb	%al, result
	movzbl	(%ebx), %eax
	cmpb	$-1, %al
	je	.L48
	movzbl	31(%esp), %edx
	jmp	.L59
	.p2align 4,,7
	.p2align 3
.L61:
	addl	$8, %ebx
	movzbl	(%ebx), %eax
	cmpb	$-1, %al
	je	.L48
.L59:
	cmpb	%dl, %al
	jne	.L61
.L48:
	call	*4(%ebx)
	xorl	%edx, %edx
	addl	$40, %esp
	.cfi_def_cfa_offset 8
	movl	%edx, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE43:
	.size	command_parser, .-command_parser
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB39:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$16, %esp
	call	testbench_1
	jmp	.L63
	.p2align 4,,7
	.p2align 3
.L64:
	movl	$commands, (%esp)
	call	command_parser
	movl	$10, (%esp)
	call	putchar
.L63:
	call	QueueStatus
	testl	%eax, %eax
	jne	.L64
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	.p2align 4,,5
	ret
	.cfi_endproc
.LFE39:
	.size	main, .-main
	.globl	commands
	.data
	.align 32
	.type	commands, @object
	.size	commands, 40
commands:
	.byte	84
	.zero	3
	.long	Cmd_Set_Text
	.byte	84
	.zero	3
	.long	Cmd_Set_Text
	.byte	84
	.zero	3
	.long	Cmd_Set_Text
	.byte	4
	.zero	3
	.long	Cmd_No_more_msj
	.byte	-1
	.zero	3
	.long	Unknown_Cmd
	.comm	result,1,1
	.comm	rxdata,1,1
	.comm	Sci_State,1,1
	.globl	i
	.bss
	.align 4
	.type	i, @object
	.size	i, 4
i:
	.zero	4
	.globl	ptestdata
	.align 4
	.type	ptestdata, @object
	.size	ptestdata, 4
ptestdata:
	.zero	4
	.globl	testdata
	.data
	.align 32
	.type	testdata, @object
	.size	testdata, 36
testdata:
	.long	pSTX
	.long	pmsg0
	.long	pETX
	.long	pSTX
	.long	pmsg1
	.long	pETX
	.long	pSTX
	.long	pETX
	.long	0
	.globl	pmsg1
	.type	pmsg1, @object
	.size	pmsg1, 6
pmsg1:
	.string	"T6789"
	.globl	pmsg0
	.type	pmsg0, @object
	.size	pmsg0, 5
pmsg0:
	.string	"T234"
	.globl	pETX
	.type	pETX, @object
	.size	pETX, 2
pETX:
	.byte	3
	.byte	0
	.globl	pSTX
	.type	pSTX, @object
	.size	pSTX, 2
pSTX:
	.byte	2
	.byte	0
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
