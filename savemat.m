function savemat(hf,evnt) %#ok

gd=guidata(hf);


[filename, pathname] = uiputfile( ...
    {'*.mat', 'MAT Files (*.mat)'},...
    'Save .mat file',...
    gd.fpath);

if filename==0
    return
end

set(gd.fileout,'string',filename);
gd.outputfile=[pathname,filename];


set(gd.done,'enable','on')

guidata(hf,gd);