function [x_q,centers,D,zone_limits] = LloydMax(x,N,min,max)
   no_of_lvls = 2^N;        %number of levels
   step = (max-min)/no_of_lvls;     %initial step
   min_for = min;
   centers = zeros(no_of_lvls,1);       %vector to store the quantization levels
   D = zeros(100,1);                            %vector to store the average deformation in each iteration
   zone_limits = zeros(no_of_lvls+1,1);         %vector to store the limits of every zone
   zone_limits(1,1) = min;      %initializes the first zone's first limit
   zone_limits(5,1) = max;     %initializes the last zone's second limit 
   exp = zeros(no_of_lvls,1);       %vector to keep track of the sum of all points inside each zone
   exp_counter = zeros(no_of_lvls,1);       %keeps track of the number of points in each zone
   e = 0; 
   x_q = zeros(length(x),1);  %quantized signal
   iterations = 5;          %number of iterations
   sqnr = zeros(iterations,1);      %vector to store the value of SQNR in each iteration
   sp = zeros(iterations,1);           %vector to store the signal power in each iteration
   sn = zeros(iterations,1);            %vector to store the noise power in each iteration

   for i = 1:no_of_lvls
       centers(i,1) =  (min_for + step)/2;     %calculates first levels of quantization
       min_for = min_for+step;
   end

   
for i = 1:iterations

   for j=1:no_of_lvls-1
       zone_limits(j+1,1) = (centers(j,1) + centers(j+1,1))/2;  %calculates zone limits
   end
    
   for k=1:length(x)        %checks for every point of the signal on which zone it belongs in order to round it to the corresponding quantization level
       limiter1 = 0;
       for r = 1:no_of_lvls
           limiter1 = limiter1 + 1;
           if(x(k,1) > zone_limits(r,1) && x(k,1) < zone_limits(r+1,1))
               x_q(k,1) = centers(r,1);
           elseif(x(k,1) == zone_limits(r,1))       %if a point is exactly at the first limit of a zone then it gets rounded to that zone
               x_q(k,1) = centers(r,1);
           elseif(x(k,1) == zone_limits(r+1,1))     %if a point is exactly on the second limit of a zxone then it gets rounded to the next zone
               if (limiter1 < no_of_lvls)
                    x_q(k,1) = centers(r+1,1);
               else
                    x_q(k,1) = centers(r,1);
               end
           end
       end
   end

   for t = 1:length(x)
       limiter2 = 0;
       for c = 1:no_of_lvls
            limiter2 = limiter2 + 1;
            if(x(t,1) > zone_limits(c,1) && x(t,1) < zone_limits(c+1,1))
                exp(c,1) = exp(c,1) + x(t,1);
                exp_counter(c,1) = exp_counter(c,1) + 1;
            elseif(x(t,1) == zone_limits(c,1))
                exp(c,1) = exp(c,1) + x(t,1);
                exp_counter(c,1) = exp_counter(c,1) + 1;
            elseif(x(t,1) == zone_limits(c+1,1))
                if(limiter2 < no_of_lvls)
                    exp(c+1,1) = exp(c+1,1) + x(t,1);
                    exp_counter(c+1,1) = exp_counter(c+1,1) + 1;
                else 
                    exp(c,1) = exp(c,1) + x(t,1);
                    exp_counter(c,1) = exp_counter(c,1) + 1;
                end
            end
       end
   end
   
    
    %calculate new levels
    for k=1:length(exp)
        centers(k,1) = exp(k,1)/exp_counter(k,1);
    end
    
    %calculates the deformation using the mean square error
    D(i,1) = immse(x,x_q);
    if(i > 1)
        %calculates the difference of the current iteration's deformation
        %from the previous iteration's deformation
        e = abs(D(i,1) - D(i-1,1));
    end

    %resets the sum variable and counter of points in each zone
    for o=1:no_of_lvls
          exp(o,1) = 0;
          exp_counter(o,1) = 0;
    end
    
    sp(i) = bandpower(x_q);     %calculates the power of the signal in each iteration
    sn(i) = max^2/(3*(4^N));    %calculates the power of the quantization noise in each iteration
    sqnr(i) = 10*log10(sp(i)/sn(i));        %calculates the sqnr in dB

end

entropy1 = entropy(x_q);        %calculates entropy at the output of the quantizer

% disp("The entropy at the output of the quantizer for PCM is " + entropy1);
% stairs(sqnr);
% xlabel("Iteration");
% ylabel("SQNR(dB)");
disp("The deformation in the last iteration is " + D(iterations,1));
% disp("The e is " + e);