/******************************************************************************
*	timer.s
*	
*    Inspired by Raspberry Pi OS Development course:
*    http://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/
******************************************************************************/

/*
* The system timer runs at 1MHz, and just counts always. Thus we can deduce
* timings by measuring the difference between two readings.
*/

/*
* C void* GetSystemTimerBaseAdr()
*/
.globl GetSystemTimerBaseAdr
GetSystemTimerBaseAdr: 
	ldr r0,=0x20003000
	mov pc,lr

/*
* uint64_t GetTimeStamp()
*/
.globl GetTimeStamp
GetTimeStamp:
	push {lr}
	bl GetSystemTimerBaseAdr
	ldrd r0,r1,[r0,#4]
	pop {pc}

/*
* void sleep(uint32_t delay_us)
*/
.globl sleep
sleep:
	delay .req r2
	mov delay,r0	
	push {lr}
	bl GetTimeStamp
	start .req r3
	mov start,r0

	loop$:
		bl GetTimeStamp
		elapsed .req r1
		sub elapsed,r0,start
		cmp elapsed,delay
		.unreq elapsed
		bls loop$
		
	.unreq delay
	.unreq start
	pop {pc}
