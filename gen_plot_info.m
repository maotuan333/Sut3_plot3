







function [filename,plotTitle,plotInfo] = gen_plot_info(runName,runFilename,index,fixedInfo,fixedTitle,oriStr,visDrivenIDX,statsp)

            filename=[runName '#' num2str(index)];
            plotTitle= [filename ' - ' fixedTitle];
            plotInfo=[];
            for i=1:size(oriStr,2)
                if visDrivenIDX(i)==1
                    filename=[filename '_' oriStr(i,:)];
                end
                plotInfo=[plotInfo '(' oriStr(i,:) ')p=' num2str(statsp(i),'%.2g') '. '];
            end
        plotInfo=[plotInfo fixedInfo newline runFilename];
        
end