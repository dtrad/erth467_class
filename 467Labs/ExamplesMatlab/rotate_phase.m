function w_rotated = rotate_phase(w, phi_deg)
%ROTATE_PHASE Apply constant phase rotation to a wavelet
%   w         : input wavelet (real or complex)
%   phi_deg   : phase rotation angle in degrees
%   w_rotated : output wavelet with rotated phase

    phi = deg2rad(phi_deg);         % convert to radians
    W = fft(w);                     % FFT to frequency domain
    W_rot = W .* exp(1i * phi);     % apply rotation
    w_rotated = real(ifft(W_rot)); % back to time domain, keep real part
end

