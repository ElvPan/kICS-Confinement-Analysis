function [croped,mask2]=cropSeriesIntoSquareWithinRangeofBinary(series,mask);

% find dimensions
[row,col]=find(mask);
rangey=max(row)-min(row);
rangex=max(col)-min(col);

if rangey<rangex
    if (round(mean(row))-round(rangex/2))>=1 && (round(mean(row))+round(rangex/2))<=size(series,1)
        croped=series(round(mean(row))-round(rangex/2):round(mean(row))+round(rangex/2),min(col):max(col),:);
        mask2=mask(round(mean(row))-round(rangex/2):round(mean(row))+round(rangex/2),min(col):max(col));
        
    elseif (round(mean(row))-round(rangex/2))<1
        croped=series(1:rangex,min(col):max(col),:);
        mask2=mask(1:rangex,min(col):max(col));
       
    elseif (round(mean(row))+round(rangex/2))>size(series,1)
        croped=series(size(series,1)-rangex:size(series,1),min(col):max(col),:);
        mask2=mask(size(series,1)-rangex:size(series,1),min(col):max(col));
        
    end
elseif rangey>rangex
    if (round(mean(col))-round(rangey/2))>=1 && (round(mean(col))+round(rangey/2))<=size(series,2)
        croped=series(min(row):max(row),round(mean(col))-round(rangey/2):round(mean(col))+round(rangey/2),:);
        mask2=mask(min(row):max(row),round(mean(col))-round(rangey/2):round(mean(col))+round(rangey/2));
        
    elseif (round(mean(col))-round(rangey/2))<1
        croped=series(min(row):max(row),1:rangey,:);
        mask2=mask(min(row):max(row),1:rangey);
        
    elseif (round(mean(col))+round(rangey/2))>size(series,2)
        croped=series(min(row):max(row),size(series,2)-rangey:size(series,2),:);
        mask2=mask(min(row):max(row),size(series,2)-rangey:size(series,2));
        
    end
end

