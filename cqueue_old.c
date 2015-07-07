/* Circular Queue */



#include "cqueue.h"
	


static unsigned char buffer[QSIZE];  // storage for circuar queue (static)
static unsigned int  news;	    	 // How many "news" are remaining in Queue
static unsigned char *pin,*pout;     // input and output pointers 	





/*
 Initialize queue 
*/
void QueueInit(void)

{

	pin=buffer;	//set up pin,pout and "news" counter 	
	pout=buffer;
	news=0;

}

/*
  Push data on queue 
*/
unsigned char PushQueue(unsigned char data)

{
	
	if (news > QSIZE-1)		//test for Queue overflow
	{
				
		return (QFULL);		// Queue capacity has reached
	}	

	*pin++=data;			// pull data
	news++;					// update "news" counter

	if (pin == buffer+QSIZE)	// if queue size is exceded reset pointer
		pin=buffer;

	return(QOK);			// inform Queue state
}

/*
 * PullQueue()
 * 
  Retrieve data from queue 
  Dont forget to call QueueStatus()
  before call this function
  *
  * 
  * Sample code
  *  
  * while (QueueStatus())		// some news?
	{
		data=PullQueue(); 	// if yes then get data from queue
		
	}

  * 
  * 
  * 
  * 
*/
unsigned char PullQueue(void)

{
unsigned char data;

	if (news == 0)		// Just in case 
	  return 0xFF;		// Error queue is empty 

	data=*pout++;		// pull data
	news--;				// update "news" counter

	if (pout == buffer+QSIZE)	// Check for Queue boundaries
		pout=buffer;		// if queue size is exceded reset pointer
	return (data);			// rerturn retrieved data
}

/*
  Get queue Status
  Queue is empty when null is returned
*/
unsigned int QueueStatus(void)

{
	
	return (news);			// Retrieve "news" counter		
}



