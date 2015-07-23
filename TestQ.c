#include <stdio.h>
#include "cqueue.h"
int i=0;

unsigned char mess[]={"Some Text"};
unsigned char op_sts,data; 
int main(int number_of_args, char* list_of_args[])
{
	QueueInit();
	
	printf("\n");

	while(mess[i]){
	
		op_sts=PushQueue(mess[i++]);
	
		if(op_sts!=QOK)
		
			break;
	}


	 while (QueueStatus())
	 {
		if((op_sts=PullQueue(&data)) == QEMPTY)
		{
		
		 printf("QEMPTY\n");	
		 break;
	    }
		
		printf("%c",data);
	 }

	printf("\n");

}
