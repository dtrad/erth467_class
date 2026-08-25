function w = conv_467(u, v)
%     w = zeros(1, length(u) + length(v) - 1);
%     for j = 1:length(v)
%         for k = 1:length(u)
%             w(1, j + k - 1) = w(1, j + k - 1) + v(j) * u(k);
%         end
%     end

% u(j - k): past kth element of u
% v(k): kth element of v
% w(j - 1): current element
    w = zeros(1, length(u) + length(v) - 1);
    for j = 2:length(w)
        for k = max(1, j-length(u)):min(j-1, length(v))
            w(1, j - 1) = w(1, j - 1) + v(k) * u(j - k);
        end
    end
end
