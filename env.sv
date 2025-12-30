// Environment Class
class spi_env extends uvm_env;

  `uvm_component_utils(spi_env)

  // External class object declarations 
  spi_agent agnt;
  spi_scoreboard scb;

  // Constructor
  function new(string name="spi_env",uvm_component parent);
    super.new(name,parent);
    `uvm_info("ENV_CLASS","Inside Constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);    
    super.build_phase(phase);
    `uvm_info("ENV_CLASS","Inside build phase", UVM_HIGH)  
    agnt=spi_agent::type_id::create("agnt",this);
    scb=spi_scoreboard::type_id::create("scb",this);  
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV_CLASS","Inside build phase",UVM_HIGH)
    agnt.mon.monitor_port.connect(scb.scoreboard_port);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask
  
endclass : spi_env
