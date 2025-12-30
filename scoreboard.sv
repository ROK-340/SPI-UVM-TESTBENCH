class spi_scoreboard extends uvm_test;
  
  `uvm_component_utils(spi_scoreboard)
  
  uvm_analysis_imp #(spi_sequence_item,spi_scoreboard) scoreboard_port ;
  
  spi_sequence_item transactions[$];
   
  function new(string name="spi_scoreboard",uvm_component parent);
    super.new(name,parent);
    `uvm_info("SCB_CLASS","Inside Constructor", UVM_LOW)    
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS","Build Phase",UVM_HIGH);
    scoreboard_port=new("scoreboard_port",this);    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB_CLASS","connect phase",UVM_HIGH);
  endfunction
  
  //write method 
  function void write(spi_sequence_item item);
    transactions.push_back(item);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("SCB_CLASS","run phase",UVM_HIGH)  
    //logic
    forever begin
      //get packet
      //generate expected value
      //compare with actual value
      //score the transactions 
      spi_sequence_item curr_trans;
      wait((transactions.size()!=0));
      curr_trans = transactions.pop_front();
      compare(curr_trans);
    end
  endtask
  
  task compare(spi_sequence_item curr_trans);
    logic  e_ss ;
    logic  a_ss;
    
    case(curr_trans.start)
      0:begin
        e_ss=1;
        //sclk is not active
        //no transfers are active
      end
      1:begin
        e_ss=0;
        //sclk toggles 
        //transfer begins
      end
    endcase
    
    a_ss=curr_trans.ss;       
    
    if(a_ss!=e_ss) begin
      `uvm_error("COMPARE",$sformatf("Transaction Failed Actual= %d , Expected= %d",a_ss,e_ss))
    end
    else begin
      `uvm_info("COMPARE",$sformatf("Transaction Passed Actual= %d , Expected= %d",a_ss,e_ss),UVM_LOW)
    end
    
    if(curr_trans.mosi!==curr_trans.data_in)
      `uvm_error("SCOREBOARD",$sformatf("TX mismatch data_in=0x%0h, observed mosi= 0x%0h",curr_trans.data_in,curr_trans.mosi))
    else
        `uvm_info("SCOREBOARD",$sformatf("TX OK: data_in match"),UVM_LOW)
        
    if(curr_trans.data_out!==curr_trans.miso)
        `uvm_error("SCOREBOARD",$sformatf("RX mismatch observed miso=0x%0h and data_out=0x%0h",curr_trans.miso,curr_trans.data_out))
    else
        `uvm_info("SCOREBOARD",$sformatf("RX OK: data_out match"),UVM_LOW)
        
    if(curr_trans.done!==1'b1)
        `uvm_error("SCOREBOARD","Done signal not asserted after transfer")
    else
        `uvm_info("SCOREBOARD","DONE signal asserted after transfer",UVM_LOW)
  endtask
  
endclass : spi_scoreboard
