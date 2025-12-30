class spi_agent extends uvm_agent;
  `uvm_component_utils(spi_agent)

  
  spi_driver drv;
  spi_sequencer seqr;
  spi_monitor mon;
  
  function new (string name="spi_agent",uvm_component parent);
    super.new(name,parent);
    `uvm_info("AGENT_CLASS","Inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT_CLASS","Inside build phase " , UVM_HIGH)
    drv=spi_driver::type_id::create("drv",this);
    seqr=spi_sequencer::type_id::create("seqr",this);
    mon=spi_monitor::type_id::create("mon",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT_CLASS","Inside connect phase",UVM_HIGH);
    //sequencer and driver handshake to exchange data
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask
endclass:spi_agent  
