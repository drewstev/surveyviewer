function loadlnw(hf,evnt) %#ok

gd=guidata(hf);


[filename, pathname] = uigetfile( ...
    {'*.lnw', 'LNW Files (*.lnw)'},...
    'Select .lnw file',...
    gd.fpath);

if filename==0
    return
end

set(gd.linefile,'string',filename);
gd.lnwfile=[pathname,filename];

guidata(hf,gd);