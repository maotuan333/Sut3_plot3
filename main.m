
% main pipeline of analysis

% misc processing
clear
opengl('save', 'software');
%parentDir ='D:\selina';
parentDir ='D:\333_Galaxy Maotuan\I love studying\2022 winter\lab\papers';
addpathPath = [parentDir '\2022-1-1\Selina'];
addpath addpathPath
%%%%%%%%%%%%%%%%%%

%% get a test file
%i=1;j=1;
%load([parentDir '\2022-2-18\Sut3_data\Sut3_191123_001002003_Suite2p_dffxDayAdjusted.mat']);

%% get list of data
files = dir('Sut3_data/Sut3_*_Suite2p_dffxDayAdjusted.mat');

%% config
load('visual drivenness.mat');
folder = [parentDir '\2022-5-1'];

%% test
%visstimTrace = suite2pData.nidaqAligned.visstim_on;
%visstimTrace(1:6700) = visstimTrace(6701:13400);
% corrval
% active orientations


%% global information
nameOfRuns = {'B005'; 'B04'; 'B12'; 'B24'; 'B48'; 'B72'; 'B96'; ...
              'S005'; 'S04'; 'S12'; 'S24'; 'S48'; 'S72'; 'S96'; ...
              'U005'; 'U04'; 'U12'; 'U24'; 'U48'; 'U72'; 'U96'; 'U120'; 'U144'; 'U168'; ...
              'R005'; 'R04'; 'R12'; 'R24'; 'R48';};


list=[1:29];%10:14 
%%
for ii=1:length(list)%length(files)
    i=list(ii);
    
    % vary condition for skipping files
    skip = 0;%isfile([files(i).folder '/popmetrics/' files(i).name '_crosscor.png']);
    if(skip)
    	continue;
    end
    
    % load current file
    disp(['file' num2str(i)]);
    load([files(i).folder '/' files(i).name]);
    
    %%% analysis by file
   
   plots3(folder,num2str(i),nameOfRuns{i},suite2pData);

end
    
    % analysis by session

 
