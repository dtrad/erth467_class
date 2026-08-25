function [yy, bb] = contran(conj, sumFlag, nx, xx, nb, bb, yy)
%CONTRAN Convolution/correlation helper mirroring contran.cpp implementation.
%   [YY, BB] = CONTRAN(CONJ, SUMFLAG, NX, XX, NB, BB, YY) performs either
%   convolution (CONJ == 0) or correlation (CONJ ~= 0) between the NB-length
%   filter BB and the NX-length signal XX. SUMFLAG == 0 clears the destination
%   array before accumulation, matching the behavior of the original C code.
%
%   The routine follows the storage semantics of the C version: YY is written
%   when CONJ == 0 and BB is written when CONJ ~= 0, so both are returned.

    ny = nx + nb - 1;
    [bb, yy] = conjzero(conj, sumFlag, nb, bb, ny, yy);

    if conj == 0
        for ib = 1:nb
            for ix = 1:nx
                yy(ib + ix - 1) = yy(ib + ix - 1) + bb(ib) * xx(ix);
            end
        end
    else
        for ib = 1:nb
            for ix = 1:nx
                bb(ib) = bb(ib) + yy(ib + ix - 1) * xx(ix);
            end
        end
    end
end

function [x, y] = conjzero(conj, addFlag, nx, x, ny, y)
%CONJZERO Replicates the zeroing logic used by contran.cpp.
    if addFlag == 0
        if conj == 0
            y(1:ny) = 0;
        else
            x(1:nx) = 0;
        end
    end
end


