function [] = surveyviewer(varargin)

gd.ver=1.01;
gd.modified='1/30/2017';

hf = figure('units','normalized',...
    'position',[0.253 0.0797 0.496 0.546],...
    'menubar','none','name','surveyviewer',...
    'numbertitle','off','color',[0.941 0.941 0.941],...
    'KeyReleaseFcn',@cpfcn);


gd.tabgroup  =  uitabgroup(hf,'Position',[.05 .125 .9 .85],'visible','off');
gd.ptab = uitab(gd.tabgroup,'title','Profile','buttondownfcn',@viewtype1);
uicontrol(gd.ptab,'style','text','string','Data Type',...
    'units','normalized','position',[0.01 0.01 0.1 0.045]);
gd.pdt=uicontrol(gd.ptab,'style','popup','units','normalized',...
    'position',[0.115 0.01 0.15 0.05],'string',...
    {'Elevation';'Binned Elevation';'Elevation Change'},...
    'callback',@plotProf);

gd.mtab = uitab(gd.tabgroup,'title','Map','buttondownfcn',@viewtype2);
gd.ttab = uitab(gd.tabgroup,'title','Time-series','buttondownfcn',@viewtype3);

gd.axes1 = axes(gd.ptab,'position',[0.06 0.207 0.85 0.75],'visible','off');
gd.axes2 = axes(gd.mtab,'position',[0.06 0.207 0.85 0.75],'visible','off');
set(gd.axes2,'da',[1 1 1],...
    'ydir','n',...
    'nextplot','add')

gd.axes3(1)=subplot(211,'parent',gd.ttab);
gd.axes3(2)=subplot(212,'parent',gd.ttab);
set(gd.axes3,'visible','off')

gd.push1 = uicontrol(hf,'style','pushbutton','units',...
    'normalized','position',[0.0482 0.035 0.0728 0.0629],...
    'string','<<<','backgroundcolor',[0.941 0.941 0.941],...
    'enable','off','callback',@select_prof1);
gd.edit1 = uicontrol(hf,'style','edit','units','normalized',...
    'position',[0.125 0.035 0.0797 0.0601],'string','---',...
    'backgroundcolor',[1 1 1],'enable','off','callback',@select_prof2);
gd.push2 = uicontrol(hf,'style','pushbutton','units',...
    'normalized','position',[0.208 0.035 0.0728 0.0629],...
    'string','>>>','backgroundcolor',[0.941 0.941 0.941],...
    'enable','off','callback',@select_prof1);

gd.str=uicontrol(hf,'style','text','units','normalized',...
    'position',[0.0482 0.01 0.3 0.02],'string',...
    'Select File->Open to begin','horizontalalign','left');



gd.file=uimenu('label','File');
gd.load=uimenu(gd.file,'label','Open','callback',@surveyviewer_open);
gd.import=uimenu(gd.file,'label','Import');
gd.importxyz=uimenu(gd.import,'Label','XYZ Files',...
    'callback',@importxyz);
gd.import_background=uimenu(gd.import,'label','Background Maps',...
    'callback',@import_background);
gd.export=uimenu(gd.file,'label','Export','enable','off');
gd.exportwk=uimenu(gd.export,'label','To Workspace','callback',...
    @exportToWorkspace);
gd.exportmat=uimenu(gd.export,'label','MAT-File','callback',@exportToMat);
gd.exportshp=uimenu(gd.export,'label','SHP-File','callback',@exportShp);


gd.view=uimenu('label','View','enable','off');
gd.viewtype1=uimenu(gd.view,'label','Profile','callback',@viewtype1,...
    'checked','on');
gd.viewtype2=uimenu(gd.view,'label','Map','callback',@viewtype2,...
    'checked','off');
gd.viewtype3=uimenu(gd.view,'label','Time-series','callback',@viewtype3,...
    'checked','off');
gd.hf2=[];


gd.options=uimenu('label','Options','enable','off');
gd.binopts=uimenu(gd.options,'label','Bin Options',...
    'callback',@run_bin_menu);
gd.offline_opts=uimenu(gd.options,'label','Offline Options',...
    'callback',@run_offline_menu);
gd.vol_shore_opts=uimenu(gd.options,'label','Analysis Options',...
    'callback',@run_analysis_menu);

gd.helpmenu=uimenu('label','Help');
uimenu(gd.helpmenu,'label','About','callback',@dispHelp)


gd.outpath=[pwd,filesep];
gd.background_path=[pwd,filesep];
gd.nback=0;
gd.bindata=[];
gd.pstats=[];

%binning defaults
gd.bin=0;
gd.binopt.type='bin';
gd.binopt.xint=2;
gd.binopt.fillgaps=0;
gd.binopt.maxgap=5;

%offline defaults
gd.offopt.use_offline=0;
gd.offopt.max_off=[];

%analysis (shoreline and volume change) options
gd.anaopt.ana_type=1;
gd.anaopt.ana_vc_unc=0.05;
gd.anaopt.ana_shore_ref=2;

guidata(hf,gd)
