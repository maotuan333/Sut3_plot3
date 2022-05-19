function [filenames,titles,xlabels,trialsMat] = plots3(folder,runNo,nameOfRun,suite2pData)

    %% getting necessary values for analysis
   [traces,visstimTrace,visDrivenIDX,statsp,oriStr,lim] = plot_0_get_stats(suite2pData);

   plotPack.runNo=runNo;
   plotPack.runName=nameOfRun;
   plotPack.runFilename=get_savepath(suite2pData);
   plotPack.lim=lim;
   plotPack.oriStr=oriStr;
   plotPack.fixedTitle ='    visual drivenness defined by t-test';
   plotPack.fixedInfo = [newline 'active=p<0.05   ']; 
   
    %% directory building
        %%%%%for existing folders do a rename
    dir=[folder '/' plotPack.runNo '_' plotPack.runName '_' plotPack.runFilename];
    if ~isfolder(dir)        
        mkdir(dir);
    end
    dirSubs{1}=[dir '/sample_traces'];
    dirSubs{2}=[dir '/heatmap'];
    dirSubs{3}=[dir '/average_response'];
    for i=1:length(dirSubs)
        if ~isfolder(dirSubs{i})
            mkdir(dirSubs{i});
        end
    end
   
   %% constants
    num.framesTrace=size(traces,2);
    num.neurons=size(visDrivenIDX,1);
    num.stimTypes=size(plotPack.oriStr,1);
   
    %% generate file info
    %TODO
   if 1%~isfile('plotInfo.mat')
        for i=1:num.neurons
            visDrivenIDX_j=visDrivenIDX(i,:);
            statsp_j=statsp(i,:);
            [filenames{i},titles{i},xlabels{i}]= ...
                    gen_plot_info(plotPack,i,visDrivenIDX_j,statsp_j);
        end
   else
        load('plotInfo.mat');
   end
   
    plotPack.filenames=filenames;
    plotPack.titles=titles;
    plotPack.xlabels=xlabels;

    %% analysis
       plot_1_sample_traces(dirSubs{1},traces,visstimTrace,visDrivenIDX,plotPack,num);

       freq=suite2pData.ops.fs;
       stimOnsets=suite2pData.Stim.trialonsets;
       stimOffsets=suite2pData.Stim.trialoffsets;
       oriTrace=suite2pData.Stim.oriTrace;
       sessionBreak=suite2pData.startIdx(3);

       plotPack.oriStr=[{'spont'};oriStr];

       [trialsMat,plotPack] = trial_heatmap_prep(traces,freq,stimOnsets,stimOffsets,oriTrace,sessionBreak,plotPack,num);

       plot_2_heatmaps(dirSubs{2},trialsMat,plotPack,num);

       plot_3_average_responses(dirSubs{3},trialsMat,plotPack,num);
   
end




