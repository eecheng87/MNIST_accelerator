`timescale 1ns/10ps
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

parameter k1_1 = 8'h07;
parameter k1_2 = 8'h03;
parameter k1_3 = 8'h05;
parameter k1_4 = 8'h01;
parameter k1_5 = 8'h0A;
parameter k1_6 = 8'h05;
parameter k1_7 = 8'h08;
parameter k1_8 = 8'h08;
parameter k1_9 = 8'hFD;

parameter k2_1 = 8'h03;
parameter k2_2 = 8'h0D;
parameter k2_3 = 8'h0F;
parameter k2_4 = 8'hFE;
parameter k2_5 = 8'h05;
parameter k2_6 = 8'h08;
parameter k2_7 = 8'hEA;
parameter k2_8 = 8'hE9;
parameter k2_9 = 8'hE7;

parameter bias = 8'hFF;

reg [7:0]window[8:0];
reg [2:0]global_state;
reg [4:0]global_row_index;
reg [1:0]current_line;
reg [7:0]line_buffer1[27:0];
reg [7:0]line_buffer2[27:0];
reg [7:0]line_buffer3[27:0];
reg [4:0]line_buf_setting_time;
reg req_state; // 1 means asking date, 0 means data already
reg [2:0]convolution_state;
reg [15:0]convo_p1[8:0];
reg [15:0]convo_p2[8:0];
reg [7:0]kernel1[8:0];
reg [7:0]kernel2[8:0];
reg [15:0]convo_sum1;
reg [15:0]convo_sum2;
reg [7:0]convo_ans1[3:0];
reg [7:0]convo_ans2[3:0];
reg [2:0]convo_time;
reg [7:0]write_addr;
reg [4:0]row_addr_index; // for addr offset which will be access next row
reg running_flag;
reg waiting_req;
integer i;

initial begin
    current_line = 0;
    req_state = 1;
    line_buf_setting_time = 0;
    global_state = 0;
    convolution_state = 0;
    kernel1[0] = k1_1;
    kernel1[1] = k1_2;
    kernel1[2] = k1_3;
    kernel1[3] = k1_4;
    kernel1[4] = k1_5;
    kernel1[5] = k1_6;
    kernel1[6] = k1_7;
    kernel1[7] = k1_8;
    kernel1[8] = k1_9;
    kernel2[0] = k2_1;
    kernel2[1] = k2_2;
    kernel2[2] = k2_3;
    kernel2[3] = k2_4;
    kernel2[4] = k2_5;
    kernel2[5] = k2_6;
    kernel2[6] = k2_7;
    kernel2[7] = k2_8;
    kernel2[8] = k2_9;
    convo_time = 0;
    write_addr = 0;
    global_row_index <= 3;
    running_flag <= 0;
    row_addr_index <= 3;
    waiting_req <= 1;
end

always @(posedge clk) begin
    if((start == 1 && global_state == 0) || (global_state == 0 && running_flag == 1))begin
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
	running_flag <= 1;
        case (current_line)
            2'b00:begin
                if(line_buf_setting_time < 7)begin
                    if(req_state)begin
                        M0_R_req <= 1;
                        M0_addr <= line_buf_setting_time<<2; // hi
                        req_state <= 0;
			//$display("check: %d",line_buf_setting_time);
                    end else begin
                        // data already
			#1
                        line_buffer1[line_buf_setting_time<<2] <= M0_R_data[31:24];
                        line_buffer1[(line_buf_setting_time<<2)+1] <= M0_R_data[23:16];
                        line_buffer1[(line_buf_setting_time<<2)+2] <= M0_R_data[15:8];
                        line_buffer1[(line_buf_setting_time<<2)+3] <= M0_R_data[7:0];
                        req_state <= 1;
                        line_buf_setting_time <= line_buf_setting_time + 1;
			//$display("line1 %d",M0_R_data);
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
                        M0_addr <= (7+line_buf_setting_time)<<2; // hi
                        req_state <= 0;
                    end else begin
                        // data already
			#1;
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
                        M0_addr <= (14+line_buf_setting_time)<<2; // hi
                        req_state <= 0;
                    end else begin
                        // data already
			#1;
                        line_buffer3[line_buf_setting_time<<2] <= M0_R_data[31:24];
                        line_buffer3[(line_buf_setting_time<<2)+1] <= M0_R_data[23:16];
                        line_buffer3[(line_buf_setting_time<<2)+2] <= M0_R_data[15:8];
                        line_buffer3[(line_buf_setting_time<<2)+3] <= M0_R_data[7:0];
                        req_state <= 1;
                        line_buf_setting_time <= line_buf_setting_time + 1;
                    end
                end else begin
                    // three line buffer is initial complete
			line_buf_setting_time <=0;
                    global_state <= 1;
                end
            end 
            default: begin
		end
        endcase
    end else if(start == 0 && global_state == 1)begin
        M0_W_req <= 0;
        M0_W_data <= 0;
        //M0_R_data <= 0;
        M0_addr <= 0;
        M1_addr <= 0;
        M1_R_req <= 0;
        M1_W_req <= 0;
        M1_W_data <= 0;
        M2_addr <= 0;
        M2_R_req <= 0;
        M2_W_req <= 0;
        M2_W_data <= 0;
        window[0] <= line_buffer1[0];
        window[1] <= line_buffer1[1];
        window[2] <= line_buffer1[2];
        window[3] <= line_buffer2[0];
        window[4] <= line_buffer2[1];
        window[5] <= line_buffer2[2];
        window[6] <= line_buffer3[0];
        window[7] <= line_buffer3[1];
        window[8] <= line_buffer3[2];
        global_state <= global_state + 1;
    end else if(global_state == 2)begin
	//$display("enter state 2");
        case (convolution_state)
            3'b000: begin
                for(i = 0; i < 9; i = i + 1)begin
                    convo_p1[i] <= $signed(kernel1[i])*$signed(window[i]);
                    convo_p2[i] <= $signed(kernel2[i])*$signed(window[i]);
			//if(write_addr == 0)$display("addr: %d %d",write_addr,window[i]);
                end
                convolution_state <= convolution_state + 1;
            end
            3'b001: begin
                convo_sum1 <= $signed(convo_p1[0])+$signed(convo_p1[1])+
                $signed(convo_p1[2])+$signed(convo_p1[3])+$signed(convo_p1[4])+
                $signed(convo_p1[5])+$signed(convo_p1[6])+$signed(convo_p1[7])+
                $signed(convo_p1[8]);
                convo_sum2 <= $signed(convo_p2[0])+$signed(convo_p2[1])+
                $signed(convo_p2[2])+$signed(convo_p2[3])+$signed(convo_p2[4])+
                $signed(convo_p2[5])+$signed(convo_p2[6])+$signed(convo_p2[7])+
                $signed(convo_p2[8]);
                convolution_state <= convolution_state + 1;
            end
            3'b010: begin
                convo_ans1[convo_time] <= (convo_sum1[7:0]>8'b10000000)?convo_sum1[11:4]+1:convo_sum1[11:4];
                convo_ans2[convo_time] <= (convo_sum2[7:0]>8'b10000000)?convo_sum2[11:4]+1:convo_sum2[11:4];
                convo_time <= convo_time + 1;
                convolution_state <= convolution_state + 1;
		//$display("addr: %d %d",write_addr,{convo_ans1[0],convo_ans1[1],convo_ans1[2],convo_ans1[3]});
            end
	    3'b011: begin
			convo_ans1[0] <= convo_ans1[0][7]?0:convo_ans1[0];
			convo_ans1[1] <= convo_ans1[1][7]?0:convo_ans1[1];
			convo_ans1[2] <= convo_ans1[2][7]?0:convo_ans1[2];
			convo_ans1[3] <= convo_ans1[3][7]?0:convo_ans1[3];
			convo_ans2[0] <= convo_ans2[0][7]?0:convo_ans2[0];
			convo_ans2[1] <= convo_ans2[1][7]?0:convo_ans2[1];
			convo_ans2[2] <= convo_ans2[2][7]?0:convo_ans2[2];
			convo_ans2[3] <= convo_ans2[3][7]?0:convo_ans2[3];
			convolution_state <= convolution_state + 1;
		end
            3'b100: begin
                if(convo_time == 4)begin
                    M1_R_req <= 1;
                    M1_W_data <= {convo_ans1[0],convo_ans1[1],convo_ans1[2],convo_ans1[3]};
                    M1_W_req <= 4'b1111;
                    M1_addr <= write_addr<<2;
                    M2_R_req <= 1;
                    M2_W_data <= {convo_ans2[0],convo_ans2[1],convo_ans2[2],convo_ans2[3]};
                    M2_W_req <= 4'b1111;
                    M2_addr <= write_addr<<2;
                    write_addr <= write_addr + 1;
		    convo_time <= 0;
		    //$display("addr: %d %d",write_addr,{convo_ans1[0],convo_ans1[1],convo_ans1[2],convo_ans1[3]});
                end
                global_state <= 3;
                convolution_state <= 0;
            end
            default: begin
		end
        endcase
    end else if(global_state == 3)begin
	//$display("enter state 3");
        if(write_addr == 169)begin
            // finsish
            finish <= 1;
        end else if(global_row_index == 28) begin // maybe wrong
            // take new row
            for(i = 0; i < 28; i = i +1)begin
                line_buffer1[i] <= line_buffer2[i];
                line_buffer2[i] <= line_buffer3[i];
            end
            global_row_index <= 3;
            global_state <= 4;
        end else begin
            // general case, just take three element
            global_state <= 5;
        end
    end else if(global_state == 4)begin
	//$display("enter state 4");
        if(line_buf_setting_time < 7)begin
            if(req_state)begin
                M0_R_req <= 1;
                M0_addr <= (row_addr_index*7 + line_buf_setting_time)<<2; // hi
                req_state <= 0;
            end else begin
                // data already
		#1;
                line_buffer3[line_buf_setting_time<<2] <= M0_R_data[31:24];
                line_buffer3[(line_buf_setting_time<<2)+1] <= M0_R_data[23:16];
                line_buffer3[(line_buf_setting_time<<2)+2] <= M0_R_data[15:8];
                line_buffer3[(line_buf_setting_time<<2)+3] <= M0_R_data[7:0];
                req_state <= 1;
                line_buf_setting_time <= line_buf_setting_time + 1;
            end
        end else begin
            line_buf_setting_time <= 0;
	    row_addr_index <= row_addr_index + 1;
            global_state <= 1;
        end       
    end else if(global_state == 5)begin
	//$display("enter state 5");
        window[0] <= window[1];
        window[1] <= window[2];
        window[3] <= window[4];
        window[4] <= window[5];
        window[6] <= window[7];
        window[7] <= window[8];
        window[2] <= line_buffer1[global_row_index];
        window[5] <= line_buffer2[global_row_index];
        window[8] <= line_buffer3[global_row_index];
        global_row_index <= global_row_index + 1;
        global_state <= 2;
    end
end

/*
always @(negedge clk) begin
	if(waiting_req&&((start == 1 && global_state == 0) || (global_state == 0 && running_flag == 1)))begin
		waiting_req <= 0;
	end else if((start == 1 && global_state == 0) || (global_state == 0 && running_flag == 1))begin
		waiting_req <= 1;
	        case (current_line)
	            2'b00:begin
	                if(line_buf_setting_time < 7)begin
	                    if(!req_state)begin
	                        line_buffer1[line_buf_setting_time<<2] <= M0_R_data[31:24];
	                        line_buffer1[(line_buf_setting_time<<2)+1] <= M0_R_data[23:16];
	                        line_buffer1[(line_buf_setting_time<<2)+2] <= M0_R_data[15:8];
	                        line_buffer1[(line_buf_setting_time<<2)+3] <= M0_R_data[7:0];
	                        req_state <= 1;
	                        line_buf_setting_time <= line_buf_setting_time + 1;
	                    end else begin
	                    line_buf_setting_time <= 0;
	                    current_line <= current_line + 1;
	                    end
                	end
            	     end
            	    2'b01:begin
            		    if(line_buf_setting_time < 7)begin
            		        if(!req_state)begin
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
           		         if(!req_state)begin
                        // data already
                        line_buffer3[line_buf_setting_time<<2] <= M0_R_data[31:24];
                        line_buffer3[(line_buf_setting_time<<2)+1] <= M0_R_data[23:16];
                        line_buffer3[(line_buf_setting_time<<2)+2] <= M0_R_data[15:8];
                        line_buffer3[(line_buf_setting_time<<2)+3] <= M0_R_data[7:0];
                        req_state <= 1;
                        line_buf_setting_time <= line_buf_setting_time + 1;
           		  	end 
			    end else begin
                    // three line buffer is initial complete
                    global_state <= 1;
                	end
           	 end 
            default: begin
		end
        endcase
	end

end
*/
endmodule
