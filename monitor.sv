
class spi_monitor extends uvm_monitor;
  `uvm_component_utils(spi_monitor)
  
  virtual spi_interface vif;
  spi_sequence_item item;
    
  uvm_analysis_port #(spi_sequence_item) monitor_port;
  
  function new (string name="spi_monitor",uvm_component parent);
    super.new(name,parent);
    `uvm_info("MONITOR_CLASS","Inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS","Inside build phase " , UVM_HIGH)
    
    monitor_port=new("monitor_port",this);
    
    if(!(uvm_config_db #(virtual spi_interface)::get(this,"*","vif",vif)))begin 
      `uvm_error("MONITOR_CLASS","Failed to get vif config db")
      
    end
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS","Inside connect phase",UVM_HIGH);
  endfunction
  
  task run_phase(uvm_phase phase);
    bit [7:0] o_mosi='0;
    bit [7:0] o_miso='0;
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS","Inside build phase " ,UVM_HIGH)

    //logic
    forever begin
      item=spi_sequence_item::type_id::create("item");
      
      
      wait(!vif.rst);
      
      //sample inputs
      @(posedge vif.start);
      item.start=vif.start;
      item.rst=vif.rst;
      item.data_in=vif.data_in;
      item.ss=vif.ss; 
      for(int i=0;i<8;i++)begin
        @(negedge vif.sclk);
        o_mosi={o_mosi[6:0],vif.mosi};       
      end
      for(int i=0;i<8;i++)begin
        @(posedge vif.sclk);
        o_miso={o_miso[6:0],vif.miso};
      end
      
      @(posedge vif.done);
      //sample outputs
      @(posedge vif.clk);
      item.mosi=o_mosi;
      item.miso=o_miso;
      item.sclk=vif.sclk;
      item.data_out=vif.data_out;
      item.done=vif.done;
      //send item to scoreboard
      monitor_port.write(item);  
    end
  endtask
endclass:spi_monitor
