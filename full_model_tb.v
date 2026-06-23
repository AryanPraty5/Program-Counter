`timescale 1ns/1ps

module full_model_tb;

reg pc_out,ce,jump,clk,wr,reset,switch;
wire [7:0]bus;

reg bus_drive;
reg [7:0]bus_tb;

    assign bus = (bus_drive) ? bus_tb : 8'bz;   //tri-state behaviour of bus 

    PC_model pc1(.bus(bus),.pc_out(pc_out),.ce(ce),.jump(jump),.clk(clk),.reset(reset));
    ram_model ram1(.clk(clk),.wr(wr),.bus(bus),.switch(switch));

    initial
        begin
            clk = 0;
            forever #5 clk = ~clk;
        end

    initial
        begin
            #1;
            pc_out = 1'b0;          // pc doesnt pass the value to bus rn
            ce = 1'b0;
            jump = 1'b0;
            reset = 1'b1;
            wr = 1'b1;
            bus_drive =1'b1;        //bus is initialised with 8-bits 0;
            bus_tb = 8'b0000_0000;
            switch = 1'b0;

            #10;

            reset = 1'b0;
            pc_out = 1'b1;      //pc passes the 1st address i.e. 0000 to the bus
            ce = 1'b0;
            wr = 1'b1;          // wr = 1 means ram is reading this address
            bus_drive =1'b0;

            #10;

            pc_out = 1'b0;      
            ce = 1'b1;          //value should come as 7
            wr = 1'b0;          // wr = 0 means ram is writing this address onto bus

            #10;

            pc_out = 1'b1;      
            ce = 1'b0;
            wr = 1'b1;          // wr = 0 means ram is reading;

            #10;

            pc_out = 1'b0;      
            ce = 1'b1;          //value should come as 6
            wr = 1'b0;          // wr = 0 means ram is writing the element onto bus

            #10;

            pc_out = 1'b1;      
            ce = 1'b0;
            wr = 1'b1;          // wr = 0 means ram is reading;

            #10;

            pc_out = 1'b0;      
            ce = 1'b1;          //value should come as 5
            wr = 1'b0;          // wr = 0 means ram is writing the element onto bus

            #10;

            ce = 1'b0;
            bus_tb = 8'b0000_1000;
            bus_drive = 1'b1;
            jump = 1'b1;        // jump to address 8
            wr = 1'b1;          // wr = 1 reading 
            
            
            #10;

            pc_out = 1'b1;
            bus_drive = 1'b0;
            jump = 1'b0;
            wr = 1'b1;          // wr = 1 reading

            #10;

            pc_out = 1'b0;      // value should come as 0e
            wr = 1'b0;          // wr = 0 writing
            ce = 1'b1;

            #10;
            
            pc_out = 1'b1;
            wr = 1'b1;          // reading

            #10;

            pc_out = 1'b0;      // value should come as 0a
            wr = 1'b1;          //writing

            $stop;

        end
endmodule