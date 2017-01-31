function exportToWorkspace(hf,evnt) %#ok

gd=guidata(hf);

assignin('base','ldata',gd.profile)

if isfield(gd,'bindata')
    assignin('base','bindata',gd.bindata)
end