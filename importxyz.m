function importxyz(hf,evt) %#ok
% The basic layout of this GUI was made with the help of guidegetter,
% available on the File Exchange at Mathworks.com

hf = figure('units','normalized','position',[0.253 0.296 0.273 0.328],...
    'menubar','none','name','importxyz',...
    'numbertitle','off','color',[0.941 0.941 0.941]);




gd.xyzfiles = uicontrol(hf,'style','listbox','units','normalized',...
    'position',[0.302 0.831 0.591 0.0833],'string','Select XYZ files',...
    'backgroundcolor',[1 1 1]);
gd.openxyz = uicontrol(hf,'style','pushbutton','units','normalized',...
    'position',[0.0875 0.833 0.18 0.0857],'string','Open',...
    'backgroundcolor',[0.941 0.941 0.941],'callback',...
    @local_open1);


gd.openlnw = uicontrol(hf,'style','pushbutton','units','normalized',....
    'position',[0.0875 0.705 0.18 0.0857],'string','Open',...
    'backgroundcolor',[0.941 0.941 0.941],'callback',@loadlnw);
gd.linefile = uicontrol(hf,'style','text','units','normalized',...
    'position',[0.305 0.721 0.587 0.0524],'string','Select Line File',...
    'backgroundcolor',[1 1 1],'horizontalalignment','left');

uicontrol(hf,'style','text','units','normalized',...
    'position',[0.0675 0.53 0.2 0.0595],'string','XYZ File Suffix, no ext. (opt.)',...
    'backgroundcolor',[0.941 0.941 0.941]);
gd.suffix = uicontrol(hf,'style','edit','units','normalized',...
    'position',[0.304 0.54 0.587 0.0619],'string','',...
    'backgroundcolor',[1 1 1],'horizontalalign','left');


uicontrol(hf,'style','text','units','normalized',...
    'position',[0.0875 0.62 0.18 0.0595],'string','XYZ File Prefix',...
    'backgroundcolor',[0.941 0.941 0.941]);
gd.prefix = uicontrol(hf,'style','edit','units','normalized',...
    'position',[0.304 0.63 0.587 0.0619],'string','',...
    'backgroundcolor',[1 1 1],'horizontalalign','left');

gd.date=floor(now);
gd.changedate = uicontrol(hf,'style','pushbutton','units','normalized',...
    'position',[0.0875 0.436 0.18 0.0857],'string',...
    'Select Survey Date','backgroundcolor',[0.941 0.941 0.941],...
    'callback',@changedate);
gd.sdate = uicontrol(hf,'style','text','units','normalized',...
    'position',[0.304 0.448 0.587 0.0524],...
    'string',datestr(gd.date),'backgroundcolor',[1 1 1],...
    'horizontalalignment','left');


uicontrol(hf,'style','text','units','normalized',...
    'position',[0.0857 0.321 0.18 0.0595],'string','Survey Type',...
    'backgroundcolor',[0.941 0.941 0.941]);
gd.pop1 = uicontrol(hf,'style','popupmenu','units','normalized',...
    'position',[0.304 0.338 0.32 0.0524],...
    'string',{'Bathy';'Topo'},'backgroundcolor',[1 1 1]);


gd.save = uicontrol(hf,'style','pushbutton','units','normalized',...
    'position',[0.0875 0.198 0.18 0.0857],'string','Save',...
    'backgroundcolor',[0.941 0.941 0.941],'callback',@savemat);
gd.fileout = uicontrol(hf,'style','text','units','normalized',...
    'position',[0.304 0.21 0.587 0.0524],'string','Select Output File Destination',...
    'backgroundcolor',[1 1 1],'horizontalalignment','left');


gd.done = uicontrol(hf,'style','pushbutton','units','normalized',...
    'position',[0.42 0.0752 0.18 0.0857],'string','Import',...
    'backgroundcolor',[0.941 0.941 0.941],'enable','off',...
    'callback',@write_survey_struct_gui);

gd.status= uicontrol(hf,'style','text','units','normalized',...
    'position',[0.0857 0.01 0.8 0.05],'string','',...
    'backgroundcolor',[0.941 0.941 0.941],...
    'foregroundcolor','r','visible','off');

gd.fpath=[pwd,filesep];

guidata(hf,gd);