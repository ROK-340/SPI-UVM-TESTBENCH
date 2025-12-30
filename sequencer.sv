class spi_sequencer extends uvm_sequencer#(spi_sequence_item);
  `uvm_component_utils(spi_sequencer)
  
  function new (string name="spi_sequencer",uvm_component parent);
    super.new(name,parent);
    `uvm_info("SEQUENCER_CLASS","Inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SEQUENCER_CLASS","Inside build phase " , UVM_HIGH)
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_SEQUENCER_CLASSCLASS","Inside connect phase",UVM_HIGH);
  endfunction
  
endclass:spi_sequencer
