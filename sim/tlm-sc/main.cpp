/*!
 \file main.cpp
 \brief Top level simulation entity
 \author squeakbug
 */

#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <csignal>
#include <unistd.h>
#include <chrono>
#include <cstdint>

#include <systemc>

#include <spdlog/spdlog.h>
#include <spdlog/sinks/basic_file_sink.h>

int sc_main(int argc, char *argv[]) {

	/* SystemC time resolution set to 1 ns*/
	sc_core::sc_set_time_resolution(1, sc_core::SC_NS);

	auto start = std::chrono::steady_clock::now();
	sc_core::sc_start();
	auto end = std::chrono::steady_clock::now();

	std::chrono::duration<double> elapsed_seconds = end - start;
    //double instructions = static_cast<double>(perf->getInstructions()) / elapsed_seconds.count();

	std::cout << "Total elapsed time: " << elapsed_seconds.count() << "s" << std::endl;
	// std::cout << "Simulated " << int(std::round(instructions)) << " instr/sec" << std::endl;

	return 0;
}
