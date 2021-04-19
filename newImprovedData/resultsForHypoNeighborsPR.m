function [resultVector,acc, prec, rec, f] = resultsForHypoNeighborsPR(neighbors)
    [rows, cols] = size(neighbors);

    resultVector = [];
    acc = 0;
    prec = 0;
    rec = 0;
    truePos = 0;
    trueNeg = 0;
    falsePos = 0;
    falseNeg = 0;
    %left is the actual class and right is its nearest neighbor and thus its
    %prediction

    for i = 1:rows
        left = isHypo(neighbors(i,1));
        right = isHypo(neighbors(i,2));
        result = left == right;
        resultVector = [resultVector;result];
        if(left == right)
            acc = acc +1;
            if(right == 1)
                truePos = truePos + 1;

            else
                trueNeg = trueNeg + 1;
            end
        else
            if(right == 1)
                falsePos = falsePos + 1;
            else
                falseNeg = falseNeg + 1;
            end
        end

    end
    acc = acc/rows;
    prec = truePos / (truePos + falsePos);
    rec = truePos / (truePos + falseNeg);
    f = 2*((prec * rec)/(prec + rec));
end


