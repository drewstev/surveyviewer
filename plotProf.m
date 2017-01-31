function plotProf(hf,evnt)%#ok

gd=guidata(hf);
gd.reps=1;

if ~isfield(gd,'ldata')
    gd.ldata=extract_lines(gd.data,...
        gd.prof);
end
ldata=gd.ldata;
% cla(gd.axes2)
% set(gd.axes2,'visible','off')

cla(gd.axes1)
set(gd.axes1,...
    'nextplot','add',...
    'visible','on')

ptype=get(gd.pdt,'value');


switch ptype
    case 1
        
        h=[];
        for i=1:length(ldata.lines)
            if ~iscell(ldata.lines(i).xyz)
                h(i)=plot(ldata.lines(i).dist,ldata.lines(i).xyz(:,3),'-',...
                    'linewidth',2,'color',ldata.lines(i).line_color,...
                    'parent',gd.axes1); %#ok
            else
                if gd.reps==1
                    h2=cellfun(@(x,y)(plot(x,y(:,3),'-','linewidth',2,...
                        'color',ldata.lines(i).line_color,...
                        'parent',gd.axes1)),...
                        ldata.lines(i).dist,ldata.lines(i).xyz,'un',0);
                    h(i)=h2{1};%#ok
                else
                    h(i)=plot(ldata.lines(i).dist{1},ldata.lines(i).xyz{1}(:,3),...
                        '-','linewidth',2,'color',ldata.lines(i).line_color,...
                        'parent',gd.axes1); %#ok
                    ldata.lines(i).xyz=ldata.lines(i).xyz{1};
                    ldata.lines(i).dist=ldata.lines(i).dist{1};
                    ldata.lines(i).offset=ldata.lines(i).offset{1};
                end
                
            end
        end
        axis tight
        
        
        set(gd.axes1,'color',[0.5 0.5 0.5])
        
        if ~isempty(h)
            dn=arrayfun(@(x)(datenum(...
                x.survey_date,'mm/dd/yyyy')),ldata.lines);
            [dnu,legind]=unique(dn);
            legstr=cellstr(datestr(dnu,'mm/dd/yyyy'));
            
            
            legend(gd.axes1,h(legind),legstr,...
                'fontsize',8,'location','best',...
                'box','off');
            
        end
        box on
        xlabel(gd.axes1,'\bf\itCross-shore Distance (m)','fontsize',14)
        ylabel(gd.axes1,'\bf\itElevation (m)','fontsize',14);
        
    case 2
        
        %bin data
        if isempty(gd.bindata)
            if gd.binopt.fillgaps==1;
                gd.bindata=bin_profile(ldata,gd.binopt.xint,...
                    'method',gd.binopt.type,'maxgap',gd.binopt.maxgap);
            else
                gd.bindata=bin_profile(ldata,gd.binopt.xint,...
                    'method',gd.binopt.type);
            end
        end
        
        %plot the binned data
        ns=length(gd.bindata);
        cols=num2cell(jet(ns),2);
        
        
        [gd.bindata(:).color]=deal(cols{:});
        
        h=arrayfun(@(x)(plot(x.dist,x.z,'color',x.color,...
            'parent',gd.axes1,'linewi',2)),gd.bindata,'un',0);
        axis tight
        
        
        if ~isempty(h)
            
            legstr={gd.bindata(:).survey_date}';
            legend(gd.axes1,legstr,...
                'fontsize',8,'location','best',...
                'box','off');
            
        end
        
        box on
        xlabel(gd.axes1,'\bf\itCross-shore Distance (m)','fontsize',14)
        ylabel(gd.axes1,'\bf\itElevation (m)','fontsize',14);
    case 3
        
        
        %bin data
        
        if isempty(gd.bindata)
            if gd.binopt.fillgaps==1;
                gd.bindata=bin_profile(ldata,gd.binopt.xint,...
                    'method',gd.binopt.type,'maxgap',gd.binopt.maxgap);
            else
                gd.bindata=bin_profile(ldata,gd.binopt.xint,...
                    'method',gd.binopt.type);
            end
        end
        
        if isempty(gd.pstats)
            guidata(hf,gd);
            run_analysis(hf);
            
            gd=guidata(hf);
        end
        
        
        ns=length(gd.bindata);
        
        if ns>1
            cols=num2cell(jet(ns-1),2);
            cols=[0 0 0;cols];
            
            
            
            minx=min(gd.bindata(1).dist);
            maxx=max(gd.bindata(1).dist);
            px=[minx maxx maxx minx minx];
            
            sdz=sqrt(gd.anaopt.ana_vc_unc.^2+gd.anaopt.ana_vc_unc.^2);
            py=[sdz sdz -sdz -sdz sdz];
            
            
            
            
            hold on
            h=cellfun(@(x,y)(plot(gd.bindata(1).dist,x,'color',...
                y,'parent',gd.axes1,'linewi',2)),...
                gd.pstats.dz,cols(2:end),'un',0);
            ph=patch(px,py,[0.6 0.6 0.6],...
                'edgecolor',[0.6 0.6 0.6],...
                'parent',gd.axes1);
            line([minx maxx],[0 0],'color','k',...
                'parent',gd.axes1)
            uistack(ph,'bottom')
            box on
            ylabel(gd.axes1,'\bf\itElevation Difference (m)','fontsize',14)
            xlabel(gd.axes1,'\bf\itCross-shore Distance (m)','fontsize',14)
            
            if ~isempty(h)
                
                legstr={gd.bindata(2:end).survey_date}';
                legend([h{:}],legstr,...
                    'fontsize',8,'location','best',...
                    'box','off');
                
            end
        else
            minx=min(gd.bindata(1).dist);
            maxx=max(gd.bindata(1).dist);
            px=[minx maxx maxx minx minx];
            
            sdz=sqrt(gd.anaopt.ana_vc_unc.^2+gd.anaopt.ana_vc_unc.^2);
            py=[sdz sdz -sdz -sdz sdz];
            patch(px,py,[0.6 0.6 0.6],...
                'edgecolor',[0.6 0.6 0.6],...
                'parent',gd.axes1);
            hold on
            line([minx maxx],[0 0],'color','k',...
                'parent',gd.axes1)
        end
        
end

gd.xlimsp=get(gd.axes1,'xlim');
gd.ylimsp=get(gd.axes1,'ylim');


guidata(hf,gd);
if ishandle(gd.hf2)
    gd.listdata=getlist(hf);
    set(gd.listh,'data',gd.listdata)
else
    if isfield(gd,'listdata')
        gd=rmfield(gd,'listdata');
    end
end

guidata(hf,gd);
