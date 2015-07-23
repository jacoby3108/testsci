#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// http://www.ascii-codes.com/

#define ENQ 0x05
#define ACK 0x06
#define STX 0x02
#define ETX 0x03
#define XON 0x11
#define XOFF 0x13
#define EOT 0x04

#define C_Black   "0"
#define C_Blue    "1"
#define C_Green   "2"
#define C_Cyan    "3"
#define C_Red     "4"
#define C_Magenta "5"
#define C_Yellow  "6"
#define C_White   "7"

void SendTextFrame(unsigned char *pmsg);
void SendColorFrame(unsigned char *pmsg);
void EndOfTransmision(void);
void WaitAck(void);

//notes
//http://stackoverflow.com/questions/1289881/using-gcc-to-produce-readable-assembly
//gcc -O2 -S -c foo.c
// or
// > gcc -g -c test.c
// > objdump -d -M intel -S test.o



//========= testbench variables ============/


// Test messages

unsigned char pEOT[]={STX,ETX,EOT};
unsigned char msg0[]={"HAGAN LIO"};
unsigned char msg1[]={"LUNES MARTES MIERCOLES JUEVES VIERNES SABADO DOMINGO LUNES MARTES MIERCOLES JUEVES VIERNES SABADO DOMINGO LUNES MARTES MIERCOLES JUEVES VIERNES SABADO DOMINGO  "};



// Test Variables
 

		

int i=0;

unsigned char rxdata;
unsigned char msg2bt[300];

char ch;
FILE *fp;


 
int main(int number_of_args, char* list_of_args[])
{
   
   if (number_of_args==2)
   {
   
      printf("Arg Rec: %s\n",list_of_args[1]);
     
     
    }
	else 
	
		printf("No Arguments Default message \n");
	
	
 
   fp = fopen("/dev/rfcomm0","r+"); // rw mode
 
   if( fp == NULL )
   {
      perror("Error while opening the file.\n");
      exit(EXIT_FAILURE);
   }
   
	//fseek(fp,0,SEEK_END);

/////////////// XON Sync ////////////////

		i=2;   //  wait 1 xon
		while( ( ch = fgetc(fp) ) != EOF && i--)
		{
     
			printf(">> (%c)[%.2X]-",ch,ch);
				
			
		}
		
		
		
		
    if (number_of_args==2)
        SendTextFrame(list_of_args[1]);
	else		
		SendTextFrame(msg1);  
	
		SendColorFrame(C_Red);
	
		EndOfTransmision();

			
		printf("\n");
		fclose(fp);
		return 0;
		
	
   
}



void SendTextFrame(unsigned char *pmsg)
  {
	  int i=0;
	  
	  msg2bt[i++]=STX;
	  
	  msg2bt[i++]='T';
	  
	  while (*pmsg)
	   
	   msg2bt[i++]=*pmsg++;
	   
	  
	   msg2bt[i++]=ETX;
	  
	  msg2bt[i++]=EOT;
	  
	  i=0;
	  
	   printf("\nSend Text: ");
	  while((rxdata=msg2bt[i++])!=EOT)
			{
				fputc(rxdata,fp);
				 printf(" (%c)[%.2X]",rxdata,rxdata);
			}
		
	 
      WaitAck();

	  
  }

void SendColorFrame(unsigned char *pmsg)
  {
	  int i=0;
	  
	  msg2bt[i++]=STX;
	  
	  msg2bt[i++]='C';
	  
	  while (*pmsg)
	   
	  msg2bt[i++]=*pmsg++;
	   
	  
	  msg2bt[i++]=ETX;
	  
	  msg2bt[i++]=EOT;
	  
	  i=0;
	  
	  printf("\nSend Color: ");
	  while((rxdata=msg2bt[i++])!=EOT)
			{
				fputc(rxdata,fp);
				 printf(" (%c)[%.2X]",rxdata,rxdata);
			}
		
	
      WaitAck();
 
  }

 void WaitAck(void)
{
	char ch;
	while( ( ch = fgetc(fp) ) != ACK )
	{
     
			
			i--;
			
			
	}
		
	printf("\n >> ACK << \n");
				

} 
 
void EndOfTransmision(void)
{
			i=0;
			printf("\nEnd of Trasmition");	
		
			while((rxdata=pEOT[i++])!=EOT)
			{
				fputc(rxdata,fp);
//				printf(" (%c)[%.2X]",rxdata,rxdata);
			}
			

		

			WaitAck();			
			
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
 
