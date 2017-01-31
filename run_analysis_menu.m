function run_analysis_menu(hf,evnt) %#ok

gd=guidata(hf);
gd.anaopt=analysis_gui(gd.anaopt);
gd.pstats=[];
guidata(hf,gd);

run_analysis(hf);

val=get(gd.tabgroup,'selectedtab');
switch val.Title
    case 'Profile'
        plotProf(hf);
    case 'Map'
        plot_map(hf);
    case 'Time-series'
        plot_time_series(hf);
end


