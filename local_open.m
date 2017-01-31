function local_open(hf,evnt) %#ok

gd=guidata(hf);

if isfield(gd,'data');
    gd=rmfield(gd,'data'); 
    gd=rmfield(gd,'lnw');
end


[files, pathname] = uigetfile( ...
    {'*.mat', 'MAT Files (*.mat)'},...
    'Select Survey Files',...
    'multiselect','on');
if ~iscell(files)
    if isequal(files,0)
        return
    end
end
if ischar(files), files={files}; end

set(gd.str,'visible','on','string','Reading Data Files. Please Wait.',...
    'foregroundcolor','r');
drawnow

%load files
gd.data=arrayfun(@(x)(x.data),...
    cellfun(@(x)(load([pathname,x])),files));
set(gd.str,'string','Building Source Table')
drawnow


%build a list of all lines that were surveyed (ala linefile)
nfiles=length(files);
lnums=cell(nfiles,1);
lx=cell(nfiles,1);
ly=cell(nfiles,1);
for i=1:nfiles
    lnums{i}=arrayfun(@(x)(x.number),gd.data(i).lines,'un',0);
    lx{i}=arrayfun(@(x)(x.lnw_x),gd.data(i).lines,'un',0);
    ly{i}=arrayfun(@(x)(x.lnw_y),gd.data(i).lines,'un',0);
end
%combine
all_lines=cat(1,lnums{:});
all_lx=cat(1,lx{:});
all_ly=cat(1,ly{:});
[lines,idx]=unique(all_lines);
lx=all_lx(idx);
ly=all_ly(idx);

gd.lnw(length(lines))=struct('name',[],...
    'x',[],'y',[]);
[gd.lnw(:).name]=deal(lines{:});
[gd.lnw(:).x]=deal(lx{:});
[gd.lnw(:).y]=deal(ly{:});
set(gd.str,'visible','off')
set(gd.edit1,'string',gd.lnw(1).name);


arrayfun(@(x)(plot(x.x./1000,x.y./1000,'k-',...
    'parent',gd.axes2)),...
    gd.lnw,'un',0);


gd.prof=gd.lnw(1).name;
gd.lines=lines;
gd.fInd=1:length(gd.lnw);
gd.pointer=1;
set(gd.tabgroup,'visible','on')
set(gd.axes1,'visible','on');
set(gd.axes2,'visible','on')
set(gd.edit1,'enable','on');
set(gd.push2,'enable','on');
set(gd.export,'enable','on')
set(gd.view,'enable','on')
set(gd.options,'enable','on')


guidata(hf,gd);
set(gd.tabgroup,'selectedtab',gd.ptab)
plotProf(hf);

