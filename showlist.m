function showlist(hf,evnt) %#ok

gd=guidata(hf);

if strcmpi(get(gd.filelist,'checked'),'on')
    set(gd.filelist,'checked','off')
    delete(gd.hf2)
    return
end

hf2 = figure('units','normalized',...
    'position',[0.1 0.0797 0.3 0.7],...
    'menubar','none','name','File List',...
    'numbertitle','off','color',[0.941 0.941 0.941],...
    'closerequestfcn',@closelist);


if isfield(gd,'listdata')
    dc=gd.listdata;
else
    dc=getlist(hf);
    
end


mtable=uitable(hf2,'Data',dc);
set(mtable,'units','normalized','position',[0.1 0.1 0.8 0.8]);
set(hf2,'units','pixels');
pix=get(hf2,'position');

cwidth=floor([0.125 0.125 0.275 0.275].*pix(3));
set(mtable,'columnwidth',num2cell(cwidth))

set(gd.filelist,'checked','on')

gd.listdata=dc;
gd.listh=mtable;
gd.hf2=hf2;
guidata(hf,gd);




    
    

