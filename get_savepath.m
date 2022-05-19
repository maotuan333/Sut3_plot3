function dir = get_savepath(suite2pData, varargin)
    
    fileinfo=strsplit(suite2pData.ops.data_path,'/');

    mouseDate=fileinfo{5}; %'yymmdd_Sut#'
    mouseDate=strsplit(mouseDate,'_');
    mouse=mouseDate{2};    date=mouseDate{1};
       
    if nargin == 2
        if(length(fileinfo)==7)
            runs=fileinfo{7};
        else
            runs='1';
        end  
        runs=strsplit(runs,'-');
        run = num2str(varargin{1}-1+str2num(runs{1}),'%03d');
        dir=[mouse '_' date '_' run];
    else
        dir=[mouse '_' date];
    end
    
end