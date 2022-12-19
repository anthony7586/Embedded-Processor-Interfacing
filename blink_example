#include <stdint.h>
#include "msp432p401r.h"

// CPU clock rate
int clk = 300;

void main() {
	int i, j;

	// Config P1.0 (LED)
	P1SEL0 &= ~0x01;
	P1SEL1 &= ~0x01;
	P1DIR |= 0x01;

	while(1) {
		P1OUT ^= 0x01;

		// Inefficeint way to do a delay
		for(i=0; i<clk; i++) {
			for(j=0; j<clk; j++) {
				// Delay
			}
		}
	}
}
