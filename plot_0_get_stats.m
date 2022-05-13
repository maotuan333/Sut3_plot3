function [oriStr,visDrivenIDX,statsp,traces,visstimTrace,trial,numTrials,lim] = ...
        plot_0_get_stats (suite2pData)

    % oris, oriStr
    % visDrivenIDX, visDrivenNeurons
    % statsp
    % traces
    oriTrace=suite2pData.Stim.oriTrace;
    oris = unique(oriTrace);%orientations
    oriStr = num2str(oris);
        oriStr = strcat(oriStr,'°');
    visDrivenIDX=suite2pData.bias.visDrivenIDX;
    visDrivenNeurons=find(any(visDrivenIDX,2)); %TODO should i keep this
    numTrials=length(visDrivenNeurons);
    %statsh=cell2mat(struct2cell(suite2pData.statsT.h)); %equivalent to visDrivenIDX
    statsp=cell2mat(struct2cell(suite2pData.statsT.p))';    
    traces=suite2pData.dFF; %(visDrivenNeurons,:);

    %generating stimuli timeseries for each orientation
    visstimTrace=repelem(false,length(suite2pData.nidaqAligned.visstim_on), ...
                    length(oris));
    for jj=1:length(oris)
        oriIndex=find(oriTrace==oris(jj));
        for kk=1:length(oriIndex)
            stimOn=suite2pData.Stim.visstimOnsets(oriIndex(kk));
            stimOff=suite2pData.Stim.visstimOffsets(oriIndex(kk));
            visstimTrace(stimOn:stimOff,jj)=true;
        end
        
    trial.trialOn=0;
    firstStimSession=2;
    trial.stimOn=suite2pData.Stim.trialonsets(1)-suite2pData.startIdx(firstStimSession);
    trial.stimOff=suite2pData.Stim.trialoffsets(1)-suite2pData.startIdx(firstStimSession);
    trial.trialOff=suite2pData.Stim.trialonsets(2)-suite2pData.startIdx(firstStimSession)-1;
    
    numTrials=length(suite2pData.Stim.visstimOnsets);
    
    
    lim = [min(traces(:)) max(traces(:))];
    
    end
end