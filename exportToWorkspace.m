function exportToWorkspace(hf,evnt) %#ok

gd=guidata(hf);

assignin('base','ldata',gd.ldata)

if isfield(gd,'bindata')
    assignin('base','bindata',gd.bindata)
end
if isfield(gd,'pstats')
    assignin('base','pstats',gd.pstats)
end