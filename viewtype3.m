function viewtype3(hf,evnt) %#ok

gd=guidata(hf);
set(gd.tabgroup,'SelectedTab',gd.ttab)
set(gd.viewtype3,'checked','on');
set(gd.viewtype1,'checked','off');
set(gd.viewtype2,'checked','off');

if isempty(gd.pstats)
    run_analysis(hf);
    plot_time_series(hf);
end

