/* Battery threshold */



#include "stdio.h"
	



static unsigned int bat_level=900;     // Battery Level 	
static unsigned char bat_status=0;     // Battery Status 

#define	NORMAL 	 '0'
#define	MEDIUM 	 '1'
#define	LOW	   	 '2'
#define	CRITICAL '3'

#define	NORMAL_LEVEL 	900
#define	MEDIUM_LEVEL 	700
#define	LOW_LEVEL	   	500 
#define	CRITICAL_LEVEL  300 

// Vanalog=Vbat*K  		K=Resistor Divider  
// VFS =Vbat(max)*K  	K=Resistor Divider  


// Vanalog= VFS*(Vadc/1024) 
// Vanalog(max)= VFS*(1023)/(1024)
// Vanalog(min)=0

// i.e  Vanalog=Vbat(max)*K  K=Resistor Divider 


// Info Baterias

// Vmax 8.4V
// Vnom 7.2V
// Vcri 6.0V

// Measure

float Vnorm = 8.0;
float Vmed =  7.5;
float Vlow =  6.5;
float Vcrit = 6.1;
float K=0.5;		// Resistor Divider



unsigned char Batt_Status(unsigned int bat_level );
void Analog_Dig(void);

void main(void)

{
	bat_level=0;
	
	while (bat_level <= 1023)
	{
		bat_level+=100;				// Ramp up
		printf("Batt Level= %d ,Battery_status: %c\n",bat_level,Batt_Status(bat_level));
	}
	
	
	 Analog_Dig();  // Calc. ADC levels 
	
}



unsigned char Batt_Status(unsigned int bat_level )
{
	
	if(bat_level >=NORMAL_LEVEL)
	
		bat_status=NORMAL;
	
	if(bat_level < NORMAL_LEVEL && bat_level >= MEDIUM_LEVEL)	
	
		bat_status=MEDIUM;
	
	if(bat_level < MEDIUM_LEVEL && bat_level >= CRITICAL_LEVEL)	
	
		bat_status=LOW;
		
		
	if(bat_level < CRITICAL_LEVEL)	
	
		bat_status=CRITICAL;
		
	return (bat_status);
	
}


void Analog_Dig(void)

{
	
	
	float Vin;
	float VFS = 5.0;
	
	Vin=Vnorm*K;    // Vin=Vbat*K  K=Resistor Divider 
		
	printf("\nNORMAL_LEVEL:%f\n\n",(Vin/VFS)*1024);	// Vadc= (Vin/VFS)*1024 
	
	
	Vin=Vmed*K;    // Vin=Vbat*K  K=Resistor Divider 
		
	printf("\nMEDIUM_LEVEL:%f\n\n",(Vin/VFS)*1024);	// Vadc= (Vin/VFS)*1024 
	  
	
	
}
