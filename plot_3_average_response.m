function [] = plot_3_average_response(dir,traces,freq,trial,trialOnsets,trialOffsets,visDrivenIDX,oriTrace,oriStr,lim,statsp)

   fixedTitle = 'visually driven by t-test';
   fixedInfo = [newline 'active=p<0.05   ' ];   
   
       colors = [
        0         0         0;...black
        0         0.4470    0.7410;...blue
        0.8500    0.3250    0.0980;...red
        0.9290    0.6940    0.1250;...yellow
        0.4660    0.6740    0.1880;...green
        0.4940    0.1840    0.5560;...purple
        0.3010    0.7450    0.9330;...aqua
        0.6350    0.0780    0.1840...dark red
        ];
    SMALLFONT=6;
    
   baselineSecs=1;
   postStimSecs=4;
   numBaselineFrames=baselineSecs * round(freq,-1);
   numSpont=20;
        oriStr=['spon';oriStr];
   numTrials=length(trialOnsets);
   
   stimWindow=round(max(trialOffsets-trialOnsets));
   trialWindow=stimWindow+(baselineSecs+postStimSecs)*numBaselineFrames;
   %warning if extending in to the next stimulus... TODO
   trialsMat=zeros(numTrials+numSpont,trialWindow);
   
   for i=1:numSpont
      spontOnsets(i)=trialOnsets(1)-trial.trialOff*(numSpont+1-i);
      spontOffsets(i)=spontOnsets(i)+stimWindow;
   end
   trialOnsets=[spontOnsets trialOnsets];
   trialOffsets=[spontOffsets trialOffsets];
   
   
   
   for i=1:size(visDrivenIDX,1)
       if any(visDrivenIDX(i,:))

           for j=1:numTrials+numSpont
               range_j = trialOnsets(j)-numBaselineFrames:trialOnsets(j)-numBaselineFrames+trialWindow-1;
               response=traces(i,range_j);
               trialsMat(j,:)=response';
           end

           [numOri,~]=groupcounts(oriTrace);
           numOri=[numSpont; numOri];
           [~,sortIdx] = sort(oriTrace);
           % sort B using the sorting index
           trialsMat(numSpont+1:end,:) = trialsMat(sortIdx,:);


            [filename,plotTitle,plotInfo]=gen_plot_info ...
                        (i,[fixedInfo datestr(now)],fixedTitle,oriStr(2:end,:),visDrivenIDX(i,:),statsp(i,:));


           fig=figure('visible','off');%tiledlayout(1,2);

           for j=1:2 
               %nexttile;
               subplot(1,2,j);
               hold on;
               colormap(jet);   
               
               for k=1:length(numOri)
                   avg=mean(trialsMat(sum(numOri(1:k-1))+1:sum(numOri(1:k)),:));
                   plot(avg,'Color',[colors(k,:) 0.8]);
               end
               
               for k=1:round(trialWindow/freq,0)
                   ticks(k)=freq*k;
               end
               xticks(ticks);
               xticklabels(xticks/freq);
               xline(numBaselineFrames,'--r','stimulus on','LabelVerticalAlignment','bottom','FontSize', SMALLFONT);
               xline(numBaselineFrames+max(trialOffsets-trialOnsets)-0.5,'--r','stimulus off', ...
                        'LabelVerticalAlignment','bottom','FontSize', SMALLFONT);
               if j==1
                   ylim(lim);
                   legend(oriStr,'Location','northeast','FontSize', 6);
               end
           end

           
           sgtitle(fig,plotTitle);
           han=axes(fig,'visible','off'); 
           han.XLabel.Visible='on';
            xlabel(han,plotInfo,'FontSize', SMALLFONT);
           %xlabel(plotInfo,'FontSize', SMALLFONT);

           print([dir '\' filename '_heatmap.png'],'-dpng','-r200'); 

        end

   end
end