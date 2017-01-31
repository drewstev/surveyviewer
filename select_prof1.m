function select_prof1(hf,evnt)%#ok

gd=guidata(hf);
set(gd.str,'visible','off')
back=get(gd.push1,'value');
forw=get(gd.push2,'value');
pause(0.000001)

gd.bindata=[];
gd.pstats=[];

% move pointer forward or back accoring to pushbuttons
if forw==1
    set(gd.push1,'enable','on')
    if gd.fInd(gd.pointer)~=gd.fInd(end)
        gd.pointer=gd.pointer+1;
        
        
        if gd.pointer==gd.fInd(end);
            set(gd.push2,'enable','off');
        end
        
   
    end
elseif back==1;
    set(gd.push2,'enable','on');
    if gd.fInd(gd.pointer)~=gd.fInd(1)
        gd.pointer=gd.pointer-1;
        gd.newInd=gd.fInd(gd.pointer);
        
        if gd.pointer==1;
            set(gd.push1,'enable','off')
        end

    end
else

    
end
set(gd.edit1,'string',gd.lines(gd.pointer));



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
        run_analysis(hf);
        plot_time_series(hf);
end

