
testsci.o:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
				 



void main (void)	// SCI FSM Test bench
{
   0:	55                   	push   ebp
   1:	89 e5                	mov    ebp,esp
   3:	83 e4 f0             	and    esp,0xfffffff0
   6:	83 ec 10             	sub    esp,0x10
	
	
	testbench_1();				// simulates reception of data
   9:	e8 fc ff ff ff       	call   a <main+0xa>
	
	while (QueueStatus())
   e:	eb 18                	jmp    28 <main+0x28>
	{
		command_parser(commands);
  10:	c7 04 24 00 00 00 00 	mov    DWORD PTR [esp],0x0
  17:	e8 fc ff ff ff       	call   18 <main+0x18>
	
		printf("\n");
  1c:	c7 04 24 0a 00 00 00 	mov    DWORD PTR [esp],0xa
  23:	e8 fc ff ff ff       	call   24 <main+0x24>
{
	
	
	testbench_1();				// simulates reception of data
	
	while (QueueStatus())
  28:	e8 fc ff ff ff       	call   29 <main+0x29>
  2d:	85 c0                	test   eax,eax
  2f:	75 df                	jne    10 <main+0x10>
	
		printf("\n");
	}
	
	
}
  31:	c9                   	leave  
  32:	c3                   	ret    

00000033 <irq_sci>:
	
	
void irq_sci(void)	
{	
  33:	55                   	push   ebp
  34:	89 e5                	mov    ebp,esp
  36:	83 ec 18             	sub    esp,0x18
	switch (Sci_State)		// Tiny FSM for SCI reception
  39:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  40:	0f b6 c0             	movzx  eax,al
  43:	83 f8 01             	cmp    eax,0x1
  46:	74 46                	je     8e <irq_sci+0x5b>
  48:	83 f8 02             	cmp    eax,0x2
  4b:	0f 84 8e 00 00 00    	je     df <irq_sci+0xac>
  51:	85 c0                	test   eax,eax
  53:	0f 85 d0 00 00 00    	jne    129 <irq_sci+0xf6>
	{
	
	//**************ILDE State*********************//
		case S_ILDE:		
		
			if(rxdata==ENQ)
  59:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  60:	3c 05                	cmp    al,0x5
  62:	75 0e                	jne    72 <irq_sci+0x3f>
				send(ACK);
  64:	c7 04 24 06 00 00 00 	mov    DWORD PTR [esp],0x6
  6b:	e8 fc ff ff ff       	call   6c <irq_sci+0x39>
  70:	eb 17                	jmp    89 <irq_sci+0x56>
			else if(rxdata==STX)
  72:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  79:	3c 02                	cmp    al,0x2
  7b:	75 0c                	jne    89 <irq_sci+0x56>
				Sci_State=S_STX;	
  7d:	c6 05 00 00 00 00 01 	mov    BYTE PTR ds:0x0,0x1
		break;
  84:	e9 ac 00 00 00       	jmp    135 <irq_sci+0x102>
  89:	e9 a7 00 00 00       	jmp    135 <irq_sci+0x102>
	
		
	//**************STX State*********************//
		case S_STX:
	
			if(rxdata==ETX)
  8e:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  95:	3c 03                	cmp    al,0x3
  97:	75 26                	jne    bf <irq_sci+0x8c>
			{
							
				printf("SCI FSM: End Of Transmision\n");
  99:	c7 04 24 00 00 00 00 	mov    DWORD PTR [esp],0x0
  a0:	e8 fc ff ff ff       	call   a1 <irq_sci+0x6e>
				
				result=PushQueue(EOT);
  a5:	c7 04 24 04 00 00 00 	mov    DWORD PTR [esp],0x4
  ac:	e8 fc ff ff ff       	call   ad <irq_sci+0x7a>
  b1:	a2 00 00 00 00       	mov    ds:0x0,al
				Sci_State=S_ILDE;
  b6:	c6 05 00 00 00 00 00 	mov    BYTE PTR ds:0x0,0x0
				
				result=PushQueue(rxdata);
				Sci_State=S_DATA;
			}
		
		break;
  bd:	eb 76                	jmp    135 <irq_sci+0x102>
				
			}
			else 
			{
				
				result=PushQueue(rxdata);
  bf:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  c6:	0f b6 c0             	movzx  eax,al
  c9:	89 04 24             	mov    DWORD PTR [esp],eax
  cc:	e8 fc ff ff ff       	call   cd <irq_sci+0x9a>
  d1:	a2 00 00 00 00       	mov    ds:0x0,al
				Sci_State=S_DATA;
  d6:	c6 05 00 00 00 00 02 	mov    BYTE PTR ds:0x0,0x2
			}
		
		break;
  dd:	eb 56                	jmp    135 <irq_sci+0x102>
		
//**************DATA State*********************//

		case S_DATA:
		
			if(rxdata==ETX)
  df:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  e6:	3c 03                	cmp    al,0x3
  e8:	75 26                	jne    110 <irq_sci+0xdd>
			{
				
			
			
			printf("SCI FSM: End Of message\n");
  ea:	c7 04 24 1c 00 00 00 	mov    DWORD PTR [esp],0x1c
  f1:	e8 fc ff ff ff       	call   f2 <irq_sci+0xbf>
			
				result=PushQueue(0x00);
  f6:	c7 04 24 00 00 00 00 	mov    DWORD PTR [esp],0x0
  fd:	e8 fc ff ff ff       	call   fe <irq_sci+0xcb>
 102:	a2 00 00 00 00       	mov    ds:0x0,al
				Sci_State=S_ILDE;
 107:	c6 05 00 00 00 00 00 	mov    BYTE PTR ds:0x0,0x0
				result=PushQueue(rxdata);
				
			}
				
	
			break;
 10e:	eb 25                	jmp    135 <irq_sci+0x102>
				
			}
			else 
			{
				
				result=PushQueue(rxdata);
 110:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 117:	0f b6 c0             	movzx  eax,al
 11a:	89 04 24             	mov    DWORD PTR [esp],eax
 11d:	e8 fc ff ff ff       	call   11e <irq_sci+0xeb>
 122:	a2 00 00 00 00       	mov    ds:0x0,al
				
			}
				
	
			break;
 127:	eb 0c                	jmp    135 <irq_sci+0x102>
	
		default:
	
		printf("SCI FSM: Unexpected Event\n ");
 129:	c7 04 24 34 00 00 00 	mov    DWORD PTR [esp],0x34
 130:	e8 fc ff ff ff       	call   131 <irq_sci+0xfe>
	
	
	}  // end  of Switch

}
 135:	c9                   	leave  
 136:	c3                   	ret    

00000137 <testbench_1>:



void testbench_1(void)
{
 137:	55                   	push   ebp
 138:	89 e5                	mov    ebp,esp
 13a:	83 ec 18             	sub    esp,0x18
unsigned char data;

	QueueInit();	// initialize queue
 13d:	e8 fc ff ff ff       	call   13e <testbench_1+0x7>

	while(ptestdata=testdata[i++])
 142:	eb 28                	jmp    16c <testbench_1+0x35>
	{
	
		while(rxdata=*ptestdata++)
 144:	eb 05                	jmp    14b <testbench_1+0x14>
			
			irq_sci();
 146:	e8 fc ff ff ff       	call   147 <testbench_1+0x10>
	QueueInit();	// initialize queue

	while(ptestdata=testdata[i++])
	{
	
		while(rxdata=*ptestdata++)
 14b:	a1 00 00 00 00       	mov    eax,ds:0x0
 150:	8d 50 01             	lea    edx,[eax+0x1]
 153:	89 15 00 00 00 00    	mov    DWORD PTR ds:0x0,edx
 159:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 15c:	a2 00 00 00 00       	mov    ds:0x0,al
 161:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 168:	84 c0                	test   al,al
 16a:	75 da                	jne    146 <testbench_1+0xf>
{
unsigned char data;

	QueueInit();	// initialize queue

	while(ptestdata=testdata[i++])
 16c:	a1 00 00 00 00       	mov    eax,ds:0x0
 171:	8d 50 01             	lea    edx,[eax+0x1]
 174:	89 15 00 00 00 00    	mov    DWORD PTR ds:0x0,edx
 17a:	8b 04 85 00 00 00 00 	mov    eax,DWORD PTR [eax*4+0x0]
 181:	a3 00 00 00 00       	mov    ds:0x0,eax
 186:	a1 00 00 00 00       	mov    eax,ds:0x0
 18b:	85 c0                	test   eax,eax
 18d:	75 b5                	jne    144 <testbench_1+0xd>
	}
	
	putchar('\n');

	
}
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <testbench_2>:

void testbench_2(void)
{
 191:	55                   	push   ebp
 192:	89 e5                	mov    ebp,esp
 194:	83 ec 28             	sub    esp,0x28
   char ch;
   FILE *fp;
 
   
 
   fp = fopen("/dev/rfcomm0","r+"); // rw mode
 197:	c7 44 24 04 50 00 00 	mov    DWORD PTR [esp+0x4],0x50
 19e:	00 
 19f:	c7 04 24 53 00 00 00 	mov    DWORD PTR [esp],0x53
 1a6:	e8 fc ff ff ff       	call   1a7 <testbench_2+0x16>
 1ab:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
 
   if( fp == NULL )
 1ae:	83 7d f4 00          	cmp    DWORD PTR [ebp-0xc],0x0
 1b2:	75 18                	jne    1cc <testbench_2+0x3b>
   {
      perror("Error while opening the file.\n");
 1b4:	c7 04 24 60 00 00 00 	mov    DWORD PTR [esp],0x60
 1bb:	e8 fc ff ff ff       	call   1bc <testbench_2+0x2b>
      exit(EXIT_FAILURE);
 1c0:	c7 04 24 01 00 00 00 	mov    DWORD PTR [esp],0x1
 1c7:	e8 fc ff ff ff       	call   1c8 <testbench_2+0x37>
   }
 
   fputs("Hello Droid",fp);
 1cc:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
 1cf:	89 44 24 0c          	mov    DWORD PTR [esp+0xc],eax
 1d3:	c7 44 24 08 0b 00 00 	mov    DWORD PTR [esp+0x8],0xb
 1da:	00 
 1db:	c7 44 24 04 01 00 00 	mov    DWORD PTR [esp+0x4],0x1
 1e2:	00 
 1e3:	c7 04 24 7f 00 00 00 	mov    DWORD PTR [esp],0x7f
 1ea:	e8 fc ff ff ff       	call   1eb <testbench_2+0x5a>
 
   while( ( ch = fgetc(fp) ) != EOF )
 1ef:	eb 0c                	jmp    1fd <testbench_2+0x6c>
      printf("%c",ch);
 1f1:	0f be 45 f3          	movsx  eax,BYTE PTR [ebp-0xd]
 1f5:	89 04 24             	mov    DWORD PTR [esp],eax
 1f8:	e8 fc ff ff ff       	call   1f9 <testbench_2+0x68>
      exit(EXIT_FAILURE);
   }
 
   fputs("Hello Droid",fp);
 
   while( ( ch = fgetc(fp) ) != EOF )
 1fd:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
 200:	89 04 24             	mov    DWORD PTR [esp],eax
 203:	e8 fc ff ff ff       	call   204 <testbench_2+0x73>
 208:	88 45 f3             	mov    BYTE PTR [ebp-0xd],al
 20b:	80 7d f3 ff          	cmp    BYTE PTR [ebp-0xd],0xff
 20f:	75 e0                	jne    1f1 <testbench_2+0x60>
      printf("%c",ch);
 
   fclose(fp);
 211:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
 214:	89 04 24             	mov    DWORD PTR [esp],eax
 217:	e8 fc ff ff ff       	call   218 <testbench_2+0x87>
  // return 0;
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <command_parser>:



	
unsigned int command_parser(CMD_STR *p2cmd)
{
 21e:	55                   	push   ebp
 21f:	89 e5                	mov    ebp,esp
 221:	83 ec 28             	sub    esp,0x28
	
	unsigned char cmd;
	
	if(QueueStatus())
 224:	e8 fc ff ff ff       	call   225 <command_parser+0x7>
 229:	85 c0                	test   eax,eax
 22b:	74 3d                	je     26a <command_parser+0x4c>
	{
		result=PullQueue(&cmd);
 22d:	8d 45 f7             	lea    eax,[ebp-0x9]
 230:	89 04 24             	mov    DWORD PTR [esp],eax
 233:	e8 fc ff ff ff       	call   234 <command_parser+0x16>
 238:	a2 00 00 00 00       	mov    ds:0x0,al
		while (p2cmd->command!= END_OF_LIST && p2cmd->command!=cmd)
 23d:	eb 04                	jmp    243 <command_parser+0x25>
				p2cmd++;
 23f:	83 45 08 08          	add    DWORD PTR [ebp+0x8],0x8
	unsigned char cmd;
	
	if(QueueStatus())
	{
		result=PullQueue(&cmd);
		while (p2cmd->command!= END_OF_LIST && p2cmd->command!=cmd)
 243:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 246:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 249:	3c ff                	cmp    al,0xff
 24b:	74 0e                	je     25b <command_parser+0x3d>
 24d:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 250:	0f b6 10             	movzx  edx,BYTE PTR [eax]
 253:	0f b6 45 f7          	movzx  eax,BYTE PTR [ebp-0x9]
 257:	38 c2                	cmp    dl,al
 259:	75 e4                	jne    23f <command_parser+0x21>
				p2cmd++;
	
		(p2cmd->exec)();
 25b:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 25e:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
 261:	ff d0                	call   eax
		return(0);
 263:	b8 00 00 00 00       	mov    eax,0x0
 268:	eb 05                	jmp    26f <command_parser+0x51>
	}
	
	return(-1);	// Error quwue is empty
 26a:	b8 ff ff ff ff       	mov    eax,0xffffffff
	
}
 26f:	c9                   	leave  
 270:	c3                   	ret    

00000271 <Cmd_Set_Text>:




void Cmd_Set_Text(void)
{
 271:	55                   	push   ebp
 272:	89 e5                	mov    ebp,esp
 274:	83 ec 28             	sub    esp,0x28
#define MAX_TEXT_LEN 10
// testBuf[MAX_TEXT_LEN];
unsigned char data;


    printf("Set text Cmd :");
 277:	c7 04 24 8b 00 00 00 	mov    DWORD PTR [esp],0x8b
 27e:	e8 fc ff ff ff       	call   27f <Cmd_Set_Text+0xe>
	do
	{
		if (QueueStatus())		// some news?
 283:	e8 fc ff ff ff       	call   284 <Cmd_Set_Text+0x13>
 288:	85 c0                	test   eax,eax
 28a:	74 27                	je     2b3 <Cmd_Set_Text+0x42>
			result=PullQueue(&data);
 28c:	8d 45 f7             	lea    eax,[ebp-0x9]
 28f:	89 04 24             	mov    DWORD PTR [esp],eax
 292:	e8 fc ff ff ff       	call   293 <Cmd_Set_Text+0x22>
 297:	a2 00 00 00 00       	mov    ds:0x0,al
		else
		
		return;
						
	    printf("%c",data);
 29c:	0f b6 45 f7          	movzx  eax,BYTE PTR [ebp-0x9]
 2a0:	0f b6 c0             	movzx  eax,al
 2a3:	89 04 24             	mov    DWORD PTR [esp],eax
 2a6:	e8 fc ff ff ff       	call   2a7 <Cmd_Set_Text+0x36>
	    
	} while (data);
 2ab:	0f b6 45 f7          	movzx  eax,BYTE PTR [ebp-0x9]
 2af:	84 c0                	test   al,al
 2b1:	75 d0                	jne    283 <Cmd_Set_Text+0x12>
	
	
}
 2b3:	c9                   	leave  
 2b4:	c3                   	ret    

000002b5 <Unknown_Cmd>:

void Unknown_Cmd(void)

{
 2b5:	55                   	push   ebp
 2b6:	89 e5                	mov    ebp,esp
 2b8:	83 ec 18             	sub    esp,0x18

	printf("Unknown Cmd ");
 2bb:	c7 04 24 9a 00 00 00 	mov    DWORD PTR [esp],0x9a
 2c2:	e8 fc ff ff ff       	call   2c3 <Unknown_Cmd+0xe>
	
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <Cmd_No_more_msj>:


void Cmd_No_more_msj(void)

{
 2c9:	55                   	push   ebp
 2ca:	89 e5                	mov    ebp,esp
 2cc:	83 ec 18             	sub    esp,0x18

	printf("End of messages ");
 2cf:	c7 04 24 a7 00 00 00 	mov    DWORD PTR [esp],0xa7
 2d6:	e8 fc ff ff ff       	call   2d7 <Cmd_No_more_msj+0xe>
	
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    
