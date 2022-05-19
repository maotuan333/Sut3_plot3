%visstimTrace: visual stimuli trace for the orientations of interest
%info: current version contains No. of neuron, p values for each
%orientation 5/8/22
%re-styled 5/16/22


function [] = plot_1_sample_traces(dir,traces,visstimTrace,visDrivenIDX,plotPack,num)

    TRACES_CUT=5000;
    ALPHA=0.3; %transparency
    XLABEL_FONTSIZE=8;
    LINE_WIDTH=1;
    CANVAS_WIDTH=1200;
    CANVAS_HEIGHT=700;

    COLORS = {
        '#0072BD','#D95319','#EDB120','#77AC30', ...
        '#4623E2','#ff1493','#9acd32','#ffa500'
    };

% '#00bfff','#dc143c','#228b22','#ffd700', ...

    TRACE_COLOR=[0 0 0 0.8];
    
    minLim=plotPack.lim(1);
    maxLim=1.01*plotPack.lim(2);
    actStim=maxLim*0.8;
    inactStim=maxLim*0.5;
    
    for i=1:num.neurons

        fig = figure('visible','off');      
        fig.Position(3:4)=[CANVAS_WIDTH,CANVAS_HEIGHT];
        hold on;

        for j=1:num.stimTypes
            if visDrivenIDX(i,j)==1 %visually driven for orientation j
                plot(visstimTrace(:,j)*actStim, ...
                    'Color',COLORS{j}, ...
                    'LineWidth',LINE_WIDTH);
            else
                line=plot(visstimTrace(:,j)*inactStim, ...
                    'Color',COLORS{j}, ...
                    'LineWidth',LINE_WIDTH);
                line.Color = [line.Color ALPHA];
            end
        end

        plot(traces(i,:),'Color',TRACE_COLOR);

        ylim([minLim maxLim]);
        xlim([TRACES_CUT num.framesTrace]); 

        legend(plotPack.oriStr,'Location','northwest');
            
        title(plotPack.titles{i},'Interpreter', 'none');
        xlabel([plotPack.xlabels{i} ' ' datestr(now)], ...
                'FontSize', XLABEL_FONTSIZE, ...
                'Interpreter', 'none');

        print([dir '\' plotPack.filenames{i} '_sample trace.png'],'-dpng','-r300'); 

        close all;
    end
end

%done with highlighting stimulus orientation but probably - need a color
%scheme so that you can still see what the other orientations are instead
%of all grey, add p-values, if they're active under corr ANDOR t-test,
%index in the original file, file name,... (what else) 5/6/22
%inset of orientations 5/8/22





