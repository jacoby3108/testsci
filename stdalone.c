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

typedef struct 
{
unsigned char *color;
unsigned char *colorname;	
}color_T;

color_T colors[]= {
	
	{C_Black,"Black"},  
	{C_Blue, "Blue"},  
	{C_Green,"Green"},  
	{C_Cyan,"Cyan"},  
	{C_Red,"Red"},   
	{C_Magenta,"Magenta"},
	{C_Yellow,"Yellow"},
	{C_White,"White"}
		
	};

void SendTextFrame(unsigned char *pmsg);
void SendColorFrame(unsigned char *pmsg);
void EndOfTransmision(void);
void WaitAck(void);
void input_data(void);
void open_serial_channel(void);

//notes
//http://stackoverflow.com/questions/1289881/using-gcc-to-produce-readable-assembly
//gcc -O2 -S -c foo.c
// or
// > gcc -g -c test.c
// > objdump -d -M intel -S test.o



//========= testbench variables ============/


// Test messages

unsigned char pEOT[]={STX,ETX,EOT};
unsigned char default_msg[]={"HAGAN LIO"};
unsigned char default_col[1]=C_White;
char mystring [200];
char mycolor  [10];


unsigned char msg1[]={"LUNES MARTES MIERCOLES JUEVES VIERNES SABADO DOMINGO LUNES MARTES MIERCOLES JUEVES VIERNES SABADO DOMINGO LUNES MARTES MIERCOLES JUEVES VIERNES SABADO DOMINGO  "};



// Test Variables
 

		

int i=0;

unsigned char rxdata;
unsigned char msg2bt[300];

char ch;
FILE *fp;

 
int main(int number_of_args, char* list_of_args[])
{
    while (1){
		 
     strcpy(mystring,default_msg);
     strcpy(mycolor,default_col);

	open_serial_channel();
	input_data();

	
	
	printf("New Message:%s \n",mystring);
	printf("New Color:%s \n\n\n",(colors[(mycolor[0]-'0')].colorname));
	
 
  

/////////////// XON Sync ////////////////

		i=1;   //  wait 1 xon

	if( fp != NULL )
	{
		while( ( ch = fgetc(fp) ) != EOF && i--)
		{
     
			printf(">> (%c)[%.2X]-",ch,ch);
				
			
		}
	}
	else
	{
			printf("ERROR Trying to write a closed channel while sync XON \n\n");
			exit(EXIT_FAILURE);
	}	
		
/////////////// XON Sync ////////////////

			
		SendTextFrame(mystring);  
	
		SendColorFrame(mycolor); 
	
		EndOfTransmision();

}			
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
//				 printf(" (%c)[%.2X]",rxdata,rxdata);
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
//				 printf(" (%c)[%.2X]",rxdata,rxdata);
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


	
void input_data(void)	
{
	//if ( fgets (mystring , 200 , stdin) != NULL )
    //puts (mystring);
	
	printf("Enter a string or press enter (Default message used):\n");
	
	fgets (mystring , 200 , stdin);
	
	if (*mystring=='\n')
	{
		
		strcpy(mystring,default_msg);
	//	printf("Empty String Default message used: (%s)  \n",mystring );
	}
	else
	{
	
		
		mystring[strlen(mystring)-1]=0;		//patch gets() LF with null
	//	printf("New Message:%s \n",mystring);
	}
	
	
	
	
	
	printf("Enter a color or press enter (Default color used):\n\n");
	
	for(i=0;i < sizeof(colors)/sizeof(colors[0]);i++)
	printf("%s)  Color: %s\n", colors[(i)].color,colors[(i)].colorname);
	
	
	fgets (mycolor , 200,stdin);
	
	if (*mycolor=='\n')
	{
		
		strcpy(mycolor,default_col);
		//printf("Empty String Default color used (%s) \n",(colors[(mycolor[0]-'0')].colorname));
		
	}
	else
	{
	
		if( mycolor[0] >='0' &&  mycolor[0] <='7')
		{
			//printf("New Color:%s \n\n\n",(colors[(mycolor[0]-'0')].colorname));
			mycolor[strlen(mycolor)-1]=0;		//patch gets() LF with null
			
		}
		else 
		{
			//printf("Wrong Color choosed Default color used %s \n",mycolor);
			
		}
	}
	   
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
 
void open_serial_channel(void)
{  
     
		fp = fopen("/dev/rfcomm0","r+"); // rw mode
 
		if( fp == NULL )
		{
			perror("Error while opening serial channel.\n");
			exit(EXIT_FAILURE);
		}
 
}  
