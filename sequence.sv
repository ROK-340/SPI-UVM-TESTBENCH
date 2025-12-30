
class spi_base_sequence extends uvm_sequence;
  `uvm_object_utils(spi_base_sequence)
  
  spi_sequence_item reset_pkt;
  
  function new(string name="spi_base_sequence");
    super.new(name);
    `uvm_info("BASE_SEQ","inside constructor",UVM_LOW)
  endfunction
      
      task body();
              `uvm_info("BASE_SEQ","inside body task", UVM_HIGH);  
        
        reset_pkt=spi_sequence_item::type_id::create("reset_pkt");
                     
        start_item(reset_pkt);
        reset_pkt.randomize() with {rst==1;};
        finish_item(reset_pkt);
        
      endtask
  
endclass:spi_base_sequence

class spi_test_sequence extends spi_base_sequence;
  `uvm_object_utils(spi_test_sequence)
  
  spi_sequence_item item;
  
  
  function new(string name="spi_test_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ","inside constructor",UVM_HIGH)
  endfunction
  
  task body();
    `uvm_info("TEST_SEQ","inside body task",UVM_HIGH)
    
    
    
    repeat(2) begin
      for(int i=1;i<8;i++)begin
        case (i)
        1:run_reset_test();
        2:run_single_transfer_test();
        3:run_back_to_back_test();
        4:run_random_data_test();
        5: run_miso_stuck_high_test();
        6:run_miso_stuck_low_test();
        7:run_partial_start_test();
      	//8:run_miso_test();
      //default:run_default_test();      
    	endcase
      end
    end
  endtask
  
  // Sequence generating functions to test different scenarios for the SPI
  task run_reset_test();
    `uvm_info("RST_TEST","in run reset test",UVM_LOW)
    item=spi_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with{rst==1;data_in==8'h00;};    
    finish_item(item);
    #1000;
    start_item(item);
    item.randomize() with {rst==0;start==1;data_in==8'hA5;};
    finish_item(item);
    
  endtask
  
  task run_single_transfer_test();
    `uvm_info("SINGLE_TRANSFER","in run single transfer test",UVM_LOW)
    item=spi_sequence_item::type_id::create("item");
    
    start_item(item);
    
    item.randomize() with {rst==0;start==1;data_in==8'hb5;};
    finish_item(item);
    
  endtask
  
  task run_back_to_back_test();
    `uvm_info("BACKTOBACK","in run single transfer test",UVM_LOW)
      item=spi_sequence_item::type_id::create("item");
      start_item(item);
      repeat (2) begin
      item.randomize() with {rst==0; start==1;};
      end
      finish_item(item);
  endtask
  
  task run_random_data_test();
    `uvm_info("RANDOMDATA","in run single transfer test",UVM_LOW)
    repeat(10) begin
      item=spi_sequence_item::type_id::create("item");
      start_item(item);
      item.randomize() with {rst==0; start==1;};
      finish_item(item);
    end 
  endtask
  
  task run_miso_stuck_high_test();
    `uvm_info("MISOHIGH","i wanna get here ",UVM_LOW)
    item=spi_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {rst==0; start==1;miso==1;};
    finish_item(item);  
  endtask
  
  task run_miso_stuck_low_test();
    `uvm_info("MISOSTUCKLOW","miso is stuck low",UVM_LOW)
    item=spi_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {rst==0;start==1;miso==0;};
    finish_item(item);  
  endtask
  
  task run_partial_start_test();
    `uvm_info("PARTIAL","im loosing my mind man someone come save me",UVM_LOW)
    item=spi_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with {rst==0;start==1;};
    item.pulse=100;
    finish_item(item);
    
  endtask
endclass:spi_test_sequence
