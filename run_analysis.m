function pstats = run_analysis(hf,evnt)%#ok

gd=guidata(hf);
anaopt=gd.anaopt;

if ~isfield(gd,'ldata')
    gd.ldata=extract_lines(gd.data,...
    gd.prof);
end
ldata=gd.ldata;

if isempty(gd.bindata)
    if gd.binopt.fillgaps==1;
        gd.bindata=bin_profile(ldata,gd.binopt.xint,...
            'method',gd.binopt.type,'maxgap',gd.binopt.maxgap);
    else
        gd.bindata=bin_profile(ldata,gd.binopt.xint,...
            'method',gd.binopt.type);
    end
end
pdata=gd.bindata;

z=cell2mat(arrayfun(@(x)(x.z),pdata,'un',0)');
dates=arrayfun(@(x)(x.survey_date),pdata,'un',0);
dn=datenum(dates,'mm/dd/yyyy');

if numel(dn)<2;
    %collect output
    pstats.line_num=gd.lines(gd.pointer);
    pstats.dates=dates;
    switch anaopt.ana_type
        case 1
            pstats.type='cumulative';
        case 2
            pstats.type='instantaneous';
    end
    

    pstats.vol_dist=NaN; 
    pstats.vol_change=NaN;
    pstats.vol_error=NaN; 
    pstats.vol_avg_rate=NaN; 
    pstats.shore_x=NaN; 
    pstats.shore_y=NaN;
    pstats.shore_change=NaN; 
    pstats.shore_avg_rate=NaN; 
    return
end



%calculate shoreline change
% ref=1.86; %shoreline elevation
ref=anaopt.ana_shore_ref;

z2=pdata(1).z(isfinite(pdata(1).z));
if z2(1)>z2(end)
    sp='last';
    mp=1;
else
    sp='first';
    mp=-1;
end
spos=arrayfun(@(x)(x.dist(find(x.z>=ref,1,sp))),pdata,'un',0);
xpos=arrayfun(@(x)(x.x(find(x.z>=ref,1,sp))),pdata,'un',0);
ypos=arrayfun(@(x)(x.y(find(x.z>=ref,1,sp))),pdata,'un',0);
eind=cellfun(@isempty,spos);
spos(eind)={NaN};
xpos(eind)={NaN};
ypos(eind)={NaN};




if anaopt.ana_type==2

    spos=[0;diff(cell2mat(spos).*mp)];
    idx2=find(isfinite(spos));
    spcum=cumsum(spos(idx2));
    shore_rate=(spcum(end)-spcum(1))/...
        ((dn(idx2(end))-dn(idx2(1)))/364.24);
    
    dz=num2cell(diff(z,[],2),1)';

else
    spos=[0;nancumsum(diff(cell2mat(spos).*mp))];
    idx2=find(isfinite(spos));
    shore_rate=(spos(idx2(end))-spos(idx2(1)))/...
        ((dn(idx2(end))-dn(idx2(1)))/364.24);
    
    
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

end


    



sdz=sqrt(anaopt.ana_vc_unc.^2+anaopt.ana_vc_unc.^2);

%caluculate volume change
if anaopt.ana_type==2
    
   vols=[0;cellfun(@(x)(nansum(x.*gd.binopt.xint)),dz)];
        dist=cellfun(@(x)(sum(numel(find(isfinite(x))).*...
        gd.binopt.xint)),dz);
    dist=cellfun(@(x)(sum(numel(find(isfinite(x))).*...
        gd.binopt.xint)),dz);
    volerr=[0;sdz.*dist];
    
    
    %mean rate
    
    idx1=find(isfinite(vols));
    volc=cumsum(vols(idx1));
    vol_rate=((vols(idx1(end))-vols(idx1(1))))/...
        ((dn(idx1(end))-dn(idx1(1)))/364.24);
    
    
    
    
else
    
    vols=[0;cellfun(@(x)(nansum(x.*gd.binopt.xint)),dz)];
        dist=cellfun(@(x)(sum(numel(find(isfinite(x))).*...
        gd.binopt.xint)),dz);
    volerr=[0;sdz.*dist];
    
    idx1=find(isfinite(vols));
    vol_rate=(vols(idx1(end))-vols(idx1(1)))/...
        ((dn(idx1(end))-dn(idx1(1)))/364.24);
    
end



%collect output
pstats.line_num=gd.lines(gd.pointer);
pstats.dates=dates;
switch anaopt.ana_type;
    case 1
        pstats.type='cumulative';
    case 2
        pstats.type='instantaneous';
end

pstats.dz=dz;
pstats.vol_dist=dist; %linear distance compared between profiles
%limit of measurements
pstats.vol_change=vols; %volume change m3/m
pstats.vol_error=volerr; %sigma *dx *xint
pstats.vol_avg_rate=vol_rate; %m3/yr
pstats.shore_x=cell2mat(xpos); %x position
pstats.shore_y=cell2mat(ypos);% y position
pstats.shore_change=spos; % cross-shore position
pstats.shore_avg_rate=shore_rate; %m/yr;

gd.pstats=pstats;
guidata(hf,gd);





