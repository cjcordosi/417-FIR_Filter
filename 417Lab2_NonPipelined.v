`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Pennsylvania State University
// Engineer: Cross Cordosi, Ignacio B., Rishabh T.
// 
// Create Date: 02/25/2021 06:56:54 PM
// Design Name: Lab#2
// Module Name: fir_7_7
// Project Name: Lab#2
// Target Devices: Zedboard 1.4
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fir_7_7(
    input clk,
    input rst,
    input [7:0] weight_data,
    input [2:0] weight_idx,
    input weight_valid,
    output weight_ready,
    input [7:0] input_data,
    input input_valid,
    output input_ready,
    output [15:0] output_data,
    input output_ready,
    output output_valid 
    );
    
    reg i_ready;
    reg w_ready;
    assign input_ready = i_ready;
    assign weight_ready = w_ready;
    
    wire [15:0] products [6:0];
    wire [15:0] sums [ 5:0];
    
    reg [7:0] inputs [6:0];
    reg [7:0] weights [6:0];
    
    reg [15:0] result;
    assign output_data = result;
    
    reg output_valid_delay;
    reg output_valid_r;
    
    assign output_valid = output_valid_r;
    
    // Delay 1 cycle
    always@(posedge clk)
    begin
        if(input_valid & input_ready)
            output_valid_delay <= 1;
        else
            output_valid_delay <= 0;
        output_valid_r = output_valid_delay;
    end

    
    always@(posedge clk)
    begin
        if(rst)
        begin
            inputs[0] <= 0;
            inputs[1] <= 0;
            inputs[2] <= 0;
            inputs[3] <= 0;
            inputs[4] <= 0;
            inputs[5] <= 0;
            inputs[6] <= 0;

            weights[0] <= 0;
            weights[1] <= 0;
            weights[2] <= 0;
            weights[3] <= 0;
            weights[4] <= 0;
            weights[5] <= 0;
            weights[6] <= 0;

            result <= 0;
            i_ready <= 0;
            w_ready <= 0;
        end else begin
            i_ready <= 1;
            w_ready <= 1;
            if(weight_ready & weight_valid)begin
                weights[weight_idx] <= weight_data;
            end

            if(input_valid & input_ready)begin
                inputs[0] <= input_data;
                inputs[1] <= inputs[0];
                inputs[2] <= inputs[1];
                inputs[3] <= inputs[2];
                inputs[4] <= inputs[3];
                inputs[5] <= inputs[4];
                inputs[6] <= inputs[5];
            end
            
            if(output_valid & output_ready)begin
                result <= inputs[0]*weights[0] + inputs[1]*weights[1] + inputs[2]*weights[2] + inputs[3]*weights[3] + inputs[4]*weights[4] + inputs[5]*weights[5] + inputs[6]*weights[6];
            end
            
        end
    end
    

endmodule