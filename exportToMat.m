function exportToMat(hf,evnt) %#ok

gd=guidata(hf);

[filename, pathname] = uiputfile('*.mat', 'Save MAT-file As',...
    gd.outpath);

if filename==0
    return
end

gd.outpath=pathname;


if gd.bin==1
    bindata=gd.bindata; %#ok
    save([gd.outpath,filename],'bindata')
else
    ldata=gd.profile; %#ok
    
    save([gd.outpath,filename],'ldata')
end

guidata(hf,gd)