
%big thanks to trial_heatmap_prep for doing all the dirty work

function [trialsMat,plotPack] = trial_heatmap_prep ...
                        (traces,freq,stimOnsets,stimOffsets,oriTrace,sessionBreak,plotPack,num)

   BASELINE_SEC=1;
   POSTSTIM_SEC=4;
   NUM_SPONT=20; %number of spontaneous windows extracted as control
   SHIFT=0.5;

   %% getting measurments of a trial
   %base conversion between seconds and number of frames
   FRAMES_PER_SEC=round(freq,-1);
        %stimulus length vary by 1 due to fence pole problem
   stimLen=round(max(stimOffsets-stimOnsets));
            %gap between onset and offset, taking the max due to fence pole effect
   windowLen=round(stimLen+(BASELINE_SEC+POSTSTIM_SEC)*FRAMES_PER_SEC,-1); 
            %length of the window we're examining, rounded to 10
   trialLen=max(stimOnsets(2:end/2)-stimOnsets(1:end/2-1)); 
            %gap between two onsets within a session
            %%%gosh this is not right

   if windowLen>trialLen
        warning(['Trial windows overlapping by ' num2str(windowLen-trialLen-1) ' frames']);
   end
   
   %% generate start of each window
   spontOnsets=stimOnsets(1)-NUM_SPONT*trialLen:trialLen:stimOnsets(1)-trialLen;
    % there's nothing as spontOnsets actually
   windowOnsets=[spontOnsets stimOnsets]-BASELINE_SEC*FRAMES_PER_SEC;
        %sanity check
   if windowOnsets(1)<=0
       error('Spontaneous run is not long enough for the number of trials requested');
   elseif windowOnsets(end)+windowLen-1>num.framesTrace
       %if the last window overruns
       bleedLen=windowOnsets(end)+windowLen-1-num.framesTrace;
       warning(['Last window exceeds maximum frame number (' num2str(bleedLen) ' frames). ' ...
                'Filling with zeros.']);
       bleed=windowOnsets(end)+windowLen-1-num.framesTrace;
       traces=[traces zeros(num.neurons,bleed)];
   end
   
   %% getting plot peripheries
   plotPack.trial.xgrid.start=0;
   plotPack.trial.xgrid.stimOn=BASELINE_SEC*FRAMES_PER_SEC;
   plotPack.trial.xgrid.stimOff=plotPack.trial.xgrid.stimOn+stimLen;
   plotPack.trial.xgrid.end=windowLen;
      %changing xticks when plotting
   plotPack.trial.xticksBySec = 0:freq:windowLen;
   plotPack.trial.xticksLabelsBySec = 0:windowLen/freq;
      
   %% splitting session 2 and 3
   %sorting indices by orientation
   sessionBreakStimIDX=find(stimOnsets>sessionBreak,1)-1; %last trial of ses2
   numTrialsPerOri{1}=NUM_SPONT;
  
   for ses=2:3
       %session 2 -monocular
       if ses==2
       oriTraceSes=oriTrace(1:sessionBreakStimIDX);
       %session 3 -binocular
       elseif ses==3
       oriTraceSes=oriTrace(sessionBreakStimIDX+1:end);
       end
       
       [numTrialsPerOri,orisSes]=groupcounts(oriTraceSes);
       [~,sortIdx{ses}] = sort(oriTraceSes);
       
       for i=1:length(orisSes)
               if i==1
                    plotPack.heatmap.ygrid.oris(i,ses)=NUM_SPONT+0+sessionBreakStimIDX*(ses==3);
               else
                   plotPack.heatmap.ygrid.oris(i,ses)=NUM_SPONT+sum(numTrialsPerOri(1:i-1))+sessionBreakStimIDX*(ses==3);
               end
                plotPack.heatmap.ygrid.orisLabel{i,ses}=[num2str(orisSes(i)) '°'];
       end
   end
   
   plotPack.heatmap.ygrid.sesStart(1)=0;
   plotPack.heatmap.ygrid.sesStart(2)=NUM_SPONT;
   plotPack.heatmap.ygrid.sesStart(3)=NUM_SPONT+sessionBreakStimIDX;
   
   plotPack.heatmap.ygrid.end=length(stimOnsets)+NUM_SPONT;
   
   plotPack.heatmap.ygrid.sesStartLabel{1}='session 1 spontaneous (sample trials)';
   plotPack.heatmap.ygrid.sesStartLabel{2}='session 2 monocular';
   plotPack.heatmap.ygrid.sesStartLabel{3}='session 3 binocular';
   
   plotPack.heatmap.ygrid.SHIFT=SHIFT;

      
  %% generate trialsMat
   numTrials=plotPack.heatmap.ygrid.end;
   trialsMat=zeros(numTrials,windowLen,num.neurons);
   sortIdx = [[1:NUM_SPONT]'; sortIdx{2}+NUM_SPONT; sortIdx{3}+sessionBreakStimIDX+NUM_SPONT];
   for i=1:numTrials
        for j=1:num.neurons
            % sort trials using the sorting index
            windowOffset=windowOnsets(sortIdx(i))+windowLen-1;
            %insert trial into sorted position
            trialsMat(i,:,j)=traces(j,windowOnsets(sortIdx(i)):windowOffset);
        end
   end
      
  
end














   