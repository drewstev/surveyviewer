function run_offline_menu(hf,evnt) %#ok

gd=guidata(hf);
gd.offopt=offline_gui(gd.offopt);
gd.prof=gd.lines(gd.pointer);

gd.ldata=extract_lines(gd.data,...
    gd.prof);

cidx=arrayfun(@(x)(iscell(x.xyz)),gd.ldata.lines);
if gd.offopt.use_offline
    
    flag=arrayfun(@(x)(abs(x.offset)<=gd.offopt.max_off),...
        gd.ldata.lines(~cidx),'un',0);
    [gd.ldata.lines(~cidx).flag]=deal(flag{:});
    
    xyz=arrayfun(@(x)([x.xyz(:,1)+0./x.flag x.xyz(:,2)+0./x.flag,...
        x.xyz(:,3)+0./x.flag]),gd.ldata.lines(~cidx),'un',0);
    [gd.ldata.lines(~cidx).xyz]=deal(xyz{:});
    
    if any(cidx)
        cval=find(cidx);
        for i =1:length(cval);
            gd.ldata.lines(cval(i)).flag=...
                cellfun(@(x)(abs(x)<=gd.offopt.max_off),...
                gd.ldata.lines(cval(i)).offset,'un',0);
            gd.ldata.lines(cval(i)).xyz=cellfun(@(x,y)(...
                [x(:,1)+0./y x(:,2)+0./y,...
                x(:,3)+0./y]),gd.ldata.lines(cval(i)).xyz,...
                gd.ldata.lines(cval(i)).flag,'un',0);
            
        end
    end
    

end


guidata(hf,gd);
    


val=get(gd.tabgroup,'selectedtab');
switch val.Title
    case 'Profile'
        plotProf(hf);
    case 'Map'
        plot_map(hf);
    case 'Time-series'
end
