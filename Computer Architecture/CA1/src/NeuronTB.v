module NeuronTB;
  reg signed [6:0] x1Input, x2Input;
  reg signed [1:0] tInput;
  reg clk = 1'b1, start = 1'b0;
  integer n = 0, i;
  reg [31:0] nInput;
  wire signed [13:0] w1, w2, b;
  wire done, requestFlag;
  reg dataReady = 0, rst;

  Neuron N(clk, rst, start, nInput, x1Input, x2Input, tInput, dataReady, requestFlag, done, w1, w2, b);

  reg signed [6:0] X1Inputs[500:0];
  reg signed [6:0] X2Inputs[500:0];
  reg signed [1:0] tInputs[500:0];
  reg signed [6:0] capturedX1, capturedX2;
  reg signed [1:0] capturedt;
  integer file;
  // setting clock to pulse every 100ns
  initial repeat(50000000) begin
    #50
    clk = ~clk ;
  end

  initial begin
    file = $fopen("data_set.txt", "r");
    while(!$feof(file)) begin
      $fscanf(file, "%b %b %b", capturedX1, capturedX2, capturedt);
      X1Inputs[n] <= capturedX1;
      X2Inputs[n] <= capturedX2;
      tInputs[n] <= capturedt;
      n = n + 1;
    end
    nInput <= n[31:0];
  end


  initial begin
    rst <= 1'b1;
    #200
    rst <= 1'b0;
    start <= 1'b1;
    #200
    start <= 1'b0;
    while(!done) begin
        i = 0;
        while(i<n && !done) begin

          if(requestFlag) begin
            x1Input <= X1Inputs[i];
            x2Input <= X2Inputs[i];
            tInput <= tInputs[i];
            i = i + 1;
            dataReady <= 1'b1;
            while(requestFlag)
              #200;
          end

          dataReady <= 1'b0;
          #200;

        end
    end
    $display("finish :D");
    $display("W1: %b, W2: %b, B: %b", w1, w2, b);
    $stop;
  end

endmodule
