`timescale 1ns / 1ps
module bin2hex_ascii(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [31:0] bin,
    output reg         ready,
    output reg  [63:0] ascii_str // 8个字符，每个8位，共64位
);

    integer i;
    reg [3:0] nibble;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ready <= 0;
            ascii_str <= 0;
        end else begin
            if (start) begin
                // 修改点：i 从 0 到 7
                // bin[i*4 +: 4] 获取的是从低到高的 4-bit 段
                // 将其存入 ascii_str[i*8 +: 8] 对应的字节位置
                // 这样 ascii_str 的高字节存储的就是 bin 的高 4 位映射的字符
                for (i = 0; i < 8; i = i + 1) begin
                    nibble = bin[i*4 +: 4];
                    if (nibble < 10) begin
                        ascii_str[i*8 +: 8] <= nibble + 8'h30; // '0'-'9'
                    end else begin
                        ascii_str[i*8 +: 8] <= nibble + 8'h37; // 'A'-'F'
                    end
                end
                ready <= 1;
            end else begin
                ready <= 0;
            end
        end
    end
endmodule