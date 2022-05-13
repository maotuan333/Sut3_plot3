%overlay: visual stimuli trace for the orientations of interest
%bacground: visual stimuli trace for the rest of the orientations
%info: current version contains No. of neuron, p values for each
%orientation 5/8/22


function [] = traces_vis ...
               (dir,trace,lim,overlay,config,filename,plotTitle,plotInfo,lineLegend)

    colors = [
        0         0.4470    0.7410;...blue
        0.8500    0.3250    0.0980;...red
        0.9290    0.6940    0.1250;...yellow
        0.4660    0.6740    0.1880;...green
        0.4940    0.1840    0.5560;...purple
        0.3010    0.7450    0.9330;...aqua
        0.6350    0.0780    0.1840;...dark red
        1         0         1    ...fuchsia
        ];
    
    minLim=min(lim);
    maxLim=1.01*max(lim);
    actStim=maxLim*0.8;
    inactStim=maxLim*0.5;
    transparency=0.3;
    
    
    tracesCut=5000;
    %for ii=1:size(traces,1) %not sure if i should keep this loop
        fig = figure('visible','off');    
            %fig = figure('visible','on');    
        fig.Position(3:4)=[1200,700];
        hold on;
        for jj=1:size(overlay,2)
            if config(jj)==1
                plot(overlay(:,jj)*actStim,'Color',colors(jj,:),'LineWidth',1);
            else
                plot(overlay(:,jj)*inactStim,'Color',[colors(jj,:) transparency],'LineWidth',1);
            end
        end
        plot(trace,'Color',[0 0 0 0.8]);
        ylim([minLim maxLim]);
        xlim([tracesCut size(trace,2)]);        
        legend(lineLegend,'Location','northwest');
        
        title(plotTitle);
        xlabel(plotInfo,'FontSize', 8);
        print([dir '\' filename '_sample trace.png'],'-dpng','-r300'); 
    %end
    
        close all;
end

%done with highlighting stimulus orientation but probably - need a color
%scheme so that you can still see what the other orientations are instead
%of all grey, add p-values, if they're active under corr ANDOR t-test,
%index in the original file, file name,... (what else) 5/6/22
%inset of orientations 5/8/22





