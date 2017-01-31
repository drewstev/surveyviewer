function import_background(hf,evnt) %#ok

gd=guidata(hf);

[file, pathname,fidx] = uigetfile( ...
    {'*.tif; *.jpg; *.png', 'Image Files (*.tif; *.jpg; *.png)'},...
    'Select Survey Files',gd.background_path);

if file==0
    return
end



switch fidx
    case 1
        filename=[pathname,file];
        im=imread(filename);
        z=size(im,3);
        if z>3;
            im=im(:,:,1:3);
        end
        
        wname=getworldfilename(file);
        
        
        if ~exist([pathname,wname],'file')
            gd.background_path=pathname;
            guidata(hf,gd)
            
            error(['Can''t find worldfile: ', wname,...
                '. Image will not be imported.']);
        else
            gd.nback=gd.nback+1;
            r=worldfileread([pathname,wname]);
            [xim,yim]=pixcenters(r,size(im));
        end
        
        
        gd.bck{gd.nback}=struct('type','image',...
            'im',im,...
            'xim',xim,...
            'yim',yim);
end


%basemaps
if gd.nback>0
    for i = 1:gd.nback
        switch gd.bck{i}.type
            case 'image'
                sh(i)=imagesc(gd.bck{i}.xim./1000,...
                    gd.bck{i}.yim./1000,gd.bck{i}.im,...
                    'parent',gd.axes2);
        end
    end
end
uistack(sh,'bottom')
set(gd.axes2,...
    'nextplot','add')
gd.background_path=pathname;
guidata(hf,gd)