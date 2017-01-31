function opt = binmenu(varargin)

if ~isempty(varargin)
    opt=varargin{1};
else 
    opt.use_offline='bin';
    opt.xint=3;
    opt.fillgaps=0;
    opt.maxgap=5;
    
    
end

switch opt.type
    case 'bin'
        pval=1;
    case 'interp'
        pval=2;
end

hf = figure('units','normalized','position',[0.27 0.351 0.292 0.389],...
    'menubar','none','name','binmenu','numbertitle','off',...
    'color',[0.941 0.941 0.941]);


text1 = uicontrol(hf,'style','text','units','normalized',...
    'position',[0.0875 0.64 0.27 0.081],...
    'string','Interval (m)','backgroundcolor',[0.941 0.941 0.941]);
gd.interval = uicontrol(hf,'style','edit','units','normalized',...
    'position',[0.445 0.638 0.359 0.1],'string',sprintf('%0.0f',opt.xint),...
    'backgroundcolor',[1 1 1]);


gd.pop1 = uicontrol(hf,'style','popupmenu','units',...
    'normalized','position',[0.445 0.757 0.359 0.121],...
    'string',{'Bin Average';'Interpolate'},...
    'value',pval,'backgroundcolor',[1 1 1]);
text2 = uicontrol(hf,'style','text','units','normalized',...
    'position',[0.0875 0.798 0.27 0.081],'string','Method',...
    'backgroundcolor',[0.941 0.941 0.941]);


uipanel1 = uipanel('parent',hf,'units','normalized',...
    'position',[0.0875 0.205 0.716 0.39],'title','Interpolate Gaps?');
gd.check1 = uicontrol(uipanel1,'style','checkbox','units',...
    'normalized','position',[0.136 0.789 0.365 0.19],...
    'string','Fill Missing Data','backgroundcolor',[0.941 0.941 0.941],...
    'value',opt.fillgaps,'callback',@fillaction);
gd.maxgap = uicontrol(uipanel1,'style','edit','units','normalized',...
    'position',[0.426 0.347 0.506 0.286],'string',sprintf('%0.0f',opt.maxgap),...
    'backgroundcolor',[1 1 1],'enable','off');
if opt.fillgaps==1
    set(gd.maxgap,'enable','on')
end

text3 = uicontrol(uipanel1,'style','text','units','normalized',...
    'position',[0.0304 0.204 0.308 0.354],'string','Max. Gap Length (m):',...
    'backgroundcolor',[0.941 0.941 0.941]);


pushbutton1 = uicontrol(hf,'style','pushbutton','units','normalized',...
    'position',[0.325 0.0429 0.243 0.1],'string','Done',...
    'backgroundcolor',[0.941 0.941 0.941],'callback',@close_binmenu);

guidata(hf,gd)

uiwait
gd=guidata(hf);
opt=gd.binopt;
close(hf);

