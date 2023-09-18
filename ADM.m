function[y_q,y_b,steps] = ADM(y)
K = 1.5;
y_q = zeros(length(y),1); %declare matrix for quantized signal
y_b = zeros(length(y),1); %declare matrix for bit sequence of quantized signal
steps = zeros(length(y),1); %declare matrix to store the steps
steps(1) = 0.02; %initialize first step
y_q(1) = steps(1,1);%initialize first point of quantized signal to begin comparing
y_b(1) = 1;%initialize first bit of sequence to begin comparing
track = steps(1);%variable to keep track of the sum of the step sizes
for i = 2:length(y)
%compares the values of the original signal with the sum of
%the step sizes to either set the current bit of the sequence to 1 or 0
if(y(i) >= track)
y_b(i) = 1;
%compares the previous bit in the sequence with the current one to either scale%or down the step size
if(y_b(i) == y_b(i-1))
steps(i) = steps(i-1)*K; %scales up the step size by multiplying
y_q(i,1) = track; %the previous step by K
track = track + steps(i);
else
steps(i) = steps(i-1)/K; %scales down the step size by dividing
y_q(i,1) = track; %this time with K
track = track + steps(i);
end
else
y_b(i) = -1;
if(y_b(i) == y_b(i-1))
steps(i) = steps(i-1)*K;
y_q(i,1) = track;
track = track - steps(i);
else
steps(i) = steps(i-1)/K;
y_q(i,1) = track;
track = track - steps(i);
end
end
end
sp = mean(y_q.^2); %calculates the power of the quantized signal
np = mean((y_q-y).^2); %calculates the power of quantization noise
sqnr = 10*log10(sp/np); %calculates SQNR in dB
en = entropy(y_q); %calculates entropy at the output of the quantizer
disp("The entropy at the output of the quantizer for ADM is " + en);
disp("The sqnr of ADM is " + sqnr);