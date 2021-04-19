% This function assumes that every row in the matrix is a variable and that
% varies along the columns thus if multiSeries1 is r x m then r is the
% number of variables and m is the values over time and then multiSeries2
% would be r x n. compRatio is the compression ratio for the PAA
% representation and is equal to the length of the time series (length) divided
% by the number of segments in the representation (segs). In other words,
% compRatio = length/segs

function [warpdist,matrix] = multiPDTW(multiSeries1, multiSeries2,compRatio)

    m = size(multiSeries1, 2);
    n = size(multiSeries2, 2);
    
    M = floor(m/compRatio);
    N = floor(n/compRatio);
    
    Q = convert2PAAmulti(multiSeries1, compRatio);
    C = convert2PAAmulti(multiSeries2, compRatio);
    
    matrix = zeros(M, N);
    
    for i = 1 : M
        for j = 1 : N
            
            if ( i == 1 && j == 1)
                matrix(i,j) = multiDistPAA(Q(:, i), C(:, j));
                continue;
            end
            if (i == 1)
               
                matrix(i,j) = multiDistPAA(Q(:, i), C(:, j))  + matrix(i, j - 1);
              
              %  disp(strcat(num2str(i),',', num2str(j)));
              %  disp( num2str(multiDist(multiSeries1(:, i), multiSeries2(:, j))));
              %  disp( num2str(matrix(i,j - 1)));
                continue;
            end
            if (j == 1)
                
                    matrix(i,j) = multiDistPAA(Q(:, i), C(:, j)) + matrix(i - 1, j);
                
                continue;
            end
            matrix(i,j) = multiDistPAA(Q(:, i), C(:, j)) + minimumVal(matrix(i,j - 1),matrix(i - 1,j), matrix(i - 1,j - 1));  

        end
    end
 
    warpdist = matrix(M,N)/sqrt(compRatio);
end

function [val] = minimumVal(dist1, dist2, dist3)
   
   val1 = min(dist1,dist2);
   val2 = min(dist1,dist3);
   val = min(val1, val2);
   
   
end
function [val] = multiDistPAA(column1, column2)
    val = sum((column1 - column2).^2);
end 