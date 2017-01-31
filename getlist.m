function dc=getlist(hf,evnt) %#ok

gd=guidata(hf);

survey_dates=arrayfun(@(x)(datenum(x.survey_date)),...
    gd.profile.lines)';
usurveys=unique(survey_dates);

stype={gd.profile.lines(:).survey_type}';


dc=cell(length(usurveys)+1,4);
for i=1:length(usurveys);
    idx=find(usurveys(i)==survey_dates);
    s2=stype(idx);
    nbathy=find(strcmpi('bathy',s2));
    ntopo=find(strcmpi('topo',s2));
    
    if isempty(nbathy)
        nbathy=0; 
    else
        bdata=gd.profile.lines(idx(nbathy));
        if iscell(bdata.xyz)
            nbathy=size(bdata.xyz,2);
        else
            nbathy=1;
        end
    end
    if isempty(ntopo)
        ntopo=0;
    else
        tdata=gd.profile.lines(idx(ntopo));
        if iscell(tdata.xyz)
            ntopo=size(tdata.xyz,2);
        else
            ntopo=1;
        end
    end
    
    dc(i+1,3)={sprintf('%0.0f',nbathy)};
    dc(i+1,4)={sprintf('%0.0f',ntopo)};
end
dc(1,1)={'Survey #'};
dc(1,2)={'Survey Date'};
dc(1,3)={'Num. Bathy Files'};
dc(1,4)={'Num. Topo Files'};

dc(2:end,2)=cellstr(datestr(usurveys,'mm/dd/yyyy'));
dc(2:end,1)=cellfun(@(x)(sprintf('%0.0f',x)),...
    num2cell((1:length(usurveys))'),'un',0);

