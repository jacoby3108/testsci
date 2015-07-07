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


//========= testbench variables ============/



// Test Variables
 

int i=0;		
FILE *fp;		

void irq_sci(void);
void sendsci(unsigned char tx);
void testbench_2(void);



//=== App variables =========//

unsigned char Sci_State;
unsigned char rxdata;
unsigned char op_status;
unsigned char msg=0;
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
					
					 {'T',Cmd_Set_Text},	//text
					 {'C',Cmd_Set_Text},	//color
					 {'S',Cmd_Set_Text},	//speed
					 {'S',Cmd_Set_Text},
					 
					 {EOT,Cmd_No_more_msj},
					 
					 {END_OF_LIST,Unknown_Cmd},
					 
					};
					 
				 



void main (void)	// SCI FSM Test bench
{
	
	testbench_2();				//android


}
	
	





void testbench_2(void)
{
   unsigned char ch;
   
 
   QueueInit();	// initialize queue
   
   fp = fopen("/dev/ttyUSB0","r+"); // rw mode     //  USB HC05 Blue
 
   if( fp == NULL )
   {
      perror("Error while opening Blue HC05 USB.\n");
      exit(EXIT_FAILURE);
   }
   
   
     fputc(XON,fp);     // ojo NOOOOOOOOOOOOOOOOOO olvidar XON
    
    //fputs(" ",fp);
 
   while( ( ch = fgetc(fp) ) != EOF )
	{
		
      printf("-(%c)[%.2X]-",ch,ch);
    
      rxdata=ch;
 
      irq_sci();
 
      if (msg)						// is a messsage available ?
      {	
		  msg--; 	
 		  command_parser(commands);	// Process the cmd
	
	  }
    } 
 
   fclose(fp);
 
}


 
 
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
				msg++;
				sendsci(ACK);
				op_status=PushQueue(EOT);
				Sci_State=S_ILDE;
				
			}
			else 
			{
				
				op_status=PushQueue(rxdata);
				Sci_State=S_DATA;
			}
		
		break;
		
//**************DATA State*********************//

		case S_DATA:
		
			if(rxdata==ETX)
			{
				
			
				
				printf("SCI FSM: End Of message\n");
				msg++;
				sendsci(ACK);
				op_status=PushQueue(0x00);
				Sci_State=S_ILDE;
				
			}
			else 
			{
				
				op_status=PushQueue(rxdata);
				
			}
				
	
			break;
	
		default:
	
		printf("SCI FSM: Unexpected Event\n ");
	
	
	}  // end  of Switch

} //end of irq


void sendsci(unsigned char tx)
{
	
	
	if (tx==ACK)
	printf("--> [ACK]\n");
	else
	printf("--> [%.2X]\n",tx);
	
	fputc(tx,fp);
	
}

/* ------------- Comand Parser ------------------ */
	
unsigned int command_parser(CMD_STR *p2cmd)
{
	
	unsigned char cmd;
	
	if(QueueStatus())
	{
		op_status=PullQueue(&cmd);
		while (p2cmd->command!= END_OF_LIST && p2cmd->command!=cmd)
				p2cmd++;
	
		(p2cmd->exec)();
		return(0);
	}
	
	return(-1);	// Error queue is empty
	
}




void Cmd_Set_Text(void)
{
#define MAX_TEXT_LEN 10
// testBuf[MAX_TEXT_LEN];
unsigned char data;


    printf("Set text Cmd :");
	do
	{
		if (QueueStatus())				// some news?
			op_status=PullQueue(&data);
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

	printf("End of Tranmision\n");
	
}

