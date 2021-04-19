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

patientHRhashes = containers.Map();
patientMAPhashes = containers.Map();
masterHRwords = containers.Map();
masterMAPwords = containers.Map();
indexHR = 0;
indexMAP = 0;

%%%%%%%%%%%%%%%%%% HERE ARE THE PARAMETERS YOU NEED TO CHANGE %%%%%%%%%%%%%%%%%%%%
sliding_window = 120;
num_symbols = 30;
alphabet_size = 8; 
NR_opt_SAX = 2;
NR_opt_BOP = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
   
    e = cputime - t;
    disp(num2str(e)); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t = cputime;
    [symbolic_data_HR] = timeseries2symbol(HR,sliding_window,num_symbols,alphabet_size,NR_opt_SAX);
    [symbolic_data_MAP] = timeseries2symbol(MAP,sliding_window,num_symbols,alphabet_size, NR_opt_SAX);
    
    e = cputime - t;
    disp(num2str(e));  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t = cputime;
    
    % hash representation of hr and map
    [hrHash, indexHR] = create_BOP_hash(symbolic_data_HR, masterHRwords, indexHR);
    [mapHash, indexMAP] = create_BOP_hash(symbolic_data_MAP, masterMAPwords, indexMAP);

    % add to associative array of hashes
    patientHRhashes(num2str(patientID)) = hrHash;
    patientMAPhashes(num2str(patientID)) = mapHash;
   
     e = cputime - t;
    disp(num2str(e));  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
stackWidth = indexHR + indexMAP;
patientVectors = zeros(numPatients,stackWidth);

e = cputime - t;
disp(num2str(e));

 for i = 1: numPatients
     patientID = num2str(RECORDS(i)); 
    
     
    patientHRhash = patientHRhashes(patientID);
    patientMAPhash = patientMAPhashes(patientID);
    
     hrKeys = patientHRhash.keys();
     mapKeys = patientMAPhash.keys();
    
    disp(patientID);
    for j = 1: size(hrKeys,2)
        idx = masterHRwords(char(hrKeys(j)));
        patientVectors(i,idx) = patientHRhash(char(hrKeys(j)));
        
    end
    
    disp(patientID);
    for j = 1: size(mapKeys,2)
        idx = masterMAPwords(char(mapKeys(j)));
        patientVectors(i,idx + indexHR) = patientMAPhash(char(mapKeys(j)));
        
    end
    
    
    
 end
 dlmwrite('patientVectors.csv',patientVectors);
    
