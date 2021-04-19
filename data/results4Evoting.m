% In order for this script to work the matrix that you want to convert must
% be stored in patientVectors with one BOP representation per row (patient)
hrIndex = 30;

%Please update the following line wiht the vars you are using and the
%methods like 'HR-MAP Stacked', 'HR-MAP Multi' or 'HR-MAP PDTW'
testing ='HR-MAP Evote'; 

%Please enter YOUR name
yourName = 'ZPattiO';

%please enter a nickname for the data set you are using like 'robotMoving',
%'robotStationary', 'pamap','cmuMocap', 'pda','hypotension'
dataset = 'hypotension';

hrMatrix = patientVectors(:,1:hrIndex);
mapMatrix = patientVectors(:,hrIndex + 1 :end);
disp('Evoting');

predictedClasses = zeros(numPatients, num_params);
finalPrediction = inf(numPatients, 1);
actual = zeros(numPatients,1);

[neighbors1 dist1]= nearestNeighbor(hrMatrix);
[neighbors2 dist2]= nearestNeighbor(mapMatrix);

neighbors = [neighbors1, neighbors2];
dist = [dist1,dist2];


for i = 1:numPatients
    actual(i) = isHypo(i);
    for j = 1:num_params
       
        predictedClasses(i, j) = isHypo(neighbors(i,j));
    end
    % here is the voting if there is a tie then predict that isHypo
    prediction = sum(predictedClasses(i,:));
    if (prediction > num_params/2)
        finalPrediction(i) = 1;
    else
        finalPrediction(i) = 0;
    end
    
end
resultMatrix = [actual,finalPrediction];
% calculating accuracy, precision, recal and f measure

[result1,acc1,pre1,rec1,f1] = resultsForParallelVectors(resultMatrix); 

results = [ sliding_window, num_symbols, alphabet_size,NR_opt_SAX, acc1, pre1, rec1, f1];

display(horzcat('acc->', num2str(acc1),' pre->',num2str(pre1),' rec->',num2str(rec1),' f->',num2str(f1)));

fileID = fopen(horzcat(yourName,'_',dataset, '_results.csv'),'a');
fprintf(fileID,'%s, %i, %i, %i, %i, %5.3f, %5.3f, %5.3f, %5.3f\n', horzcat(testing , ' Acc'), results);
fclose(fileID);

fileID2 = fopen(horzcat(yourName,'_', dataset,'_data.csv'),'a');
fprintf(fileID2,'%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', testing, sliding_window, num_symbols, alphabet_size,NR_opt_SAX, result1);
fclose (fileID2);