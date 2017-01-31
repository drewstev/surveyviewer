function ldata=extract_lines(data,linen)
% EXTRACT_LINES - read line data from elwha data structure
%
%   DATA  - data structure containing survey data
%   LINEN - line number (3-character string)

%sort the struct based on survey date
dn=arrayfun(@(x)(datenum(...
    x.survey_date,'mm/dd/yyyy')),data);
[~,ind]=sort(dn);
data=data(ind);

surveys=cellstr(datestr(unique(dn),'mm/dd/yyyy'));
cols=jet(length(surveys));

ldata=struct('number',linen,...
    'lnw_x',[],...
    'lnw_y',[],...
    'lines',[]);


ns=1;
dataout=[];
for i=1:length(surveys);
    tind=strmatch(surveys{i},arrayfun(@(x)(...
        x.survey_date),data,'uni',0),'exact');
    if ~isempty(tind)
        for j=1:length(tind)
            lind=strmatch(linen,{data(tind(j)).lines(:).number}',...
                'exact');
            if ~isempty(lind)
                if numel(lind)==1
                    
                    if isempty(ldata.lnw_x);
                        ldata.lnw_x=data(tind(j)).lines(lind).lnw_x;
                        ldata.lnw_y=data(tind(j)).lines(lind).lnw_y;
                    end
                    
                    dataout{ns}=struct('survey_type',...
                        data(tind(j)).survey_type,...
                        'survey_date',data(tind(j)).survey_date,...
                        'line_color',cols(i,:),...
                        'xyz',data(tind(j)).lines(lind).xyz,...
                        'dist',data(tind(j)).lines(lind).dist,...
                        'offset',data(tind(j)).lines(lind).offset);%#ok
                    ns=ns+1;
                else
                    
                    dataout{ns}=struct('survey_type',...
                        data(tind(j)).survey_type,...
                        'survey_date',data(tind(j)).survey_date,...
                        'line_color',cols(i,:),...
                        'xyz',{cellfun(@(x)(data(tind(j)).lines(x).xyz),...
                            num2cell(lind),'uni',0)'},...
                        'dist',{cellfun(@(x)(data(tind(j)).lines(x).dist),...
                            num2cell(lind),'uni',0)'},...
                        'offset',{cellfun(@(x)(data(tind(j)).lines(x).offset),...
                            num2cell(lind),'uni',0)'});%#ok
                     ns=ns+1;
                end
            end
        end
    end
end

ldata.lines=cell2mat(dataout);







