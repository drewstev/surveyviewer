function zoomto(hf,evnt)%#ok

gd=guidata(hf);
set(gd.str,'string',...
    'Click and drag a box to zoom',...
    'visible','on');

k=waitforbuttonpress; %#ok
point1 = get(gca,'CurrentPoint');
finalRect = rbbox; %#ok
point2 = get(gca,'CurrentPoint');
point1 = point1(1,1:2);
point2 = point2(1,1:2);

set(gd.str,'visible','off');

xlimsN=sort([point1(1),point2(1)]);
ylimsN=sort([point1(2),point2(2)]);


if strcmpi(get(gd.viewtype2,'checked'),'on')
    set(gd.axes2,'xlim',xlimsN,'ylim',ylimsN);
    gd.xlimsn=xlimsN;
    gd.ylimsn=ylimsN;
else
    set(gd.axes1,'xlim',xlimsN,'ylim',ylimsN);
end
guidata(hf,gd);
