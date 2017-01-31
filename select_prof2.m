function select_prof2(hf,evnt)%#ok

gd=guidata(hf);
set(gd.str,'visible','off')
gd.bindata=[];
gd.pstats=[];


pNum=sprintf('%-3.3d',str2double(get(gd.edit1,'string')));

[~,~,ib]=intersect(pNum,gd.lines);

if ~isempty(ib)
    gd.pointer=ib;
    
    
    
    if ib>=length(gd.fInd);
        pNum=length(gd.fInd);
        set(gd.edit1,'string',pNum);
        set(gd.push2,'enable','off')
        set(gd.push1,'enable','on')
    elseif ib<=1
        set(gd.edit1,'string',pNum);
        set(gd.push1,'enable','off');
        set(gd.push2,'enable','on');
    else
        set(gd.edit1,'string',gd.lines{ib});
        set(gd.push1,'enable','on');
        set(gd.push2,'enable','on');
    end
    
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
    
else
    set(gd.str,'string',['Line: ',pNum,' does not exist.'],...
        'visible','on','foregroundcolor','r')
    set(gd.edit1,'string',gd.lines(gd.pointer))
end





