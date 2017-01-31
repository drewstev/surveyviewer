function measure_dist(hf,evnt) %#ok

gd=guidata(hf);
viewt=get(gd.viewtype1,'checked');
if strcmpi(viewt,'on')
    gc=gd.axes1;
    gd.ur=1;
else 
    gc=gd.axes2;
    gd.ur=1000;
end
set(gd.str,'string',...
    'Click and drag to measure distance',...
    'visible','on');
        

waitforbuttonpress;



cc = get(gc,'CurrentPoint');
gd.xy1 = cc(1,1:2);

hold on
guidata(hf,gd)

set(hf,'WindowButtonMotionFcn',@lmotion);
set(hf,'WindowButtonUpFcn',@ldone);


uiwait

%%%%--------------------------------------------------------------

function lmotion(hf,evnt) %#ok
%LMOTION- callback for buttondown
gd=guidata(hf);

viewt=get(gd.viewtype1,'checked');
if strcmpi(viewt,'on')
    gc=gd.axes1;
else 
    gc=gd.axes2;
end


mousenew = get(gc,'CurrentPoint');
gd.xy2 = mousenew(1,1:2);

xd = gd.xy2(1) - gd.xy1(1); 
yd = gd.xy2(2) - gd.xy1(2); 
dist=sqrt(xd.*xd +yd.*yd)';



if isfield(gd,'l1')
    set(gd.l1,'xdata',[gd.xy1(1) gd.xy2(1)],...
        'ydata',[gd.xy1(2) gd.xy2(2)]);
   
    
else
    gd.l1=line([gd.xy1(1) gd.xy2(1)],...
        [gd.xy1(2) gd.xy2(2)]);
    set(gd.l1,'color','r')
    
    
end

set(gd.str,'string',sprintf(['dx = %.1f, ',...
    'dy = %0.1f ,distance = %0.1f'],...
     xd.*gd.ur,yd.*gd.ur,dist.*gd.ur));

guidata(hf,gd)

%----------------------------------------------------------

function ldone(hf,evnt) %#ok
%LDONE- callback for buttonup
gd=guidata(hf);

delete(gd.l1);

set(hf,'WindowButtonMotionFcn',[]);
set(hf,'WindowButtonUpFcn',[]);

set(gd.str,'visible','off')
set(hf,'pointer','arrow')
gd=rmfield(gd,'l1');
guidata(hf,gd)
uiresume