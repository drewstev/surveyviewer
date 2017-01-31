function plot_map(hf,gd) %#ok

gd=guidata(hf);



if ~isfield(gd,'ldata')
    gd.ldata=extract_lines(gd.data,...
        gd.prof);
end
ldata=gd.ldata;



if isfield(gd,'mh');
    delete(gd.mh)
    delete(gd.th);
end
% cla(gd.axes1)
% cla(gd.axes2)



if ~isfield(gd,'xlimsm')
    minx=min(arrayfun(@(x)(min(x.x)./1000),gd.lnw));
    maxx=max(arrayfun(@(x)(max(x.x)./1000),gd.lnw));
    miny=min(arrayfun(@(x)(min(x.y)./1000),gd.lnw));
    maxy=max(arrayfun(@(x)(max(x.y)./1000),gd.lnw));
    gd.xlimsm=[minx maxx];
    gd.ylimsm=[miny maxy];
    set(gd.axes2,'xlim',gd.xlimsm,...
        'ylim',gd.ylimsm)
end


if ~isfield(gd,'xlimsn')
    set(gd.axes2,'xlim',gd.xlimsm,...
        'ylim',gd.ylimsm)
   
else
    set(gd.axes2,'xlim',gd.xlimsn,...
        'ylim',gd.ylimsn)
end

h=[];
np=1;
for i=1:length(ldata.lines)
    if ~iscell(ldata.lines(i).xyz)
        idx=isfinite(ldata.lines(i).xyz(:,3));
        h(np)=plot(ldata.lines(i).xyz(idx,1)./1000,...
            ldata.lines(i).xyz(idx,2)./1000,'.',...
            'linewidth',2,'color','r',...
            'parent',gd.axes2); %#ok
        np=np+1;
    else
        if gd.reps==1
            idx=cellfun(@(x)(isfinite(x(:,3))),...
                ldata.lines(i).xyz,'un',0);
            h2=cellfun(@(x,y)(plot(x(y,1)./1000,x(y,2)./1000,...
                '.','linewidth',2,...
                'color','r',...
                'parent',gd.axes2)),...
                ldata.lines(i).xyz,idx,'un',0);
            nreps=length(idx);
            h(np:np+nreps-1)=[h2{:}];
            np=np+nreps;
        else
            idx=isfinite(ldata.lines(i).xyz{1}(:,3));
            h(np)=plot(ldata.lines(i).xyz{1}(idx,1)./1000,...
                ldata.lines(i).xyz{1}(idx,2)./1000,...
                '.','linewidth',2,'color','r',...
                'parent',gd.axes2); %#ok
            np=np+1;
        end
        
    end
end


gd.mh=h;
gd.th=text(gd.lnw(gd.pointer).x(1)./1000,gd.lnw(gd.pointer).y(1)./1000,...
    gd.lnw(gd.pointer).name,'verticalalign','top',...
    'parent',gd.axes2);




if ishandle(gd.hf2)
    
    gd.profile=ldata;
    guidata(hf,gd);
    gd.listdata=getlist(hf);
    set(gd.listh,'data',gd.listdata)
else
    if isfield(gd,'listdata')
        gd=rmfield(gd,'listdata');
    end
end

guidata(hf,gd);
