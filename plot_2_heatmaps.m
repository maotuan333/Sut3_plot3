function [] =   plot_2_heatmaps(dir,trialsMat,plotPack,num)
   
    XLABEL_FONTSIZE=12;
    LINE_WIDTH=2;
    CANVAS_WIDTH=600;
    CANVAS_HEIGHT=800;
    

    for i=1:num.neurons

       fig=figure('visible','off');
       fig.Position(3:4)=[CANVAS_WIDTH,CANVAS_HEIGHT];
       
       hold on;
       colormap(jet);   
       set(gca, 'YDir','reverse');
       imagesc(trialsMat(:,:,i)); %plotting heatmap
       xlim([0 size(trialsMat,2)]);
       ylim([0 size(trialsMat,1)]);

       xticks(plotPack.trial.xticksBySec);
       xticklabels(plotPack.trial.xticksLabelsBySec);

       xline(plotPack.trial.xgrid.stimOn, ...
            '--w','stimulus on', ...
            'LabelVerticalAlignment','bottom', ...
            'LineWidth',LINE_WIDTH);
       xline(plotPack.trial.xgrid.stimOff, ...
            '--w','stimulus off', ...
            'LabelVerticalAlignment','bottom', ...
            'LineWidth',LINE_WIDTH);
       for ses=2:3
           for j=1:size(plotPack.heatmap.ygrid.oris(:,ses))
               yline(plotPack.heatmap.ygrid.oris(j,ses)+plotPack.heatmap.ygrid.SHIFT, ...
               'w',plotPack.heatmap.ygrid.orisLabel{j,ses}, ...
               'LabelVerticalAlignment','bottom', ...
               'LineWidth',LINE_WIDTH);
           end
       end
       for ses=1:3
        yline(plotPack.heatmap.ygrid.sesStart(ses)+plotPack.heatmap.ygrid.SHIFT, ...
            'w',plotPack.heatmap.ygrid.sesStartLabel{ses}, ...
            'LabelVerticalAlignment','bottom', ...
            'LabelHorizontalAlignment','left');   
       end
       colorbar;
       
       sgtitle(fig,plotPack.titles{i},'Interpreter','none');
       xlabelLayer=axes(fig,'visible','off'); 
       xlabelLayer.XLabel.Visible='on';
       xlabel(xlabelLayer,[plotPack.xlabels{i} ' ' datestr(now)], ...
                'FontSize', XLABEL_FONTSIZE, ...
                'Interpreter', 'none');

       print([dir '\' plotPack.filenames{i} '_heatmap.png'],'-dpng','-r200'); 
       close all;
    end
end