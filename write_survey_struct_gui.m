function write_survey_struct_gui(hf,evnt) %#ok

gd=guidata(hf);

str=lower(get(gd.pop1,'string'));
stype=str(get(gd.pop1,'value'));
sdate=datenum(get(gd.sdate,'string'));
files=gd.files1;
 
set(gd.status,'string',sprintf('Converting %d files....Please Wait.',...
    length(files)),'visible','on')
drawnow
 
dout=gd.outputfile;
lnw=readLNW('filename',gd.lnwfile);



xyz=cellfun(@(x)(load(x)),files,'uni',0);


fmt1=get(gd.prefix,'string');
fmt2=get(gd.suffix,'string');

%deal with parsing the line numbers from the file names
[~,fnames] = cellfun(@(x)(fileparts(x)),files,'un',0);

if isempty(fmt2)
    line_nums=cellfun(@(x)(textscan(x,[fmt1,'%f'])),fnames);
    lines=cellfun(@(x)(sprintf('%3.3d',x)),line_nums,'un',0);
    
    lnums=cellfun(@(x)(sprintf('%3.3d',str2double(x))),...
    {lnw(:).name}','un',0);
else
    pat=[fmt1,'(\w+)',fmt2];
    line_nums=cellfun(@(x)(regexp(x,pat,'tokens')),fnames);
    lines=cat(1,line_nums{:});
    
    lnums={lnw(:).name}';
    
    [r,c]=strtok(lnums,'_');
    lnw_line=cellfun(@(x)(sprintf('%03.3s',x)),r,'un',0);
    lnumsc=cellfun(@(x,y)([x,y]),lnw_line,c,'un',0);
    
    
end


% match lines to linefile
lind=cellfun(@(x)(strmatch(x,lnumsc,'exact')),...
    lines,'uni',0);
lmatch=cellfun(@(x)(~isempty(x)),lind);
lind(~lmatch)={0};

lgood=cell2mat(lind(lmatch));


%calculate along-line distance
tol=20;
[xyzout,dist,offset]=cellfun(@(x,y)(line_tform2(...
    x,lnw,y,tol,1000)),xyz(lmatch),lind(lmatch),'uni',0);


%write data structure
data.survey_type=stype{:};
data.survey_date=datestr(sdate,'mm/dd/yyyy');
data.lines=repmat(struct('number',[],'lnw_x',[],...
    'lnw_y',[],'xyz',[],'dist',[],'offset',[]),...
    length(lgood),1);
[data.lines(:).number]=deal(lines{lmatch});
[data.lines(:).xyz]=deal(xyzout{:});


lnw_x=arrayfun(@(x)(x.x),lnw(lgood),'uni',0);
[data.lines(:).lnw_x]=deal(lnw_x{:});
lnw_y=arrayfun(@(x)(x.y),lnw(lgood),'uni',0);
[data.lines(:).lnw_y] =deal(lnw_y{:});

[data.lines(:).dist]=deal(dist{:});
[data.lines(:).offset]=deal(offset{:});


save(dout,'data')

set(gd.status,'string',sprintf('Files Successfully Converted'))

