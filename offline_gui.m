function offopt = offline_gui(varargin)


if ~isempty(varargin)
    offopt=varargin{1};
else
    offopt.use_offline=0;
    offopt.max_off=[];
end

hf2 = figure('units','normalized','position',[0.332 0.785 0.114 0.134],...
    'menubar','none','name','offline_gui',...
    'numbertitle','off','color',[0.94 0.94 0.94]);

gd2.done = uicontrol(hf2,'style','pushbutton',...
    'units','normalized','position',[0.558 0.122 0.296 0.186],....
    'string','OK','backgroundcolor',[0.94 0.94 0.94],...
    'callback',@run_offline,'enable','off');
gd2.cancel = uicontrol(hf2,'style','pushbutton',...
    'units','normalized','position',[0.21 0.122 0.296 0.186],...
    'string','Cancel','backgroundcolor',[0.94 0.94 0.94],...
    'callback',@cancel_offline);

gd2.edit = uicontrol(hf2,'style','edit','units','normalized',...
    'position',[0.524 0.413 0.33 0.169],'string',...
    sprintf('%0.1f',offopt.max_off),'backgroundcolor',[1 1 1],...
    'callback',@use_offline);
if offopt.use_offline
    set(gd2.edit,'enable','on');
    if ~isnan(str2double(get(gd2.edit,'string')))
        set(gd2.done,'enable','on')
    end
else
    set(gd2.edit,'enable','off')
end
uicontrol(hf2,'style','text','units','normalized',...
    'position',[0.124 0.407 0.3 0.174],'string','Max. Offline Dist. (m)',...
    'backgroundcolor',[0.94 0.94 0.94]);
gd2.offline = uicontrol(hf2,'style','checkbox','units',...
    'normalized','position',[0.146 0.703 0.708 0.134],...
    'string','Remove Offline','backgroundcolor',[0.94 0.94 0.94],...
    'value',offopt.use_offline,'callback',@use_offline);

gd2.offopt=offopt;
guidata(hf2,gd2)
uiwait


gd2=guidata(hf2);
offopt=gd2.offopt;
close(hf2);
%%%%---------------------------------------------------------
function run_offline(hf2,evnt) %#ok

gd2=guidata(hf2);

gd2.offopt.use_offline=get(gd2.offline,'value');
if gd2.offopt.use_offline
    gd2.offopt.max_off=str2double(get(gd2.edit,'string'));
else
    gd2.offopt.max_off=[];
end
guidata(hf2,gd2)
uiresume
%%%%---------------------------------------------------------
function use_offline(hf2,evnt)%#ok
gd2=guidata(hf2);

gd2.offopt.use_offline=get(gd2.offline,'value');
if gd2.offopt.use_offline;
    set(gd2.edit,'enable','on')
    if ~isnan(str2double(get(gd2.edit,'string')))
        set(gd2.done,'enable','on')
    end
else
    set(gd2.edit,'enable','off')
end
%%%%----------------------------------------------------------------
function cancel_offline(hf2,evnt)
uiresume