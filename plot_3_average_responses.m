function [] = plot_3_average_responses(dir,trialsMat,plotPack,num)
   
    COLORS = {
        '#0072BD','#D95319','#EDB120','#77AC30', ...
        '#4623E2','#ff1493','#9acd32','#ffa500'
    };

    XLABEL_FONTSIZE=12;
    XLINE_FONTSIZE=8;
    THICK_LINE=2;
    THIN_LINE=1;
    CANVAS_WIDTH=1000;
    CANVAS_HEIGHT=800;
   
for i=1:num.neurons

   fig=figure('visible','off');
   fig.Position(3:4)=[CANVAS_WIDTH,CANVAS_HEIGHT];
   
   colormap(jet);   
   
    colorcount=1;
    for ses=2:3
        if size(plotPack.oriStr,1)<8
            colorcount=1; %this is stupid, but since we don't have MATLAB++ yes. need a way to match orientations to 
        end
       subplot(1,2,ses-1);
       hold on;
       numOri=size(plotPack.heatmap.ygrid.oris(:,ses),1);
       for j=1:numOri
           sesStart=plotPack.heatmap.ygrid.oris(j,ses);
           if j==numOri
               sesEnd=plotPack.heatmap.ygrid.end;
           else
                sesEnd=plotPack.heatmap.ygrid.oris(j+1,ses);
           end
           sesTrace=trialsMat(sesStart:sesEnd,:,i);
           avg=mean(sesTrace);
           avgLines(j)=plot(avg,'Color',COLORS{colorcount},'LineWidth',THICK_LINE);
           %I need an Orientation object. dude this code needs object
           %oriented so bad 
           sesError=std(sesTrace)/sqrt(size(sesTrace,1));
           
           fill([1:length(avg) fliplr(1:length(avg))], ...
                [avg+sesError fliplr(avg-sesError)], ...
                hex2rgb(COLORS{colorcount}),  ...
                'LineStyle','none', ...
                'FaceAlpha',0.1);
            colorcount=colorcount+1;
       end

       xticks(plotPack.trial.xticksBySec);
       xticklabels(plotPack.trial.xticksLabelsBySec);


         xline(plotPack.trial.xgrid.stimOn, ...
            '--k','stimulus on', ...
            'LabelVerticalAlignment','bottom', ...
            'LineWidth',THIN_LINE, ...
            'FontSize', XLINE_FONTSIZE);
        xline(plotPack.trial.xgrid.stimOff, ...
            '--k','stimulus off', ...
            'LabelVerticalAlignment','bottom', ...
            'LineWidth',THIN_LINE, ...
            'FontSize', XLINE_FONTSIZE);
      legend(avgLines,plotPack.heatmap.ygrid.orisLabel{:,ses},'Location','northeast','FontSize', 6);
      title(plotPack.heatmap.ygrid.sesStartLabel{ses});
           
    end
    
    
       sgtitle(fig,plotPack.titles{i},'Interpreter','none');
       xlabelLayer=axes(fig,'visible','off'); 
       xlabelLayer.XLabel.Visible='on';
       xlabel(xlabelLayer,[plotPack.xlabels{i} ' ' datestr(now)], ...
                'FontSize', XLABEL_FONTSIZE, ...
                'Interpreter', 'none');

       print([dir '\' plotPack.filenames{i} '_average_response.png'],'-dpng','-r300'); 
       close all;
end
end