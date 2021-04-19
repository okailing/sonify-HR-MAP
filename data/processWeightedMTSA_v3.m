% This file is a script to process the files in this directory and create a
% multivariate frequency matrix for all the files in this directory
% patients numbers loaded through RECORDS and the parameters are
% hard-coded in here which are HR and MAP… The MTSA representations are the
% words and then we create the histogram of the words using the function
% createBOP4MTSA... this is different from the createBOP method in that you
% have an extra parameter so that you can change the numerosity reduction
% if you like, in NR_opt_BOP, the default is no numerosity reduction and
% has a value of 1.
% you must call results4ITIDFP to get the results


load RECORDS; %note to self.... load will only work on text files that contain numbers only

patientMatrix = [];
patientVectors = [];


sliding_window = 120;
num_symbols = 3;
alphabet_size = 20; 
NR_opt_SAX = 1;
NR_opt_BOP = 1;

% must match the number of parameters that you are going to use
num_params = 2;

for i = 1: size(RECORDS)
    patientID = RECORDS(i);  
   
    %creating the filenames
    HRfilename = strcat('HR_a',num2str(patientID),'_1.dat');
    MAPfilename = strcat('MAP_a',num2str(patientID),'_1.dat');

    
    % Here we are using Jessica's algorithm with no numerosity reduction
    % because otherwise the vectors would not all be of the same size
    disp(strcat('patient a',num2str(patientID),'-',num2str(i)));
    t = cputime;
    HR = load(HRfilename);
    MAP = load(MAPfilename);
   
    e = cputime - t;
    disp(num2str(e));
    t = cputime;
    [symbolic_data_HR] = timeseries2symbol(HR,sliding_window,num_symbols,alphabet_size,NR_opt_SAX);
    [symbolic_data_MAP] = timeseries2symbol(MAP,sliding_window,num_symbols,alphabet_size, NR_opt_SAX);
    
    e = cputime - t;
    disp(num2str(e));
    t = cputime;
    
    
    %flatten the arrays
    symbolic_data_HR = reshape(symbolic_data_HR', 1, numel(symbolic_data_HR));
    symbolic_data_MAP = reshape(symbolic_data_MAP', 1, numel(symbolic_data_MAP));
    % because the sax symbols are one per row... it's not as easy to do
    % this...
    
    
    
    
    % two-dimensional vector of the SAX representation of each patient
    patientMatrix = [symbolic_data_HR;symbolic_data_MAP];
    
    %transpose the vector so that every row is an MTSA
    patientMatrix = patientMatrix';
    
   
    % call the createBOP method to use Jessica's algorithm, the number of
    % parameters is the number of segments in this case 
    [BOP] = create_BOP4MTSA(patientMatrix, num_params, alphabet_size, NR_opt_BOP);
    
    
    %add vector to matrix of all patients
    patientVectors(i,:) = BOP;
    e = cputime - t;
    disp(num2str(e));
end;


