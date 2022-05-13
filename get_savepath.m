function dir = get_savepath(suite2pData, varargin)

    fileinfo=strsplit(suite2pData.ops.data_path,'/');
    if(length(fileinfo)==7)
        runs=fileinfo{7};
    else
        runs='1';
    end
    fileinfo=fileinfo{5}; %'yymmdd_Sut#'
    fileinfo=strsplit(fileinfo,'_');
    mouse=fileinfo{2};    date=fileinfo{1};
    runs=strsplit(runs,'-');
     run = num2str(i-1+str2num(runs{1}),'%03d');   
     dir=[mouse '_' date '_' run];
end