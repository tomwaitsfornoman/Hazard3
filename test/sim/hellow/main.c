#include "tb_cxxrtl_io.h"
#include "uart.h"

// #define PERI_BASE  0x0c0000
// #define UART_BASE  (PERI_BASE + 0x1000)
// #define UART_BASE  (0x40004000)
/*
int main() {
	tb_puts("Hello Daniel L from Hazard3 + CXXRTL!\n");
	volatile unsigned int *p = (unsigned int *9)0x40003000;
	*p = 0x12345678;
	return 123;
}
*/
// #define DECL_REG(addr, name) volatile uint32_t * const (name) = (volatile uint32_t*)(addr)
// DECL_REG(UART_BASE + UART_CSR_OFFS, UART_CSR);
/*
static inline void uart_init()
{
	*UART_CSR = 0;
	while (*UART_CSR & UART_CSR_BUSY_MASK)
		;
	while (!uart_rx_empty())
		(void)uart_get();
	uart_enable(true);
}
*/

#define CLK_FREQ_MHZ 100

int main()
{
	// Float stuff should all be compile-time. 115200 baud.
	uart_init();
	uart_clkdiv_baud(CLK_FREQ_MHZ, 115200);

	uart_puts("Hello, UART!\n");

	// Need to wait for completion, else we will terminate the simulation
	// while characters still in FIFO.
	uart_wait_done();
	// tb_exit(0);
}
