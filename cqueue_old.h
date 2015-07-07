#ifndef CQUEUE_H
#define CQUEUE_H

#define QSIZE  200	// Queue size 


void QueueInit(void);
unsigned char PushQueue(unsigned char data);
unsigned char PullQueue(void);
unsigned int QueueStatus(void);


#define QFULL  1		// Queue is full (no more data can be pushed)
#define QOK    0		// Queue Push was done succesfully 

#endif
