function local_writeShp(filename,data,linenum)

bpoints=any(isnan(data.xyz),2);
data.xyz(bpoints,:)=[];
data.dist(bpoints)=[];
data.offset(bpoints)=[];

npoints=size(data.xyz,1);
shp=repmat(struct('Geometry','Point',...
    'Line_num',linenum,...
    'Date',data.survey_date,...
    'Type',data.survey_type,...
    'X',[],...
    'Y',[],...
    'Z',[],...
    'Dist',[],...
    'Offline',[]),npoints,1);

x=num2cell(data.xyz(:,1));
y=num2cell(data.xyz(:,2));
z=num2cell(data.xyz(:,3));
offset=num2cell(data.offset);
dist=num2cell(data.dist);

[shp(:).X]=deal(x{:});
[shp(:).Y]=deal(y{:});
[shp(:).Z]=deal(z{:});
[shp(:).Dist]=deal(dist{:});
[shp(:).Offline]=deal(offset{:});

shapewrite(shp,filename)

        
        


