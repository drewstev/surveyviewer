function fullExtents(hf,evnt)%#ok

gd=guidata(hf);

if strcmpi(get(gd.viewtype2,'checked'),'on')
    set(gd.axes2,'xlim',gd.xlimsm)
    set(gd.axes2,'ylim',gd.ylimsm)
    gd.xlimsn=gd.xlimsm;
    gd.ylimsn=gd.ylimsm;
    guidata(hf,gd);
else
    set(gd.axes1,'xlim',gd.xlimsp)
    set(gd.axes1,'ylim',gd.ylimsp)
end





