To run simulation:
1. Copy the testcase you want to run ( input1.txt / input2.txt / input3.txt / input4.txt ) into
\<name_of_project>\<name_of_project>.sim\sim_1\behav\xsim

2. Check and rename ( if necessary ) the input file in tb_risc_processor.v:
$readmemb("input<1 | 2 | 3 | 4>.txt", uut.u_mem.mem); ( line number 58 )

3. Save and Run Simulation.