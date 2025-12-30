class spi_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(spi_sequence_item)
  
  
  //instantiation
  
  rand logic start;
  rand logic rst;
  rand logic [7:0] data_in;
  rand logic [7:0] miso;
  
  logic ss;
  logic [7:0] mosi;
  logic sclk;
  logic [7:0] data_out;
  logic done;
  
  
  int unsigned pulse=0;
  
  
  function new(string name="spi_sequence_item");
    super.new(name);
    `uvm_info("SEQUENCE_ITEM","inside constructor",UVM_LOW)

  endfunction
  
endclass:spi_sequence_item
