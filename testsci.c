#include <stdio.h>
#include <stdlib.h>
#include "cqueue.h"


// http://www.ascii-codes.com/

#define ENQ 0x05
#define ACK 0x06
#define STX 0x02
#define ETX 0x03
#define XON 0x11
#define XOFF 0x13
#define EOT 0x04

//notes
//http://stackoverflow.com/questions/1289881/using-gcc-to-produce-readable-assembly
//gcc -O2 -S -c foo.c
// or
// > gcc -g -c test.c
// > objdump -d -M intel -S test.o



//========= testbench variables ============/


// Test messages
unsigned char pENQ[]={ENQ,0};
unsigned char pSTX[]={STX,0};    // any message is null terminated 
unsigned char pETX[]={ETX,0};
unsigned char pmsg0[]={"T234"}; 
unsigned char pmsg1[]={"T6789"}; 

// Test Variables
 
unsigned char *testdata[]= {
	
		pENQ,
		pSTX,pmsg0,pETX,
		pSTX,pmsg1,pETX,
		pSTX,pETX,
		(unsigned char *)NULL};
		
		
FILE *fp;		
unsigned char *ptestdata=NULL;
int i=0;

void irq_sci(void);
void sendsci(unsigned char tx);
void testbench_1(void);
void testbench_2(void);



//=== App variables =========//

unsigned char Sci_State;
unsigned char rxdata;
unsigned char result;

enum states {S_ILDE,S_STX,S_DATA};



//===========CMD Parser================================//

typedef struct

{
	unsigned char command;
	void (* exec)(void);

	
	
} CMD_STR;

unsigned int command_parser(CMD_STR *p2cmd);	
void Cmd_Set_Text(void);	
void Cmd_No_more_msj(void);	
void Unknown_Cmd(void);		  


#define END_OF_LIST 0xFF

CMD_STR commands[]= { 
					
					 {'T',Cmd_Set_Text},
					 {'T',Cmd_Set_Text},
					 {'T',Cmd_Set_Text},
					 {EOT,Cmd_No_more_msj},
					 
					 {END_OF_LIST,Unknown_Cmd},
					 
					};
					 
				 



void main (void)	// SCI FSM Test bench
{
	
	testbench_2();				//android
	
/*	
	testbench_1();				//simulates reception of data

	while (QueueStatus())
	{
		command_parser(commands);
	
		printf("\n");
	}
*/	
	
}
	
	


void sendsci(unsigned char tx)
{
	
	
	if (tx==ACK)
	printf("--> [ACK]\n");
	else
	printf("--> [%.2X]\n",tx);
	
	fputc(tx,fp);
	
}




void testbench_1(void)
{
unsigned char data;

	QueueInit();	// initialize queue

	while(ptestdata=testdata[i++])		// This loop selects next message until no more messages are available 
	{
	
		while(rxdata=*ptestdata++)      // Send message to sci (Null terminated messages)
			
			irq_sci();
	
	}
	
	
	
	return;    // dont pull any more
	
	
	
	while (QueueStatus())		// some news?
	{
		result=PullQueue(&data); 	// if yes then get data from queue
		if(data)
			printf( "[%.2X] ",data);
		else
			printf( "[%.2X] \n",data);
		
		//printf( "Data pulled: %.2X , Remaining: %d   \n",data,QueueStatus());
	}
	
	putchar('\n');

	
}

void testbench_2(void)
{
   unsigned char ch;
   
 
   QueueInit();	// initialize queue
 
   //fp = fopen("/dev/rfcomm0","r+"); // rw mode	// laptop blue
   fp = fopen("/dev/ttyUSB0","r+"); // rw mode     //  USB HC05 Blue
 
   if( fp == NULL )
   {
      perror("Error while opening Blue.\n");
      exit(EXIT_FAILURE);
   }
   
   
    fputc(XON,fp);// ojo NOOOOOOOOOOOOOOOOOO olvidar XON
    //fputs(" ",fp);
 
   while( ( ch = fgetc(fp) ) != EOF )
	{
		
      printf("-(%c)[%.2X]-",ch,ch);
      rxdata=ch;
      irq_sci();
      
      
    } 
 
   fclose(fp);
  // return 0;
}

/*
 * Pairing ubuntu and android (Miracle)

sdptool add --channel=3 SP

sudo rfcomm listen /dev/rfcomm0 3

Go  to android phone open a serial terminal (example sena BTerm) and
connect to Ubuntu (note must be a secure conection Eg.: in BTerm uncheck Allow insecure connection ) 
On linux open a serial terminal on Ubuntu on /dev/rfcomm0 (E.g.: Serial port terminal)

or 
cat  /dev/rfcomm0  to recieve

echo "hello" > /dev/rfcomm0 to send


sudo rfcomm release rfcomm0       kill

 * 
 * 
 * */
 
 
// ***********************I*R*Q***S*C*I**********************************//

void irq_sci(void)	
{	
	switch (Sci_State)		// Tiny FSM for SCI reception
	{
	
	//**************ILDE State*********************//
		case S_ILDE:		
		
			if(rxdata==ENQ)
				sendsci(ACK);
			else if(rxdata==STX)
				Sci_State=S_STX;	
		break;
	
		
	//**************STX State*********************//
		case S_STX:
	
			if(rxdata==ETX)
			{
							
				printf("SCI FSM: End Of Transmision\n");
				sendsci(ACK);
				result=PushQueue(EOT);
				Sci_State=S_ILDE;
				
			}
			else 
			{
				
				result=PushQueue(rxdata);
				Sci_State=S_DATA;
			}
		
		break;
		
//**************DATA State*********************//

		case S_DATA:
		
			if(rxdata==ETX)
			{
				
			
				
				printf("SCI FSM: End Of message\n");
				sendsci(ACK);
				result=PushQueue(0x00);
				Sci_State=S_ILDE;
				
			}
			else 
			{
				
				result=PushQueue(rxdata);
				
			}
				
	
			break;
	
		default:
	
		printf("SCI FSM: Unexpected Event\n ");
	
	
	}  // end  of Switch

} //end of irq




/* ------------- Comand Parser ------------------ */
	
unsigned int command_parser(CMD_STR *p2cmd)
{
	
	unsigned char cmd;
	
	if(QueueStatus())
	{
		result=PullQueue(&cmd);
		while (p2cmd->command!= END_OF_LIST && p2cmd->command!=cmd)
				p2cmd++;
	
		(p2cmd->exec)();
		return(0);
	}
	
	return(-1);	// Error quwue is empty
	
}




void Cmd_Set_Text(void)
{
#define MAX_TEXT_LEN 10
// testBuf[MAX_TEXT_LEN];
unsigned char data;


    printf("Set text Cmd :");
	do
	{
		if (QueueStatus())		// some news?
			result=PullQueue(&data);
		else
		
		return;
						
	    printf("%c",data);
	    
	} while (data);
	
	
}

void Unknown_Cmd(void)

{

	printf("Unknown Cmd ");
	
}


void Cmd_No_more_msj(void)

{

	printf("End of messages ");
	
}

