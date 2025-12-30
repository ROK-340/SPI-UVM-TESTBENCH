interface spi_interface(input logic clk);

  // Declaring all interface variables
  logic start;
  logic rst;
  logic [7:0] data_in;
  logic miso;
  logic mosi;
  logic sclk;
  logic ss;
  logic [7:0] data_out;
  logic done;
  
  // Assertions
    
   property m_v_o_r;			// miso valid on rising edge w ss low
        @(posedge clk)
            (ss == 0 && $rose(sclk)) |-> !$isunknown(miso);
    endproperty
    assert property (m_v_o_r)
        else $error("ASSERTION FAIL: MISO invalid on rising edge");

   property ss_a_u_d;		 // ss active until done is high
     disable iff(rst)
      @(posedge clk)
     (start && ss == 0) |-> ##[1:64] done ##1 ss == 1;
    endproperty
    assert property (ss_a_u_d)
        else $error("ASSERTION FAIL: SS released early");
  
endinterface : spi_interface
