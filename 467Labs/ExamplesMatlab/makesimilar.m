function [aOut, bOut] = makesimilar(aIn, bIn)
%MAKESIMILAR Align two vectors by orientation and length.
%   [A, B] = MAKESIMILAR(A, B) returns copies of the input vectors that share
%   the same orientation (row or column) and length. The function transposes
%   the second vector if necessary and zero-pads the shorter vector so the
%   outputs are comparable.
%
%   Inputs must be vectors; otherwise an error is thrown.

    if ~isvector(aIn) || ~isvector(bIn)
        error('makesimilar:InputMustBeVector', ...
            'Both inputs to makesimilar must be vectors.');
    end

    targetIsRow = isrow(aIn);

    if targetIsRow
        aOut = aIn(:).';
        bOut = bIn(:).';
    else
        aOut = aIn(:);
        bOut = bIn(:);
    end

    lenA = numel(aOut);
    lenB = numel(bOut);

    if lenA < lenB
        padSize = lenB - lenA;
        if targetIsRow
            aOut = [aOut zeros(1, padSize, 'like', aOut)];
        else
            aOut = [aOut; zeros(padSize, 1, 'like', aOut)];
        end
    elseif lenB < lenA
        padSize = lenA - lenB;
        if targetIsRow
            bOut = [bOut zeros(1, padSize, 'like', bOut)];
        else
            bOut = [bOut; zeros(padSize, 1, 'like', bOut)];
        end
    end
end
