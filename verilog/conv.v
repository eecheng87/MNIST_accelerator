module conv(
    input rst,
    input clk, 
    output reg M0_R_req, 
    output reg [31:0]M0_addr, 
    input [31:0]M0_R_data, 
    output reg [3:0]M0_W_req, 
    output reg [31:0]M0_W_data,

    output reg M1_R_req, 
    output reg [31:0]M1_addr, 
    input [31:0]M1_R_data, 
    output reg [3:0]M1_W_req, 
    output reg [31:0]M1_W_data,

    output reg M2_R_req, 
    output reg [31:0]M2_addr, 
    input [31:0]M2_R_data, 
    output reg [3:0]M2_W_req, 
    output reg [31:0]M2_W_data,
    
    input start,
    output reg finish
);

reg [2:0]window[8:0];
reg [2:0]global_state;
reg [1:0]current_line;
reg [2:0]line_buffer1[27:0];
reg [2:0]line_buffer2[27:0];
reg [2:0]line_buffer3[27:0];
reg [4:0]line_buf_setting_time;
reg req_state; // 1 means asking date, 0 means data already
initial begin
    current_line = 0;
    req_state = 1;
    line_buf_setting_time = 0;
    global_state = 0;
end

always @(posedge clk) begin
    if(start == 1 && global_state == 0)begin
        M0_W_req <= 0;
        M0_W_data <= 0;
        M1_addr <= 0;
        M1_R_req <= 0;
        M1_W_req <= 0;
        M1_W_data <= 0;
        M2_addr <= 0;
        M2_R_req <= 0;
        M2_W_req <= 0;
        M2_W_data <= 0;
        case (current_line)
            2'b00:begin
                if(line_buf_setting_time < 7)begin
                    if(req_state)begin
                        M0_R_req <= 1;
                        M0_addr <= line_buf_setting_time;
                        req_state <= 0;
                    end else begin
                        // data already
                        line_buffer1[line_buf_setting_time<<2] <= M0_R_data[31:24];
                        line_buffer1[(line_buf_setting_time<<2)+1] <= M0_R_data[23:16];
                        line_buffer1[(line_buf_setting_time<<2)+2] <= M0_R_data[15:8];
                        line_buffer1[(line_buf_setting_time<<2)+3] <= M0_R_data[7:0];
                        req_state <= 1;
                        line_buf_setting_time <= line_buf_setting_time + 1;
                    end
                end else begin
                    line_buf_setting_time <= 0;
                    current_line <= current_line + 1;
                end
            end
            2'b01:begin
                if(line_buf_setting_time < 7)begin
                    if(req_state)begin
                        M0_R_req <= 1;
                        M0_addr <= line_buf_setting_time;
                        req_state <= 0;
                    end else begin
                        // data already
                        line_buffer2[line_buf_setting_time<<2] <= M0_R_data[31:24];
                        line_buffer2[(line_buf_setting_time<<2)+1] <= M0_R_data[23:16];
                        line_buffer2[(line_buf_setting_time<<2)+2] <= M0_R_data[15:8];
                        line_buffer2[(line_buf_setting_time<<2)+3] <= M0_R_data[7:0];
                        req_state <= 1;
                        line_buf_setting_time <= line_buf_setting_time + 1;
                    end
                end else begin
                    line_buf_setting_time <= 0;
                    current_line <= current_line + 1;
                end
            end
            2'b10:begin
                if(line_buf_setting_time < 7)begin
                    if(req_state)begin
                        M0_R_req <= 1;
                        M0_addr <= line_buf_setting_time;
                        req_state <= 0;
                    end else begin
                        // data already
                        line_buffer3[line_buf_setting_time<<2] <= M0_R_data[31:24];
                        line_buffer3[(line_buf_setting_time<<2)+1] <= M0_R_data[23:16];
                        line_buffer3[(line_buf_setting_time<<2)+2] <= M0_R_data[15:8];
                        line_buffer3[(line_buf_setting_time<<2)+3] <= M0_R_data[7:0];
                        req_state <= 1;
                        line_buf_setting_time <= line_buf_setting_time + 1;
                    end
                end else begin
                    // line_buf_setting_time <= 0;
                    // current_line <= current_line + 1;
                    global_state <= 1;
                end
            end 
            default: 
        endcase
    end else if(start == 0 && global_state == 1)begin

    end
end


endmodule