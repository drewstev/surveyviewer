function fillaction(hf,evnt) %#ok

gd=guidata(hf);

val=get(gd.check1,'value');
if val==0
    set(gd.maxgap,'enable','off')
else
    set(gd.maxgap,'enable','on')
end
