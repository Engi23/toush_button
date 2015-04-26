/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 19.03.2015
Author  : Engi
Company : 
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega328p.h>
#include <stdio.h>
#include <delay.h>
#include <string.h>
#define BYTE unsigned char
#define Noprosov 20

BYTE temp,data,NumB,datakey,rx_ok,N_tout;

unsigned int time,normal_time,N16,min_time;
unsigned int data16,adres16;
BYTE* data8 = (BYTE*)&data16;
BYTE buf[30];
bit flag,facsP,facsM;

//******************-=< Отправить байт >=-**********************
void tx(BYTE data) 
    {
    while (!((UCSR0A)&(0b00100000))) 
    {
    };
    UDR0=data;
    }
//******************-=< Отправить набор байт >=-**********************
void send(char *datam)
    {BYTE P,K;   
    K=strlen(datam);
    for (P=0;P<K;P++) 
        {
        tx(datam[P]);
        };
    }  
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
    {
    if (flag==0) 
        {data8[0]=TCNT1L;
        data8[1]=TCNT1H;
        time=data16;};
    flag=1;
    }

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
    {
    time=65535;
    flag=1;
    }


// Standard Input/Output functions
#include <stdio.h>

//******************-=< Функции >=-********************** 
//******************-=< Получить время >=-**********************   
unsigned int time_touch(void) 
    {
    TCNT1H=0x00;
    TCNT1L=0x00;
    flag=0;
    TCCR1B=0x02;
    TCNT1H=0x00;
    TCNT1L=0x00;
    DDRD=0b00001000;     // выходной пин на вывод   сенсорный пин на ввод
    PORTD.3=1;    // поехали
    while (flag==0) {};
    TCCR1B=0x00;
    DDRD.2=1;  // разрядить конденсатор
    PORTD.3=0;    // выходной пин на ноль
    return time;
    }



void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0b00000000;
DDRD=0b00001000;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 16000,000 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x01;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=0x00;
TCCR2A=0x00;
TCCR2B=0x00;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Rising Edge
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=0x03;
EIMSK=0x01;
EIFR=0x01;
PCICR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x00;

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x01;

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART0 Mode: Asynchronous
// USART Baud Rate: 9600
UCSR0A=0x00;
UCSR0B=0x08;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x67;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
ADCSRB=0x00;
DIDR1=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
#asm("sei")
N16=350;
min_time=0xFFFF;
normal_time=time_touch();
normal_time=normal_time*21/20;
delay_ms(200);
DDRB.5=1;
while (1)
    {
    data16=time_touch();
    delay_ms(1000/Noprosov);           // 20 раз в секунду
    tx(data8[1]);
    tx(data8[0]);
    if (data16>normal_time)
        {
        // кнопка нажата
        if (N_tout==0)           // если первое нажатие
            {
            if (PORTB.5==1) {PORTB.5=0;}
            else  {PORTB.5=1;}
            };
        N_tout=Noprosov;        // таймаут секунду
        }
    else
        {
        if (N_tout!=0) {N_tout--;};
        }
    N16++;
    if (min_time>data16) 
        {min_time=data16;
        };

    if (N16>400) 
        {normal_time=min_time+25;
        min_time=0xFFFF;
        N16=0;
        };
   
    }
}
