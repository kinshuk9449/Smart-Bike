module group_tb(
    input wire clk,             //50Mhz FPGA Clock
    input wire btn,             //Sensor Board Button (Pin D5 on the "Arduino Sensor Board")
    output wire MAIN_LED,         //Sensor Board LED (Pin D2 on the "Arduino Sensor Board")
    output reg LED0,             //Onboard FPGA LED    
    output reg LED1,             //Onboard FPGA LED
    output reg LED2,             //Onboard FPGA LED
    output reg LED3                //Onboard FPGA LED
);

 wire [18:0] heartrate;

group HD (
    .clk(clk),
    .btn(btn),
    .main_led(MAIN_LED),
  .heartrate(heartrate)
);

initial begin
    //Turn off all leds
    LED0 = 0;
    LED1 = 0;
    LED2 = 0;
    LED3 = 0;



   $dumpfile("Hd_tb.vcd");
  $dumpvars(1, group_tb);
    $finish;
end



always @(negedge clk)
begin
    ///SHOW Heartrate USING ONBOARD LEDS
  if (heartrate > 10)
    begin
        LED0 = 1;
    end
    
  if (heartrate > 20)
    begin
        LED1 = 1;
    end
    
  if (heartrate > 30)
    begin
        LED2 = 1;
    end
    
  if (heartrate > 40)
    begin
        LED3 = 1;
    end
    
  $display("heartrate=%d", heartrate);
    $finish;
end



endmodule