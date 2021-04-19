% This file is a script to process the files in this directory and create a
% multivariate distance matrix between all the instances.  The distance
% metric is Multivaraite Piecewise Dynamic Time Warping.
% You must call results4PDTW to get the results


load RECORDS; %note to self.... load will only work on text files that contain numbers only

% The only parameter for PDTW pertains to PAA.  It is the compression
% ration and is equivalent to the ratio of the length of the time series
% (N) divided by the number of segments (n) or N/n

compressionRatio = 50; %%%%%%%%%%%%%%change this value to see if you can improve accuracy and precision...

% must match the number of parameters that you are going to use
num_params = 2;

numPatients = size(RECORDS,1);

for i = 1: numPatients
    patientID = RECORDS(i);  
   
    %creating the filenames
    HRfilename = strcat('HR_a',num2str(patientID),'_1.dat');
    MAPfilename = strcat('MAP_a',num2str(patientID),'_1.dat');

    
    % Here we are using Jessica's algorithm with no numerosity reduction
    % because otherwise the vectors would not all be of the same size
    disp(strcat('patient a',num2str(patientID),'-',num2str(i))); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t = cputime;
    HR = load(HRfilename);
    MAP = load(MAPfilename);
   
    myArray{i} = [HR,MAP]';
   
     e = cputime - t;
    disp(num2str(e));  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

disp('beginning the distances');
patientVectors = zeros(numPatients);
minVal = inf(numPatients,1);
match = zeros(numPatients,1);
t = cputime;
for i = 1: numPatients
    disp(num2str(i));
    t = cputime;
    for j = i + 1: numPatients
       if(patientVectors(i,j) == 0) 
           patientVectors(i,j)= multiPDTW(myArray{i},myArray{j}, compressionRatio);

           if (patientVectors(i,j) < minVal(i))
                minVal(i) = patientVectors(i,j);
                match(i) = j;
               
           end
           
       end
  
        
    end
    


    e = cputime - t;
    disp(num2str(e));
    
end

% for i = 1:(numPatients -1)
%     if(patientVectors(i, numPatients) < minVal(numPatients))
%         minVal(numPatients) = patientVectors(i,numPatients);
%         match(numPatients) = i;
%     end
% end
% Here is the vectorized implementation of the last loop in one line
[minVal(numPatients), match(numPatients)] = min(patientVectors(1:(numPatients -1),numPatients));


e = cputime - t;
disp(num2str(e));
% dlmwrite('patientVectors.csv',patientVectors);

    
