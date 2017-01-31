function viewtype1(hf,evnt) %#ok

gd=guidata(hf);
set(gd.tabgroup,'SelectedTab',gd.ptab)
set(gd.viewtype1,'checked','on');
set(gd.viewtype2,'checked','off');
set(gd.viewtype3,'checked','off');

plotProf(hf);


