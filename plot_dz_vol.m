function plot_dz_vol(hf,evnt) %#ok

gd=guidata(hf);

if isempty(gd.bindata)
    
    if gd.binopt.fillgaps==1;
        gd.bindata=bin_profile(gd.ldata,gd.binopt.xint,...
            'method',gd.binopt.type,'maxgap',gd.binopt.maxgap);
    else
        gd.bindata=bin_profile(gd.ldata,gd.binopt.xint,...
            'method',gd.binopt.type);
    end
end



if length(gd.bindata)==1;
    return
end


z=cell2mat(arrayfun(@(x)(x.z),gd.bindata,'un',0)');
dates=arrayfun(@(x)(x.survey_date),gd.bindata,'un',0);
% dn=datenum(dates,'mm/dd/yyyy');

sigma=0.1;

%modified diff.  Takes difference between each survey and the previous
%survey with data
[m,n]=size(z);
nidx=isnan(z);
diffa=nan(m,n-1);
for j=1:m
    for i=2:n
        if ~nidx(j,i)
            lg=find(nidx(j,1:i-1)==0,1,'last');
            if ~isempty(lg)
                diffa(j,i-1)=z(j,i)-z(j,lg);
            end
        end
    end
end



dz=num2cell(nancumsum(diffa,2,2),1)';

ns=length(gd.bindata);
cols=num2cell(jet(ns-1),2);
cols=[0 0 0;cols];



minx=min(gd.bindata(1).dist);
maxx=max(gd.bindata(1).dist);
px=[minx maxx maxx minx minx];
py=[sigma sigma -sigma -sigma sigma];

patch(px,py,[0.6 0.6 0.6],...
    'edgecolor',[0.6 0.6 0.6],...
    'parent',gd.axes3)
hold on
cellfun(@(x,y)(plot(gd.bindata(1).dist,x,'color',y,...
    'parent',gd.axes3)),...
    dz,cols(2:end));
line([minx maxx],[0 0],'color','k',...
    'parent',gd.axes3)
ylabel(gd.axes3,'\bf\itElevation Difference (m)')
xlabel(gd.axes3,'\bf\itCross-shore (m)')
