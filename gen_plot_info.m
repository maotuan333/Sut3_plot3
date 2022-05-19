function [filename,plotTitle,plotInfo] = gen_plot_info(plotPack,i,visDrivenIDX_i,statsp_i)

            runInfo = [plotPack.runNo '_' plotPack.runName '_' plotPack.runFilename];
            filename=[runInfo ' #' num2str(i)];
            plotTitle= [filename plotPack.fixedTitle];
            plotInfo=[];
            for j=1:length(plotPack.oriStr)
                if visDrivenIDX_i(j)==1
                    filename=[filename '_' plotPack.oriStr{j}];
                end
                if mod(j,5)==0
                    plotInfo=[plotInfo newline];
                end
                plotInfo=[plotInfo '(' plotPack.oriStr{j} ')p=' num2str(statsp_i(j),'%.2g') '. '];
            end
        plotInfo=[plotInfo plotPack.fixedInfo];

end