class spi_test extends uvm_test;
  
  `uvm_component_utils(spi_test)

  // Declaring object variables from other classes
  spi_env env;
  spi_base_sequence reset_seq; 
  spi_test_sequence test_seq; 
  
  // Constructor 
  function new(string name="spi_test",uvm_component parent);
    super.new(name,parent);
    `uvm_info("TEST_CLASS","Inside Constructor", UVM_LOW)    
  endfunction

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS","Build Phase",UVM_HIGH);
    env = spi_env::type_id::create("env",this);  
  endfunction

  // Connect Phase 
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS","connect phase",UVM_HIGH);  
  endfunction

  // Run Phase 
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS","run phase",UVM_HIGH)
      
    phase.raise_objection(this); 
    test_seq=spi_test_sequence::type_id::create("test_seq");
    
    // Running the Test
    test_seq.start(env.agnt.seqr);
    // Ending the test
    phase.drop_objection(this);
      
  endtask
  
  
  
   
endclass : spi_test
