
% main pipeline of analysis

% misc processing
clear
opengl('save', 'software');
addpath 'D:\selina\2022-1-1\Selina'
%%%%%%%%%%%%%%%%%%

%% get a test file
%ii=1;jj=1;
%load('D:\selina\2022-2-18\Sut3_data/Sut3_191123_001002003_Suite2p_dffxDayAdjusted.mat');

%% get list of data
files = dir('Sut3_data/Sut3_*_Suite2p_dffxDayAdjusted.mat');

%% config
load('visual drivenness.mat');
folder = 'D:\selina\2022-5-1';

%% test
%visstimTrace = suite2pData.nidaqAligned.visstim_on;
%visstimTrace(1:6700) = visstimTrace(6701:13400);
% corrval
% active orientations

list=[16:24];%10:14 
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
    
    % directory building

    dir=[folder '/' num2str(i)];mkdir(dir);
    dirSubs{1}=[dir '/sample_traces'];
    dirSubs{2}=[dir '/heatmap'];
    dirSubs{3}=[dir '/average_response'];
    for j=1:length(dirSubs)
        mkdir(dirSubs{j});
    end
    
   % analysis
   [oriStr,visDrivenIDX,statsp,traces,visstimTrace,trial,numTrials,lim] = plot_0_get_stats(suite2pData);
   
   
   plot_1_sample_traces(dirSubs{1},oriStr,visDrivenIDX,statsp,traces,visstimTrace,lim);
   %this need ot go faster
   
   
   
   trialOnsets=suite2pData.Stim.trialonsets;
   trialOffsets=suite2pData.Stim.trialoffsets;
   freq=suite2pData.ops.fs;
   
       oriTrace=suite2pData.Stim.oriTrace;
   %plot_2_heatmap(dirSubs{2},traces,freq,trial,trialOnsets,trialOffsets,visDrivenIDX,oriTrace,oriStr,lim,statsp);
   
   
   
   %plot_3_average_response(dirSubs{3},traces,freq,trial,trialOnsets,trialOffsets,visDrivenIDX,oriTrace,oriStr,lim,statsp);
   

end
    
    % analysis by session

    
    
    
    
    
    
    
   
    
    
    
    
    
    
    
    
    
%% was part of the loop above
    
    %5-2 visually driven
        dir=[folder '/' num2str(i)];
        mkdir(dir);
        visstimTrace = suite2pData.nidaqAligned.visstim_on;
        visDrivenNeurons=drivenness(i).active_corr;
        traces_vis_all(dir,suite2pData.dFF(visDrivenNeurons,:),visstimTrace,'');
        %updated to traces_vis 5/8/22
        traces_vis_all(dir,visstimTrace,'','visstim');

     if(0) %3-18-2022 visstim
        % 1. correlation between neuron and stim pattern
        traces = suite2pData.dFF;
        visstim= suite2pData.nidaqAligned.visstim;
        correction='fdr'; pval=0.05; cutoff=0.1;
        [cormat,p] = corr(traces',repmat(visstim,size(traces,1),1)');
        cormat=cormat(:,1);p=p(:,1);
        p=pval_adjust(p, correction);
        cormat(isnan(cormat))=min(cormat(:))-1e-2; %this is stupid, but it works
        drivenness(i).active_corr=find(cormat>cutoff);
        % 2. visdriven defined by lexi
        visdriven=suite2pData.bias.visDrivenIDX;
        drivenness(i).active_visdriven_all= ...
                find(sum(visdriven')'==size(visdriven,2));
        drivenness(i).active_visdriven_any= ...
                find(~all(visdriven==0,2));
        end

     if(0) %3-7-2022 4-stats
         traces = suite2pData.dFF(:,suite2pData.startIdx(j):suite2pData.endIdx(j));
         
         
         stats_savepath = [folder '/' folder '_stats.mat'];
         stats = get_stats(traces,folder,stats_savepath);
         stats = get_active_neurons(stats);
         stats = pop_metrics(traces, stats, folder);
         save(stats_savepath,'stats','-v7.3');
     end

%% saving global .mat of all sessions
save('visual drivenness.mat','drivenness');

network = struct();
network = corr_between_neurons(traces, network, 10, 5, savepath);
sample_traces();





%end
