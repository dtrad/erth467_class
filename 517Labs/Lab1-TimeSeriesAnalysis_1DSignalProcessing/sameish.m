function [ flag , value ] = sameish( A , B , thresh )
%SAMEISH - Check if arrays A and B are numerically similar
%
% Input arguments:
% A,B   - numeric arrays of equal size
% thresh- optional relative tolerance (default 1e-14)
%
% Output arguments:
% flag  - 1 if arrays considered the same, 0 otherwise
% value - normalized difference metric or 'All zeros'

% Ensure inputs have equal size
if (size(A) ~= size(B))
    error('Mismatched sizes');
end

% Compute elementwise magnitudes and differences
maxA = abs(A);
maxB = abs(B);
max_diff = abs(A-B);
max_sum = abs(A+B);

% Reduce arrays to their global maxima across dimensions
for n = 1:ndims(A)
    maxA = max(maxA);
    maxB = max(maxB);
    max_diff = max(max_diff);
    max_sum = max(max_sum);
end

% If both are entirely zero, short-circuit with special value
if (maxA == 0 ) && (maxB == 0)
    flag = 1;
    value = 'All zeros';
else
    value = max_diff/max_sum;
    
    % Set default tolerance when not provided
    if nargin<3
        thresh = 1e-14;
    end
    
    if value < thresh
        flag = 1;
    else
        flag = 0;
    end
    
end



% if (max(max(abs(A))) == 0 ) && (max(max(abs(B))) == 0)
%     flag = 1;
%     value = 'All zeros';
% else
%     value = max(max(abs(A-B)))/(max(max(abs(A+B))));
%     
%     if nargin<3
%         thresh = 1e-14;
%     end
%     
%     if value < thresh
%         flag = 1;
%     else
%         flag = 0;
%     end
%     
% end