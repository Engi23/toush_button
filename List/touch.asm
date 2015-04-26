
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega328P
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2303
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _temp=R4
	.DEF _data=R3
	.DEF _NumB=R6
	.DEF _datakey=R5
	.DEF _rx_ok=R8
	.DEF _N_tout=R7
	.DEF _time=R9
	.DEF _normal_time=R11
	.DEF _N16=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  LOW(_data16),HIGH(_data16)

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  _data8
	.DW  _0x3*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 19.03.2015
;Author  : Engi
;Company :
;Comments:
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <delay.h>
;#include <string.h>
;#define BYTE unsigned char
;#define Noprosov 20
;
;BYTE temp,data,NumB,datakey,rx_ok,N_tout;
;
;unsigned int time,normal_time,N16,min_time;
;unsigned int data16,adres16;
;BYTE* data8 = (BYTE*)&data16;

	.DSEG
;BYTE buf[30];
;bit flag,facsP,facsM;
;
;//******************-=< Отправить байт >=-**********************
;void tx(BYTE data)
; 0000 0029     {

	.CSEG
_tx:
; 0000 002A     while (!((UCSR0A)&(0b00100000)))
;	data -> Y+0
_0x4:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x4
; 0000 002B     {
; 0000 002C     };
; 0000 002D     UDR0=data;
	LD   R30,Y
	STS  198,R30
; 0000 002E     }
	ADIW R28,1
	RET
;//******************-=< Отправить набор байт >=-**********************
;void send(char *datam)
; 0000 0031     {BYTE P,K;
; 0000 0032     K=strlen(datam);
;	*datam -> Y+2
;	P -> R17
;	K -> R16
; 0000 0033     for (P=0;P<K;P++)
; 0000 0034         {
; 0000 0035         tx(datam[P]);
; 0000 0036         };
; 0000 0037     }
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 003A     {
_ext_int0_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 003B     if (flag==0)
	SBIC 0x1E,0
	RJMP _0xA
; 0000 003C         {data8[0]=TCNT1L;
	LDS  R30,132
	LDS  R26,_data8
	LDS  R27,_data8+1
	ST   X,R30
; 0000 003D         data8[1]=TCNT1H;
	LDS  R30,133
	__PUTB1PMNS _data8,1
; 0000 003E         time=data16;};
	__GETWRMN 9,10,0,_data16
_0xA:
; 0000 003F     flag=1;
	SBI  0x1E,0
; 0000 0040     }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0044     {
_timer1_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
; 0000 0045     time=65535;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	__PUTW1R 9,10
; 0000 0046     flag=1;
	SBI  0x1E,0
; 0000 0047     }
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;//******************-=< Функции >=-**********************
;//******************-=< Получить время >=-**********************
;unsigned int time_touch(void)
; 0000 0050     {
_time_touch:
; 0000 0051     TCNT1H=0x00;
	CALL SUBOPT_0x0
; 0000 0052     TCNT1L=0x00;
; 0000 0053     flag=0;
	CBI  0x1E,0
; 0000 0054     TCCR1B=0x02;
	LDI  R30,LOW(2)
	STS  129,R30
; 0000 0055     TCNT1H=0x00;
	CALL SUBOPT_0x0
; 0000 0056     TCNT1L=0x00;
; 0000 0057     DDRD=0b00001000;     // выходной пин на вывод   сенсорный пин на ввод
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 0058     PORTD.3=1;    // поехали
	SBI  0xB,3
; 0000 0059     while (flag==0) {};
_0x13:
	SBIS 0x1E,0
	RJMP _0x13
; 0000 005A     TCCR1B=0x00;
	LDI  R30,LOW(0)
	STS  129,R30
; 0000 005B     DDRD.2=1;  // разрядить конденсатор
	SBI  0xA,2
; 0000 005C     PORTD.3=0;    // выходной пин на ноль
	CBI  0xB,3
; 0000 005D     return time;
	__GETW1R 9,10
	RET
; 0000 005E     }
;
;
;
;void main(void)
; 0000 0063 {
_main:
; 0000 0064 // Declare your local variables here
; 0000 0065 
; 0000 0066 // Crystal Oscillator division factor: 1
; 0000 0067 #pragma optsize-
; 0000 0068 CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0069 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 006A #ifdef _OPTIMIZE_SIZE_
; 0000 006B #pragma optsize+
; 0000 006C #endif
; 0000 006D 
; 0000 006E // Input/Output Ports initialization
; 0000 006F // Port B initialization
; 0000 0070 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0071 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0072 PORTB=0x00;
	OUT  0x5,R30
; 0000 0073 DDRB=0x00;
	OUT  0x4,R30
; 0000 0074 
; 0000 0075 // Port C initialization
; 0000 0076 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0077 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0078 PORTC=0x00;
	OUT  0x8,R30
; 0000 0079 DDRC=0x00;
	OUT  0x7,R30
; 0000 007A 
; 0000 007B // Port D initialization
; 0000 007C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 007D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 007E PORTD=0b00000000;
	OUT  0xB,R30
; 0000 007F DDRD=0b00001000;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 0080 
; 0000 0081 // Timer/Counter 0 initialization
; 0000 0082 // Clock source: System Clock
; 0000 0083 // Clock value: 16000,000 kHz
; 0000 0084 // Mode: Normal top=0xFF
; 0000 0085 // OC0A output: Disconnected
; 0000 0086 // OC0B output: Disconnected
; 0000 0087 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0088 TCCR0B=0x01;
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 0089 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 008A OCR0A=0x00;
	OUT  0x27,R30
; 0000 008B OCR0B=0x00;
	OUT  0x28,R30
; 0000 008C 
; 0000 008D // Timer/Counter 1 initialization
; 0000 008E // Clock source: System Clock
; 0000 008F // Clock value: Timer1 Stopped
; 0000 0090 // Mode: Normal top=0xFFFF
; 0000 0091 // OC1A output: Discon.
; 0000 0092 // OC1B output: Discon.
; 0000 0093 // Noise Canceler: Off
; 0000 0094 // Input Capture on Falling Edge
; 0000 0095 // Timer1 Overflow Interrupt: Off
; 0000 0096 // Input Capture Interrupt: Off
; 0000 0097 // Compare A Match Interrupt: Off
; 0000 0098 // Compare B Match Interrupt: Off
; 0000 0099 TCCR1A=0x00;
	STS  128,R30
; 0000 009A TCCR1B=0x00;
	STS  129,R30
; 0000 009B TCNT1H=0x00;
	CALL SUBOPT_0x0
; 0000 009C TCNT1L=0x00;
; 0000 009D ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 009E ICR1L=0x00;
	STS  134,R30
; 0000 009F OCR1AH=0x00;
	STS  137,R30
; 0000 00A0 OCR1AL=0x00;
	STS  136,R30
; 0000 00A1 OCR1BH=0x00;
	STS  139,R30
; 0000 00A2 OCR1BL=0x00;
	STS  138,R30
; 0000 00A3 
; 0000 00A4 // Timer/Counter 2 initialization
; 0000 00A5 // Clock source: System Clock
; 0000 00A6 // Clock value: Timer2 Stopped
; 0000 00A7 // Mode: Normal top=0xFF
; 0000 00A8 // OC2A output: Disconnected
; 0000 00A9 // OC2B output: Disconnected
; 0000 00AA ASSR=0x00;
	STS  182,R30
; 0000 00AB TCCR2A=0x00;
	STS  176,R30
; 0000 00AC TCCR2B=0x00;
	STS  177,R30
; 0000 00AD TCNT2=0x00;
	STS  178,R30
; 0000 00AE OCR2A=0x00;
	STS  179,R30
; 0000 00AF OCR2B=0x00;
	STS  180,R30
; 0000 00B0 
; 0000 00B1 // External Interrupt(s) initialization
; 0000 00B2 // INT0: On
; 0000 00B3 // INT0 Mode: Rising Edge
; 0000 00B4 // INT1: Off
; 0000 00B5 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00B6 // Interrupt on any change on pins PCINT8-14: Off
; 0000 00B7 // Interrupt on any change on pins PCINT16-23: Off
; 0000 00B8 EICRA=0x03;
	LDI  R30,LOW(3)
	STS  105,R30
; 0000 00B9 EIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x1D,R30
; 0000 00BA EIFR=0x01;
	OUT  0x1C,R30
; 0000 00BB PCICR=0x00;
	LDI  R30,LOW(0)
	STS  104,R30
; 0000 00BC 
; 0000 00BD // Timer/Counter 0 Interrupt(s) initialization
; 0000 00BE TIMSK0=0x00;
	STS  110,R30
; 0000 00BF 
; 0000 00C0 // Timer/Counter 1 Interrupt(s) initialization
; 0000 00C1 TIMSK1=0x01;
	LDI  R30,LOW(1)
	STS  111,R30
; 0000 00C2 
; 0000 00C3 // Timer/Counter 2 Interrupt(s) initialization
; 0000 00C4 TIMSK2=0x00;
	LDI  R30,LOW(0)
	STS  112,R30
; 0000 00C5 
; 0000 00C6 // USART initialization
; 0000 00C7 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00C8 // USART Receiver: Off
; 0000 00C9 // USART Transmitter: On
; 0000 00CA // USART0 Mode: Asynchronous
; 0000 00CB // USART Baud Rate: 9600
; 0000 00CC UCSR0A=0x00;
	STS  192,R30
; 0000 00CD UCSR0B=0x08;
	LDI  R30,LOW(8)
	STS  193,R30
; 0000 00CE UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 00CF UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 00D0 UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
; 0000 00D1 
; 0000 00D2 // Analog Comparator initialization
; 0000 00D3 // Analog Comparator: Off
; 0000 00D4 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00D5 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00D6 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00D7 DIDR1=0x00;
	STS  127,R30
; 0000 00D8 
; 0000 00D9 // ADC initialization
; 0000 00DA // ADC disabled
; 0000 00DB ADCSRA=0x00;
	STS  122,R30
; 0000 00DC 
; 0000 00DD // SPI initialization
; 0000 00DE // SPI disabled
; 0000 00DF SPCR=0x00;
	OUT  0x2C,R30
; 0000 00E0 
; 0000 00E1 // TWI initialization
; 0000 00E2 // TWI disabled
; 0000 00E3 TWCR=0x00;
	STS  188,R30
; 0000 00E4 
; 0000 00E5 // Global enable interrupts
; 0000 00E6 #asm("sei")
	sei
; 0000 00E7 N16=350;
	LDI  R30,LOW(350)
	LDI  R31,HIGH(350)
	__PUTW1R 13,14
; 0000 00E8 min_time=0xFFFF;
	CALL SUBOPT_0x1
; 0000 00E9 normal_time=time_touch();
	RCALL _time_touch
	__PUTW1R 11,12
; 0000 00EA normal_time=normal_time*21/20;
	__GETW1R 11,12
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL __MULW12U
	MOVW R26,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21U
	__PUTW1R 11,12
; 0000 00EB delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00EC DDRB.5=1;
	SBI  0x4,5
; 0000 00ED while (1)
_0x1C:
; 0000 00EE     {
; 0000 00EF     data16=time_touch();
	RCALL _time_touch
	STS  _data16,R30
	STS  _data16+1,R31
; 0000 00F0     delay_ms(1000/Noprosov);           // 20 раз в секунду
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00F1     tx(data8[1]);
	LDS  R30,_data8
	LDS  R31,_data8+1
	LDD  R30,Z+1
	ST   -Y,R30
	RCALL _tx
; 0000 00F2     tx(data8[0]);
	LDS  R26,_data8
	LDS  R27,_data8+1
	LD   R30,X
	ST   -Y,R30
	RCALL _tx
; 0000 00F3     if (data16>normal_time)
	LDS  R26,_data16
	LDS  R27,_data16+1
	CP   R11,R26
	CPC  R12,R27
	BRSH _0x1F
; 0000 00F4         {
; 0000 00F5         // кнопка нажата
; 0000 00F6         if (N_tout==0)           // если первое нажатие
	TST  R7
	BRNE _0x20
; 0000 00F7             {
; 0000 00F8             if (PORTB.5==1) {PORTB.5=0;}
	SBIS 0x5,5
	RJMP _0x21
	CBI  0x5,5
; 0000 00F9             else  {PORTB.5=1;}
	RJMP _0x24
_0x21:
	SBI  0x5,5
_0x24:
; 0000 00FA             };
_0x20:
; 0000 00FB         N_tout=Noprosov;        // таймаут секунду
	LDI  R30,LOW(20)
	MOV  R7,R30
; 0000 00FC         }
; 0000 00FD     else
	RJMP _0x27
_0x1F:
; 0000 00FE         {
; 0000 00FF         if (N_tout!=0) {N_tout--;};
	TST  R7
	BREQ _0x28
	DEC  R7
_0x28:
; 0000 0100         }
_0x27:
; 0000 0101     N16++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
; 0000 0102     if (min_time>data16)
	LDS  R30,_data16
	LDS  R31,_data16+1
	LDS  R26,_min_time
	LDS  R27,_min_time+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x29
; 0000 0103         {min_time=data16;
	STS  _min_time,R30
	STS  _min_time+1,R31
; 0000 0104         };
_0x29:
; 0000 0105 
; 0000 0106     if (N16>400)
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R30,R13
	CPC  R31,R14
	BRSH _0x2A
; 0000 0107         {normal_time=min_time+25;
	LDS  R30,_min_time
	LDS  R31,_min_time+1
	ADIW R30,25
	__PUTW1R 11,12
; 0000 0108         min_time=0xFFFF;
	CALL SUBOPT_0x1
; 0000 0109         N16=0;
	CLR  R13
	CLR  R14
; 0000 010A         };
_0x2A:
; 0000 010B 
; 0000 010C     }
	RJMP _0x1C
; 0000 010D }
_0x2B:
	RJMP _0x2B
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_min_time:
	.BYTE 0x2
_data16:
	.BYTE 0x2
_data8:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	STS  133,R30
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _min_time,R30
	STS  _min_time+1,R31
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

;END OF CODE MARKER
__END_OF_CODE:
