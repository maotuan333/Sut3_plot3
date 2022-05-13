function [] =   plot_2_heatmap(dir,traces,freq,trial, ...
        trialOnsets,trialOffsets,visDrivenIDX,oriTrace,oriStr,)

   fixedTitle = 'visually driven by t-test';
   fixedInfo = [newline 'active=p<0.05   ' ];    
   
   baselineSecs=1;
   postStimSecs=4;
   numBaselineFrames=baselineSecs * round(freq,-1);
   numSpont=20;
   numTrials=length(trialOnsets);
   
   stimWindow=round(max(trialOffsets-trialOnsets));
   trialWindow=stimWindow+(baselineSecs+postStimSecs)*numBaselineFrames;
   %warning if extending in to the next stimulus... TODO
   trialsMat=zeros(numTrials+numSpont,trialWindow);
   
   %%generate spontaneous windows
    %%stimWindow is def redundant TODO
    %%plot 2 also need lim
    
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
                        (runName,runFilename,i,[fixedInfo datestr(now)],fixedTitle,oriStr,visDrivenIDX(i,:),statsp(i,:));


           fig=figure('visible','off');%tiledlayout(1,2);
           fig.Position(3:4)=[1200,700];

           for j=1:2 
               %nexttile;
               subplot(1,2,j);
               hold on;
               colormap(jet);   
               set(gca, 'YDir','reverse');
               imagesc(trialsMat); %drawing heatmap
               xlim([0 trialWindow]);
               ylim([0 numTrials+numSpont]);
               for k=1:round(trialWindow/freq,0)
                   ticks(k)=freq*k;
               end
               xticks(ticks);
               xticklabels(xticks/freq);
               xline(numBaselineFrames,'--w','stimulus on','LabelVerticalAlignment','bottom');
               xline(numBaselineFrames+max(trialOffsets-trialOnsets)-0.5,'--w','stimulus off','LabelVerticalAlignment','bottom');
               for k=1:size(oriStr,1)
                   yline(sum(numOri(1:k-(numSpont==0))),'w',oriStr(k,:),'LabelVerticalAlignment','bottom');
               end
               yline(0,'w','spontaneous','LabelVerticalAlignment','bottom');
               %yline(0,'w','session 2 monocular','LabelVerticalAlignment','bottom');
               %yline(numTrials/2,'w','session 3 binocular','LabelVerticalAlignment','bottom');   
               colorbar;
               if j==1
                   caxis(lim);
               end
           end

           
           sgtitle(fig,plotTitle);
           han=axes(fig,'visible','off'); 
           han.XLabel.Visible='on';
            xlabel(han,plotInfo,'FontSize', 12);
           %xlabel(plotInfo,'FontSize', 12);

           print([dir '\' filename '_heatmap.png'],'-dpng','-r200'); 

        end
   end
   
   
end