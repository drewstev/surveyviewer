function run_bin_menu(hf,evnt) %#ok

gd=guidata(hf);
gd.binopt=binmenu(gd.binopt);
gd.pstats=[];
gd.bindata=[];

guidata(hf,gd);

val=get(gd.tabgroup,'selectedtab');
switch val.Title
    case 'Profile'
        plotProf(hf);
    case 'Map'
        plot_map(hf);
    case 'Time-series'
        run_analysis(hf);
        plot_time_series(hf);
end
