//SPI_UVM


import uvm_pkg::*;
`include "uvm_macros.svh"

//Include files
`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"

module top;
  
  logic clk;
  spi_interface intf(.clk(clk));
  //Instantiation
  spi_master_duplex dut(.clk(intf.clk),
                        .rst(intf.rst),
                        .start(intf.start),
                        .data_in(intf.data_in),
                        .miso(intf.miso),
                        .mosi(intf.mosi),
                        .sclk(intf.sclk),
                        .ss(intf.ss),
                        .data_out(intf.data_out),
                        .done(intf.done)
                       );
  
  //intf setting
  initial begin
    uvm_config_db #(virtual spi_interface)::set(null,"*","vif",intf); //first 2 parameters pass the path of the spi_interface to the config db and vif is the object name 
  end
  
  
  // test start point
  initial begin
    run_test("spi_test");
  end
  
  
  initial begin
    clk=0;
    #5;
    forever begin
      clk=~clk;
      #5;
    end
  end
  
  initial begin
    $dumpfile("d.vcd");
    $dumpvars();
  end
  
endmodule
