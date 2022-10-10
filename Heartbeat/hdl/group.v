module group (
    input wire clk,               //50Mhz FPGA Clock
    input wire btn,               //Sensor Board Button (Pin D5 on the "Arduino Sensor Board")
    output reg main_led,       //Sensor Board LED (Pin D2 on the "Arduino Sensor Board")
    output reg[17:0] heartrate   //Weight output (Q10.8)
);



//Counter for clock division
  reg[32:0] count;



//Constants
reg[32:0] clkResetCount = 50000000;



//Trackers
reg[32:0] startClk;
reg prevState;



initial begin
    count = 32'h00000000;
    heartrate = 18'h000000000; //clock is for keeping track of the buttons state
    startClk = 32'h00000000;
    prevState = 0;
    heartrate = 0;
end



always @(posedge clk)
begin
    count = count + 1;
    
    //STATE: unpressed -> pressed
    if (prevState == 0 && btn == 1)
    begin
        main_led = 1;
        prevState = 1;
        startClk = count;
    end
    
    //STATE: pressed -> unpressed < 1 seconds
    else if (prevState == 1 && btn == 0 && (count - startClk) < clkResetCount && startClk > 0)
    begin
        startClk = 0;
        heartrate = heartrate + (1);
    end
    
    //STATE: pressed -> pressed > 1 seconds //held button for more than one second
    else if (prevState == 1 && btn == 1 && (count - startClk) > clkResetCount && startClk > 0)
    begin
        main_led = 0;
        heartrate = heartrate + (1);
        startClk = 0;
    end
    
    //STATE: pressed -> unpressed
    else if (prevState == 1 && btn == 0)
    begin
        main_led = 0;
        prevState = 0;
    end
    
end



endmodule