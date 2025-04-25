
function [image_data,specs]=readOMEFile_forGUI(ax2,path,FileName);

reader = bfGetReader([path  FileName]);
omeMeta = reader.getMetadataStore();
try
 specs.voxelSizeX = omeMeta.getPixelsPhysicalSizeX(0).value; % in µm
 specs.voxelSizeY = omeMeta.getPixelsPhysicalSizeY(0).value; % in µm
 specs.pixelSize=(str2double(specs.voxelSizeX)+str2double(specs.voxelSizeY))/2;
catch
   specs.pixelSize=1; 
end
 specs.sizex=omeMeta.getPixelsSizeX(0).getValue(); % image width, pixels;
specs.sizey=omeMeta.getPixelsSizeY(0).getValue(); % image height, pixels;
specs.TotImages=omeMeta.getPixelsSizeT(0).getValue(); %number of images
if omeMeta.getChannelCount(0)==1
try
specs.timeFrame=double(omeMeta.getPlaneDeltaT(0,1).value)-double(omeMeta.getPlaneDeltaT(0,0).value);
catch
 specs.timeFrame=1;
end
elseif omeMeta.getChannelCount(0)==2
 try
specs.timeFrame=double(omeMeta.getPlaneDeltaT(0,2).value)-double(omeMeta.getPlaneDeltaT(0,0).value);
catch
 specs.timeFrame=1;
 end
elseif omeMeta.getChannelCount(0)==3
 try
specs.timeFrame=double(omeMeta.getPlaneDeltaT(0,3).value)-double(omeMeta.getPlaneDeltaT(0,0).value);
catch
 specs.timeFrame=1;
 end
end
specs.numChannels=omeMeta.getChannelCount(0);
specs.stackSizeZ = omeMeta.getPixelsSizeZ(0).getValue();
%specs.NA=omeMeta.getObjectiveLensNA(0,0).doubleValue();
%specs.laser=omeMeta.getChannelExcitationWavelength(0, 0).value().doubleValue();

image_data=[];
cla(ax2)
ylim(ax2,[0,1])
xlim(ax2,[0,1])
ph = patch(ax2,[0 0 0 0],[0 0 1 1],[0.67578 1 0.18359]); %greenyellow
th = text(ax2,1,1,'Loading Image Series...0%','VerticalAlignment','bottom','HorizontalAlignment','right');

if omeMeta.getChannelCount(0)==1
    
      for dat=1:specs.TotImages
      plane=bfGetPlane(reader,dat);
      image_data(:,:,dat)=single(plane);
      ph.XData = [0 dat/specs.TotImages  dat/specs.TotImages 0];
      th.String = sprintf('Loading Image Series...%.0f%%',round(dat/specs.TotImages*100));
      drawnow %update graphics
      end

elseif omeMeta.getChannelCount(0)==2
      for dat=1:2*specs.TotImages
      plane=bfGetPlane(reader,dat);
      data(:,:,dat)=single(plane);
      ph.XData = [0 dat/specs.TotImages  dat/specs.TotImages 0];
      th.String = sprintf('Loading Image Series...%.0f%%',round(dat/specs.TotImages*100));
      drawnow %update graphics
      end
      
      for j=1:round(size(data,3)/2)
     image_data(:,:,1,j)=data(:,:,1+(j-1)*2);
     image_data(:,:,2,j)=data(:,:,j*2);
      end
     

     
elseif omeMeta.getChannelCount(0)==3
      for dat=1:3*specs.TotImages
      plane=bfGetPlane(reader,dat);
      data(:,:,dat)=single(plane);
      ph.XData = [0 dat/specs.TotImages  dat/specs.TotImages 0];
      th.String = sprintf('Loading Image Series...%.0f%%',round(dat/specs.TotImages*100));
      drawnow %update graphics
      end
      
      for j=1:round(size(data,3)/3)
     image_data(:,:,1,j)=data(:,:,1+(j-1)*3);
     image_data(:,:,2,j)=data(:,:,2+(j-1)*3);
     image_data(:,:,3,j)=data(:,:,j*3);
      end
end

image_data=single(image_data);