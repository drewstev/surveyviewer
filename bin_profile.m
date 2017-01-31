function sdata = bin_profile(varargin)
% data - from survey struct mat files (multiple or single)
% lnum - line number
% xint - bin interval along profile (m)
% method - 'bin' or 'interp'
%
% Example:
%
% dname='E:\data\projects\elwha\data\bathymetry\database\matFiles\';
% files=dir([dname,'*.mat']);
% data=arrayfun(@(x)(x.data),...
%    arrayfun(@(x)(load([dname,x.name])),files));
%
% sdata=bin_profile(data,'160',1)


%deal with inputs
p=inputParser;

required={'ldata';...
    'xint'};
validators={'@(y) isstruct(y)';...
    '@(y) isnumeric(y)'};
for i=1:length(required)
    addRequired(p,required{i},str2func(validators{i}));
end

opts={'method','bin';...
    'maxgap',0};
cellfun(@(x)(p.addParamValue(x{1},x{2})),num2cell(opts,2));


p.parse(varargin{:})
opt=p.Results;
validatestring(opt.method, {'interp','bin'},'test','method');

[ldata,xint]=deal(opt.ldata,opt.xint);
%%%%done with inputs

%sort the data by survey
dates=arrayfun(@(x)(x.survey_date),ldata.lines,'un',0)';

dn=datenum(dates,'mm/dd/yyyy');
udn=unique(dn);
n=length(udn);

fields={'xyz','dist','offset'};
rdata=repmat(struct(fields{1},[],...
    fields{2},[],fields{3},[]),n,1);

for i = 1:n
    
    for j = 1:length(fields)
        fdata=arrayfun(@(x)(x.(fields{j})),...
            ldata.lines(dn==udn(i)),'un',0)';
        
        cidx=cellfun(@(x)(iscell(x)),fdata); %deal with replicates (cells)
        fdata(cidx)=cellfun(@(x)(cat(1,x{:})),fdata(cidx),'un',0);
        rdata(i).(fields{j})=cell2mat(fdata);
    end
end


% %find the extents of the distance vec
dist=cell2mat(arrayfun(@(x)(x.dist),rdata,'un',0));
xi=(min(dist):xint:max(dist))';




sdata=repmat(struct('line_number',ldata.number,...
    'lnw_x',ldata.lnw_x,...
    'lnw_y',ldata.lnw_y,...
    'survey_date',[],...
    'x',[],...
    'y',[],...
    'z',[],...
    'dist',xi,...
    'offset',[]),n,1);


%bin-average along the profile
switch opt.method
    case 'bin'
        [~,bin]=arrayfun(@(x)(histc(x.dist,xi)),rdata,'un',0);
        x=cellfun(@(x,y)(accumarray(x(x~=0),y(x~=0),...
            [numel(xi) 1],@nanmean,NaN)),bin,...
            arrayfun(@(x)(x.xyz(:,1)),rdata,'un',0),'un',0);
        y=cellfun(@(x,y)(accumarray(x(x~=0),y(x~=0),...
            [numel(xi) 1],@nanmean,NaN)),bin,...
            arrayfun(@(x)(x.xyz(:,2)),rdata,'un',0),'un',0);
        z=cellfun(@(x,y)(accumarray(x(x~=0),y(x~=0),...
            [numel(xi) 1],@nanmean,NaN)),bin,...
            arrayfun(@(x)(x.xyz(:,3)),rdata,'un',0),'un',0);
        offset=cellfun(@(x,y)(accumarray(x(x~=0),y(x~=0),...
            [numel(xi) 1],@nanmean,NaN)),bin,...
            arrayfun(@(x)(x.offset),rdata,'un',0),'un',0);
    case 'interp'
        [dsort,didx]=arrayfun(@(x)(unique(x.dist)),rdata,'un',0);
        xyz=arrayfun(@(x)(x.xyz),rdata,'un',0);
        offset=arrayfun(@(x)(x.offset),rdata,'un',0);
        idata=cellfun(@(x,y)(x(y,:)),xyz,didx,'un',0);
        odata=cellfun(@(x,y)(x(y)),offset,didx,'un',0);
        
        x=cellfun(@(x,y)(interp1(x(all(isfinite(y),2)),...
            y(all(isfinite(y),2),1),xi)),dsort,idata,'un',0);
        y=cellfun(@(x,y)(interp1(x(all(isfinite(y),2)),...
            y(all(isfinite(y),2),2),xi)),dsort,idata,'un',0);
        z=cellfun(@(x,y)(interp1(x(all(isfinite(y),2)),...
            y(all(isfinite(y),2),3),xi)),dsort,idata,'un',0);
        offset=cellfun(@(x,y)(interp1(x(all(isfinite(y),2)),...
            y(all(isfinite(y),2)),xi)),dsort,odata,'un',0);
end


if opt.maxgap>0;
    
    %fill gaps less than max value
    gaps=cellfun(@(x)(isnan(x(1:end-1))),z,'un',0);
    for i=1:length(gaps)
        if isempty(gaps{i})~=1;
            [c,ind]=getchunks(gaps{i},'-full');
            bind=find(isnan(z{i}(ind))==1);
            
            bstart=ind(bind)-1;
            bind(bstart==0)=[];
            bstart(bstart==0)=[];
            
            
            bend=bsxfun(@plus,bstart,c(bind)+1);
            
            gap_dist=cellfun(@(x,y)(abs(xi(y)-...
                xi(x))),...
                num2cell(bstart),num2cell(bend));
            
            fillGaps=find(gap_dist<opt.maxgap);
            fillStart=bstart(fillGaps);
            fillEnd=bend(fillGaps);
            
            
            for j=1:numel(fillGaps)
                
                z{i}(fillStart(j):fillEnd(j))=...
                    interp1([xi(fillStart(j));...
                    xi(fillEnd(j))],...
                    [z{i}(fillStart(j));z{i}(fillEnd(j))],...
                    xi(fillStart(j):fillEnd(j)));
            end
            
        end
    end
end

%collect output
udates=cellstr(datestr(udn,'mm/dd/yyyy'));
[sdata(:).survey_date]=deal(udates{:});
[sdata(:).x]=deal(x{:});
[sdata(:).y]=deal(y{:});
[sdata(:).z]=deal(z{:});
[sdata(:).offset]=deal(offset{:});













