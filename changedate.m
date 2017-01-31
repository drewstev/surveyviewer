function date=changedate(hf,evnt) %#ok

gd=guidata(hf);
gd.date=uical(datenum(get(gd.sdate,'string')));

set(gd.sdate,'string',datestr(gd.date));

guidata(hf,gd)