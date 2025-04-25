

function [windseries]=hann2DbetaPower(series,power);

%this function creates applies Hann on all dimensions of the series...
Hann=hann(size(series,1));
Hann=Hann.^power;

for i=1:size(series,2)
Hann1(:,i)=Hann;
end
clear Hann

Hann=hann(size(series,2));
Hann=Hann.^power;
for i=1:size(series,1)
Hann2(i,:)=Hann;
end
clear Hann

% Hann=hann(size(series,3));
% for i=1:size(series,1)
% Hann3(i,:)=Hann;
% end
% clear Hann

windseries=single(zeros(size(series)));
for i=1:size(series,3);
windseries(:,:,i)=series(:,:,i).*Hann1.*Hann2;
end
% 
% for i=1:size(series,2);
% windseries(:,i,:)=squeeze(windseries(:,i,:)).*Hann3;
% end