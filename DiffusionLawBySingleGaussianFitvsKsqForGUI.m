function [results,fitted]=DiffusionLawBySingleGaussianFitvsKsqForGUI(ax,ax2,avecorr,tautouse,k2Values,timesize);
avecorr=avecorr(:,tautouse);
mycolors=jet(size(avecorr,2));
%fit 
% guess  from linear fit of first ~30 k^2 values
 minK=1;
 maxT=size(avecorr,2);
fitk=10;
for i=1:maxT
fitted=polyfit(k2Values(minK:fitk),log(squeeze(avecorr(minK:fitk,i))),1);
dtau(i)=fitted(1);
end
fitted=polyfit((tautouse)*timesize,-dtau,1);
DGuess=fitted(1);

%now full fit
cla(ax2)
ylim(ax2,[0,1])
xlim(ax2,[0,1])
ph = patch(ax2,[0 0 0 0],[0 0 1 1],[0.67578 1 0.18359]); %greenyellow
th = text(ax2,1,1,'Non-linear Fit 1 Component of kICS CF...0%','VerticalAlignment','bottom','HorizontalAlignment','right');
clear fitted
for i=1:size(avecorr,2)
    
 s= fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0],...
               'Upper',[1,Inf,1],...
               'Startpoint',[0.9 DGuess*tautouse(i)*timesize 0.1],...
               'Maxiter',10e3,...
               'MaxFunEvals',10e3,...
               'TolFun',10^-9,...
               'Robust','LAR');%,...
               %'TolX',10^-9);

g1 = fittype('a*exp(-b*x) + c','options',s);
%g2 = fittype('a*exp(-b*x) + c*exp(-(d*x)^2) + e','options',s);


xtofit=k2Values;
ytofit=squeeze(avecorr(:,i));

[cfun1,gof1,output1]=fit(xtofit,ytofit,g1);
%[cfun2,gof2,output2]=fit(xtofit,ytofit,g2);

% if gof1.adjrsquare>gof2.adjrsquare
% results{i,1}=cfun1;
% results{i,2}=gof1;
% results{i,3}=output1;
% elseif gof2.adjrsquare>gof1.adjrsquare
% results{i,1}=cfun2;
% results{i,2}=gof2;
% results{i,3}=output2;
% end
fitted(:,i)=feval(cfun1,xtofit);
% plotting
plot(ax,xtofit,ytofit,'Color',mycolors(i,:))
hold(ax,"on");
plot(ax,xtofit,fitted(:,i),'--','Color',mycolors(i,:))
hold(ax,"on");
% dtau(i)=cfun1.b;
% amp(i)=cfun1.a;
results{i,1}=cfun1;
results{i,2}=gof1;
results{i,3}=output1;
ph.XData = [0 i/size(avecorr,2)  i/size(avecorr,2) 0];
th.String = sprintf('Non-linear Fit 1 Component of kICS CF....0f%%',round(i/(size(avecorr,2))*100));
drawnow %update graphics
end
