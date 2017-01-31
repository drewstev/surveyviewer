function cpfcn(hf,evnt)
gd=guidata(hf);
pan off
switch evnt.Character
    case 'z'
        zoomto(hf)  
    case 'f'
        fullExtents(hf)
    case 'm'
        measure_dist(hf)
end