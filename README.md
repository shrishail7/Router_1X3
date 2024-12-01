# Router_1X3

**Introduction to a 1x3 Router Design in VHDL**

**Project Overview**

This project implements a 1x3 Router design using VHDL and the Xilinx FPGA platform. The router is a fundamental building block in network-on-chip (NoC) architectures, responsible for directing data packets to their intended destinations. This specific design is a 1x3 router, meaning it receives data from a single input port and can route it to one of three output ports.

**Key Components and Functionality**

The router design comprises five primary modules:

1. **FIFO (First-In-First-Out) Module:**
   - Stores incoming data packets temporarily.
   - Prioritizes packets based on specific criteria (e.g., packet type, priority level).
   - Releases packets to the appropriate output port when the corresponding output channel is available.

2. **FSM (Finite State Machine) Module:**
   - Controls the overall operation of the router.
   - Determines the next state based on current state and input conditions.
   - Generates control signals to coordinate the activities of other modules.

3. **Register Module:**
   - Stores intermediate data and control signals.
   - Provides synchronization between different modules.

4. **Synchronization Module:**
   - Ensures proper timing and synchronization between different clock domains.
   - Handles clock domain crossing (CDC) issues to prevent metastability.

5. **Top Module:**
   - Integrates all the modules to form the complete router system.
   - Defines the top-level interface and instantiates the lower-level modules.

**Design Methodology**

The design process involves the following steps:

1. **Architectural Design:**
   - Define the overall architecture of the router, including the data path and control path.
   - Specify the desired features and performance requirements.

2. **RTL Design:**
   - Write VHDL code to implement the RTL design of each module.
   - Ensure the code is synthesizable and meets timing constraints.

3. **Testbench Development:**
   - Create a testbench to verify the functionality of the router.
   - Generate various test cases to cover different scenarios.

4. **Synthesis and Implementation:**
   - Use Xilinx tools to synthesize the RTL design into a gate-level netlist.
   - Implement the design onto a specific Xilinx FPGA device, optimizing for area, power, and performance.

5. **Verification and Testing:**
   - Simulate the design using both functional and timing simulations.
   - Perform static timing analysis (STA) to ensure timing closure.
   - Download the bitstream to the FPGA and verify the router's operation in hardware.

**Conclusion**

This 1x3 router design provides a solid foundation for understanding the principles of network-on-chip design. By mastering the concepts of FIFO, FSM, and synchronization, designers can create more complex routers with advanced features like virtual channels, quality of service (QoS), and flow control.
