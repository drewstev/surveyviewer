function exportShp(hf,evnt) %#ok

gd=guidata(hf);

ldata=gd.profile;
xyz=arrayfun(@(x)(x.xyz),ldata.lines,'un',0);

singles=cellfun(@(x)(~iscell(x)),xyz);
nsingle=sum(singles);
nreps=sum(cellfun(@(x)(length(x)),xyz(~singles)));
nprofiles=nsingle+nreps;

[filename,pathname] = uiputfile('*.shp', 'Save SHP-file As',...
    gd.outpath);

if filename==0
    return
end




%generate filenames
dates=datenum({ldata.lines(:).survey_date}');
type={ldata.lines(:).survey_type}';


fnames=cellfun(@(x,y)([strtok(filename,'.'),...
    datestr(x,'yy'),'_',datestr(x,'mmm'),...
    '_line',ldata.number,'_',y(1)]),...
    num2cell(dates),type,'un',0);
    

pnum=1;
for i=1:length(ldata.lines)
    linedata=ldata.lines(i);
    if singles(i)
        set(gd.str,'string',['Writing File (',...
            sprintf('%d/%d',pnum,nprofiles),'): ',fnames{i}],...
            'visible','on')
        drawnow
        local_writeShp([pathname,fnames{i}],linedata,ldata.number)
        pnum=pnum+1;
    else
        nreps=length(linedata.xyz);
        freps={fnames{i};cellfun(@(x)(cat(2,fnames{i},...
            sprintf('%0.0f',x))),num2cell(((1:nreps-1)+1)'),'un',0)};
        freps=cat(1,freps{:});
        
        for j=1:nreps
            set(gd.str,'string',['Writing File (',...
                sprintf('%d/%d',pnum,nprofiles),'): ',freps{j}],...
                'visible','on')
            drawnow
            repdata=linedata;
            repdata.xyz=linedata.xyz{j};
            repdata.dist=linedata.dist{j};
            repdata.offset=linedata.offset{j};
            local_writeShp([pathname,freps{j}],repdata,ldata.number)
            pnum=pnum+1;
        end
    end
end
        
set(gd.str,'visible','off')

gd.outpath=pathname;
guidata(hf,gd)
    

