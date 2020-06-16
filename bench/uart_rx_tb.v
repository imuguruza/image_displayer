`default_nettype none

module uart_rx_tb();

parameter baud = 0;
parameter  clk_freq = 0;

// As the clock it is created in each 2 secs, multiply 2x the bitrate
localparam BITRATE = (clk_freq/baud << 1);
// Required time for sending a whole frame, with 2 stop bits
localparam FRAME = (BITRATE * 10);
// Wait time between two bits
localparam FRAME_WAIT = (BITRATE * 4);

integer  CHAR = "";

//----------------------
// Char sending task
//----------------------
  task send_car;
    input [7:0] car;
  begin
    rx <= 0;                 //-- Start bit
    #BITRATE rx <= car[0];   //-- Bit 0
    #BITRATE rx <= car[1];   //-- Bit 1
    #BITRATE rx <= car[2];   //-- Bit 2
    #BITRATE rx <= car[3];   //-- Bit 3
    #BITRATE rx <= car[4];   //-- Bit 4
    #BITRATE rx <= car[5];   //-- Bit 5
    #BITRATE rx <= car[6];   //-- Bit 6
    #BITRATE rx <= car[7];   //-- Bit 7
    #BITRATE rx <= 1;        //-- Stop bit
    #BITRATE rx <= 1;        //-- Wait
  end
  endtask

reg   clk = 0;
reg   rx = 1;
reg   reset = 0; //Set reset to 0 for test
wire  act;
wire  [7:0] data;
wire  rdy;

uart_rx #(.clk_freq(clk_freq),
          .baud(baud)
         )
  dut(
    .clk,
    .rst(reset),
    .rx(rx),
    .data_rdy(rdy),
    .data(data)
  );

always
  # 1 clk <= ~clk;

initial begin

  //-- Store results
  $dumpfile("uart_rx_tb.vcd");
  $dumpvars(0, uart_rx_tb);
  $display ("\t\t========================  ");
  $display ("\t\t Starting simulation...   ");
  $display ("\t\t========================  ");

  //-- Send data
  CHAR = 8'h55;
  #BITRATE    send_car(CHAR);
  if ( data == CHAR) $display ("\t\tData received = %x, OK!   \n", data);
  else               $display ("\t\tData received = %x, ERROR!\n", data);

  CHAR = "K";
  #FRAME_WAIT send_car(CHAR);
  #BITRATE
  if ( data == CHAR) $display ("\t\tData received = %x, OK!   \n", data);
  else               $display ("\t\tData received = %x, ERROR!\n", data);

  #(FRAME_WAIT*4)  $display  ("\t\t========================");
                   $display  ("\t\t END of simulation"      );
                   $display  ("\t\t========================");
  $finish;
end

endmodule
