function opt=close_binmenu(hf,evnt) %#ok

gd=guidata(hf);

val=get(gd.pop1,'value');
switch val
    case 1
        gd.binopt.type='bin';
    case 2
        gd.binopt.type='interp';
end

gd.binopt.xint=str2double(get(gd.interval,'string'));
gd.binopt.fillgaps=get(gd.check1,'value');
gd.binopt.maxgap=str2double(get(gd.maxgap,'string'));

guidata(hf,gd)
uiresume