% In order for this script to work the matrix that you want to convert must
% be stored in patientVectors with one BOP representation per row (patient)


%Please update the following line wiht the vars you are using and the
%methods like 'HR-MAP Stacked', 'HR-MAP Multi' 
testing ='HR-MAP Stacked'; 

%Please enter YOUR name
yourName = 'ZPattiO';

%please enter a nickname for the data set you are using like 'robotMoving',
%'robotStationary', 'pamap','cmuMocap', 'pda','hypotension'
dataset = 'hypotension';

[w_TF, w_TFIDF, w_TFIF, w_TFIDFIF, w_TFIDFP] = weighted_TF_IDF_P(patientVectors);
[neighbors1 dist] = kNearestNeighbors(patientVectors, patientVectors,2);
disp('BOP');
[result1,acc1,pre1,rec1,f1] = resultsForHypoNeighborsPR(neighbors1);
display(horzcat('acc->', num2str(acc1),' pre->',num2str(pre1),' rec->',num2str(rec1),' f->',num2str(f1)));
[neighbors2 dist] = kNearestNeighbors(w_TF, w_TF,2);
disp('TF');
[result2,acc2,pre2,rec2,f2] = resultsForHypoNeighborsPR(neighbors2);
display(horzcat('acc->', num2str(acc2),' pre->',num2str(pre2),' rec->',num2str(rec2),' f->',num2str(f2)));
[neighbors3 dist] = kNearestNeighbors(w_TFIDF, w_TFIDF,2);
disp('TFIDF');
[result3,acc3,pre3,rec3,f3] = resultsForHypoNeighborsPR(neighbors3);
display(horzcat('acc->', num2str(acc3),' pre->',num2str(pre3),' rec->',num2str(rec3),' f->',num2str(f3)));
[neighbors4 dist] = kNearestNeighbors(w_TFIDFIF, w_TFIDFIF,2);
disp('TFIDFIF');
[result4,acc4,pre4,rec4,f4] = resultsForHypoNeighborsPR(neighbors4);
display(horzcat('acc->', num2str(acc4),' pre->',num2str(pre4),' rec->',num2str(rec4),' f->',num2str(f4)));
[neighbors5 dist] = kNearestNeighbors(w_TFIF, w_TFIF,2);
disp('TFIF');
[result5,acc5,pre5,rec5,f5] = resultsForHypoNeighborsPR(neighbors5);
display(horzcat('acc->', num2str(acc5),' pre->',num2str(pre5),' rec->',num2str(rec5),' f->',num2str(f5)));
[neighbors6 dist] = kNearestNeighbors(w_TFIDFP, w_TFIDFP,2);
disp('TFP');
[result6,acc6,pre6,rec6,f6] = resultsForHypoNeighborsPR(neighbors6);
display(horzcat('acc->', num2str(acc6),' pre->',num2str(pre6),' rec->',num2str(rec6),' f->',num2str(f6)));

fileID = fopen(horzcat(yourName,'_',dataset, '_results.csv'),'a');

resultsAcc = [ sliding_window, num_symbols, alphabet_size,NR_opt_SAX, acc1, acc2, acc3, acc4, acc5, acc6];
resultsPre = [ sliding_window, num_symbols, alphabet_size,NR_opt_SAX, pre1, pre2, pre3, pre4, pre5, pre6];
resultsRec = [ sliding_window, num_symbols, alphabet_size, NR_opt_SAX,rec1, rec2, rec3, rec4, rec5, rec6];
resultsF = [ sliding_window, num_symbols, alphabet_size,NR_opt_SAX, f1, f2, f3, f4, f5, f6];

fprintf(fileID,'%s, %i, %i, %i, %i, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f\n', horzcat(testing , ' Acc'), resultsAcc);
fprintf(fileID,'%s, %i, %i, %i, %i, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f\n',horzcat(testing , ' Pre'), resultsPre);
fprintf(fileID,'%s, %i, %i, %i, %i, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f\n',horzcat(testing , ' Rec'), resultsRec);
fprintf(fileID,'%s, %i, %i, %i, %i, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f\n',horzcat(testing , ' F'), resultsF);

fclose(fileID);

fileID2 = fopen(horzcat(yourName,'_', dataset,'_data.csv'),'a');
fprintf(fileID2,'%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', horzcat(testing , ' BoP'),sliding_window, num_symbols, alphabet_size,NR_opt_SAX, result1);
fprintf(fileID2,'%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', horzcat(testing , ' TF'),sliding_window, num_symbols, alphabet_size,NR_opt_SAX, result2);
fprintf(fileID2,'%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', horzcat(testing , ' TFIDF'),sliding_window, num_symbols, alphabet_size,NR_opt_SAX, result3);
fprintf(fileID2,'%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', horzcat(testing , ' TFIDFIF'),sliding_window, num_symbols, alphabet_size,NR_opt_SAX, result4);
fprintf(fileID2,'%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', horzcat(testing , ' TFIF'),sliding_window, num_symbols, alphabet_size,NR_opt_SAX, result5);
fprintf(fileID2,'%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i,%i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i\n', horzcat(testing , ' TFP'),sliding_window, num_symbols, alphabet_size,NR_opt_SAX, result6);
fclose (fileID2);