function [traces,visstimTrace,visDrivenIDX,statsp,oriStr,lim] = ...
        plot_0_get_stats (suite2pData)
   
   
    % oris, oriStr
    % visDrivenIDX, visDrivenNeurons
    % statsp
    % traces
    oriTrace=suite2pData.Stim.oriTrace;
    oris = unique(oriTrace);%orientations
    oriStr = arrayfun(@(x) [num2str(x) '°'], oris, 'UniformOutput', false);

    visDrivenIDX=suite2pData.bias.visDrivenIDX;
    %statsh=cell2mat(struct2cell(suite2pData.statsT.h)); %equivalent to visDrivenIDX
    statsp=cell2mat(struct2cell(suite2pData.statsT.p))';    
    traces=suite2pData.dFF; %(visDrivenNeurons,:);

    %generating stimuli timeseries for each orientation
    visstimTrace=repelem(false,size(suite2pData.dFF,2), ... 25-visstim, others-visstim_on
                    length(oris));
    for j=1:length(oris)
        oriIndex=find(oriTrace==oris(j));
        for k=1:length(oriIndex)
            stimOn=suite2pData.Stim.visstimOnsets(oriIndex(k));
            stimOff=suite2pData.Stim.visstimOffsets(oriIndex(k));
            visstimTrace(stimOn:stimOff,j)=true;
        end

    %numTrials=length(suite2pData.Stim.visstimOnsets);
    
    lim = [min(traces(:)) max(traces(:))];
    
    end
end