function [] = plot_1_sample_traces (dir,oriStr,visDrivenIDX,statsp,traces,visstimTrace,lim)

    
    fixedTitle = 'visually driven by t-test';
    fixedInfo = [newline 'active=p<0.05   ' datestr(now)];    
    %visDrivenNeurons=find(any(visDrivenIDX,2));
    for i=1:size(visDrivenIDX,1)
        if any(visDrivenIDX(i,:))
            
        [filename,plotTitle,plotInfo]=gen_plot_info ...
                    (i,fixedInfo,fixedTitle,oriStr,visDrivenIDX(i,:),statsp(i,:));
        % analysis
        traces_vis(dir,traces(i,:),lim,visstimTrace, ...
                       visDrivenIDX(i,:),filename,plotTitle,plotInfo,oriStr);
        end
    end

end