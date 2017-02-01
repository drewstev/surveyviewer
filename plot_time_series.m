function plot_time_series(hf,evnt) %#ok

gd=guidata(hf);

cla(gd.axes3(1))
cla(gd.axes3(2))
if ~isempty(gd.pstats)
    dn=datenum(gd.pstats.dates);
    dt=datetime(dn,'convertfrom','datenum');
    
    
    set(gd.axes3,'nextplot','add',...
        'visible','on',...
        'box','on')
    line([dn dn]',[gd.pstats.vol_change- gd.pstats.vol_error,...
        gd.pstats.vol_change+gd.pstats.vol_error]',...
        'color',[0.6 0.6 0.6],'parent',gd.axes3(1),...
        'linewi',2)
    plot(dt,gd.pstats.vol_change,'ko-','markerfacecolor','k',...
        'parent',gd.axes3(1),'linewi',2)
    ylabel(gd.axes3(1),'\bf\itVolume Change (m^3/m)','fontsize',12)
    
    plot(dt,gd.pstats.shore_change,'ko-','markerfacecolor','k',...
        'linewi',2,'parent',gd.axes3(2))
    ylabel(gd.axes3(2),'\bf\itShoreline Change (m)','fontsize',12)
    drawnow

end


