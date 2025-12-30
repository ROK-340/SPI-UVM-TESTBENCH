class spi_driver extends uvm_driver#(spi_sequence_item);
  `uvm_component_utils(spi_driver)

  
  virtual spi_interface vif;
  spi_sequence_item item;
  
  
  function new (string name="spi_driver",uvm_component parent);
    super.new(name,parent);
    `uvm_info("DRIVER_CLASS","Inside constructor",UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER_CLASS","Inside build phase " , UVM_HIGH)
    
    if(!(uvm_config_db #(virtual spi_interface)::get(this,"*","vif",vif)))begin 
      `uvm_error("DRIVER_CLASS","Failed to get vif config db")
    end
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("DRIVER_CLASS","Inside connect phase",UVM_HIGH);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("DRIVER_CLASS","inside run phase",UVM_HIGH);
    
    //logic
    forever begin
      item=spi_sequence_item::type_id::create("item");
      seq_item_port.get_next_item(item);
      drive(item);
      seq_item_port.item_done();
    end   
  endtask
  
  task drive(spi_sequence_item item);
    int done_seen=0;
    @(posedge vif.clk);
    //drive inputs
    vif.rst<=item.rst;
    vif.start<=item.start;
    
    if(item.rst) begin
      vif.start<=0;
      vif.miso<=0;
      vif.data_in<=0;
      `uvm_info("DRIVER","RESET APPLIED",UVM_LOW)
      return;
    end
    
    //start assertion
    if(item.pulse>0)begin
      vif.start<=1'b1;
      #item.pulse;
      vif.start<=1'b0;
    end
    
    else begin   //asserting start only after done has been asserted
      vif.start<=1'b1;
      `uvm_info("DRIVER",$sformatf("START asserted, wait for done"),UVM_LOW)
      #10;
      
      repeat (100) begin
        @(posedge vif.clk);
        if(vif.done) begin
          done_seen=1;
          break;
        end
      end
      if (!done_seen)
        `uvm_error("DRIVER","Timeout waiting for done signal check DUT")
      vif.start<=1'b0;
      vif.data_in=item.data_in;
      vif.miso<=item.miso;
    end
    
  endtask
endclass:spi_driver
