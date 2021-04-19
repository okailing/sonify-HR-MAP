% I use leave-one-out validation to calculate the nearest neighbor.  If the
% matrix is size m x n then m is the number of instances and n is the
% number of features.
% Output m x 1 vector of nearest neighbor and m x 1 vector of closest
% distance
function [neighbor dist] = nearestNeighbor(matrix)

    r = size(matrix,1);
    neighbor = zeros(r,1);
    dist = inf(r,1);
    distMatrix = zeros(r); % create r x r matrix
    for i = 1 : r
        for j = i + 1 : r
            
            a = matrix(i,:);
            b = matrix(j,:);
            distMatrix(i,j) = sqrt( sum((a-b).*(a-b)) );
            %comparing to all the ones after the node in the first pass...
            if (distMatrix(i,j) < dist(i))
                dist(i) = distMatrix(i,j);
                neighbor(i) = j;
            end
        end
    end
    % comparing to all the previous nodes in the second pass
    for j = r : -1 : 2
       
        for i = j - 1 : -1 : 1
            
            if(distMatrix(i,j) <dist(j))
                dist(j) = distMatrix(i,j);
                neighbor(j) = i;
            end
        end
       
    end
    neighbor = [(1:r)',neighbor];
    
end