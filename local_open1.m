function local_open1(hf,evnt) %#ok

gd=guidata(hf);

[filename, pathname] = uigetfile( ...
    {'*.xyz', 'XYZ Files (*.xyz)'},...
    'Select .xyz file(s)',...
    'multiselect','on',gd.fpath);
if ~iscell(filename)
    if filename==0
        return
    end
end

gd.fpath=pathname;



set(gd.xyzfiles,'string',filename);

if iscell(filename)
    gd.files1=cellfun(@(x)([gd.fpath,x]),filename','un',0);
else
    gd.files1={[gd.fpath,filename]};
end



guidata(hf,gd);