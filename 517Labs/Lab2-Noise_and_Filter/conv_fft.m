function [out] = conv_fft(a, b)

    if size(a) ~= size(b)
        b = b';
    end
    
    total_len = length(a) + length(b) - 1;
    tempa = fft(a, total_len);
    tempb = fft(b, total_len);
    
    temp = tempa .* tempb;
    
    if (any(any(imag(temp))))
        out = ifft(temp);
    else
        out = real(ifft(temp));
    end
end

