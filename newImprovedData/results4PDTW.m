% In order for this script to work the matrix that you want to convert must
% be stored in patientVectors with one BOP representation per row (patient)


%Please update the following line wiht the vars you are using and the
%methods like 'HR-MAP Stacked', 'HR-MAP Multi' or 'HR-MAP PDTW'
testing ='HR-MAP PDTW'; 

%Please enter YOUR name
yourName = 'ZPattiO';

%please enter a nickname for the data set you are using like 'robotMoving',
%'robotStationary', 'pamap','cmuMocap', 'pda','hypotension'
dataset = 'hypotension';


neighbors1 = [(1:58)',match];
disp('PDTW');
[result1,acc1,pre1,rec1,f1] = resultsForHypoNeighborsPR(neighbors1);
display(horzcat('acc->', num2str(acc1),' pre->',num2str(pre1),' rec->',num2str(rec1),' f->',num2str(f1)));

fileID = fopen(horzcat(yourName,'_',dataset, '_results.csv'),'a');

results = [compressionRatio ,0,0,0, acc1, pre1,rec1,f1];


fprintf(fileID,'%s, %i, %i, %i, %i, %5.3f, %5.3f, %5.3f, %5.3f\n', horzcat(testing , ' Acc'), results);


fclose(fileID);

fileID2 = fopen(horzcat(yourName,'_', dataset,'_data.csv'),'a');
fprintf(fileID2,'%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', testing ,compressionRatio,0,0,0, result1);

fclose (fileID2);