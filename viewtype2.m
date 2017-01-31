function viewtype2(hf,evnt) %#ok

gd=guidata(hf);
set(gd.tabgroup,'SelectedTab',gd.mtab)
set(gd.viewtype2,'checked','on');
set(gd.viewtype1,'checked','off');
set(gd.viewtype3,'checked','off');
plot_map(hf);
