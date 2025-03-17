#include <signal.h>
#include <time.h>
#include <unistd.h>
#include <poll.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <ctype.h>

#include <ncurses.h>

#include <verilated.h>
#include <verilated_vcd_c.h>
#ifdef	VM_COVERAGE
#include <verilated_cov.h>
#endif

#include "Vtop.h"
#include "Vtop___024unit.h"

#define MAX_SIM_TIME 20
vluint64_t sim_time = 0;

int	main(int argc, char **argv) {
    auto *dut = new Vtop;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    while (sim_time < MAX_SIM_TIME) {
        dut->clk ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}