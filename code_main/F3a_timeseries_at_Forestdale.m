%% Figure 3a Forestdale analysis
% Written by Yiwen Fang, 2022

% Month and WYs 
WYs=2003:2021;
Month_tick={'','1 NOV','','1 JAN','', '1 MAR','','1 MAY','','1 JUL','','1 SEP'};

DATA_PATH='../data/2_Soil_Moisture/';
% load soil moisture data at FDC
load([DATA_PATH 'SMS_CA_WY2003_2021'])

% load SWE and streamflow data at FDC
load([DATA_PATH 'FDC_data'])

% Extract soil moisture at Forestdale (1049) site
isite=find(SMS_CA.station_id==1049);
FDC_d2=SMS_CA.SMS_d2(:,:,isite); % 2 inches (5 cm)
FDC_d8=SMS_CA.SMS_d8(:,:,isite); % 8 inches (20 cm)
FDC_d20=SMS_CA.SMS_d20(:,:,isite); % 20 inches (50 cm)

% Compute averaged soil moisture
% depth of 3 layers 10 cm (0-10 cm), 20 cm (10-30 cm), 40 cm(30 - 70 cm)
d2=10;d8=20;d20=40; 
FDC_ave=(d2*FDC_d2+d8*FDC_d8+d20*FDC_d20)/(d2+d8+d20);

% Define colors for two years
color1=[21 67 96]/255;
color2=[194 10 10]/255;
%% Plot time series of SWE, VWC and streamflow at Forestdale
% Define datetime
NM=datenum(2019,10,1):datenum(2020,9,30);

% Extract peak SWE, peak SWE days and melt out day
year_se=2017;
iyear=find(year_se==WYs);
[~,peakday1]=max(FDC_SWE(:,end)); % peak SWE in WY 2021
[~,peakday2]=max(FDC_SWE(:,iyear)); % peak SWE in WY 2017
meltoutday1=find(FDC_SWE(peakday1:end,end)==0,1,'first')+peakday1; % melt-out day in WY 2021
meltoutday2=find(FDC_SWE(peakday2:end,iyear)==0,1,'first')+peakday2; % melt-out day in WY 2017

% Find snow onset date (first day when SWE is greater than 1 cm for at least 5 continuous days)
thre=0.01; % 1cm
dummy=FDC_SWE(:,end); % WY 2021
idx = dummy>thre & [dummy(2:end)>thre;false] &  [dummy(3:end)>thre;false;false] &...
    [dummy(4:end)>thre;false;false; false] & [dummy(5:end)>thre;false;false;false;false];
Idate1=find(idx==1,1,'first');

dummy=FDC_SWE(:,iyear); % WY 2017
idx = dummy>thre & [dummy(2:end)>thre;false] &  [dummy(3:end)>thre;false;false] &...
    [dummy(4:end)>thre;false;false; false] & [dummy(5:end)>thre;false;false;false;false];
Idate2=find(idx==1,1,'first');

% ================== SWE ==================
figure,whitebg(([245/255,245/255,245/255]))
set(gcf,'position',[200,200,890,700])
axes('Position',[0.1,0.68,0.88,0.28])
ax=gca;
ax.YAxis(1).Color = 'k';
hold on
% plot melt seasons
yy1=[0,2000,2000,0];
xx1=[NM(peakday1),NM(peakday1),NM(meltoutday1),NM(meltoutday1)];
xx1=[NM(peakday1),NM(peakday1),NM(meltoutday1),NM(meltoutday1)]; % WY2021
p(7)=fill(xx1, yy1,color1,'EdgeColor','none','FaceAlpha',0.3);
xx2=[NM(peakday2),NM(peakday2),NM(meltoutday2),NM(meltoutday2)]; % WY2017
p(8)=fill(xx2, yy1,color2,'EdgeColor','none','FaceAlpha',0.3);

% plot SWE IQR
q75 = prctile(FDC_SWE,75,2);
q25 = prctile(FDC_SWE,25,2);
x2 = [NM, fliplr(NM)];
inBetween = [q25', fliplr(q75')];
p(3)=fill(x2, inBetween ,[211 211 211]/255,'EdgeColor','none','FaceAlpha',0.5);

% Median of SWE
p(4)=plot(NM,nanmedian(FDC_SWE,2),'-k','linewidth',3);
% WY 2021 SWE
p(5)=plot(NM,FDC_SWE(:,end),'-','color',color1,'linewidth',4);
% WY 2017 SWE
p(6)=plot(NM,FDC_SWE(:,iyear),'-','color',color2,'linewidth',4);
yl=ylim;
ylim(yl);

% Plot snow start days
plot([NM(Idate1) NM(Idate1)], yl,'--','color',color1,'linewidth',2)
plot([NM(Idate2) NM(Idate2)], yl,'--','color',color2,'linewidth',2)

% subplot settings
title('Forestdale and downstream site')

lg=legend([p(4) p(3) p(5:8)],'Median','Interquartile range','WY 2021',...
    ['WY ' num2str(WYs(iyear))],'WY 2021 melt season',...
    ['WY ' num2str(WYs(iyear))  ' melt season']);
lg.FontSize=16;
lg.Location='northeast';
datetick('x','mmm')
ylbl=ylabel('SWE (mm)');
pos_ylb=ylbl.Position(1);
box
grid off
xticklabels('')
set(gca,'fontsize',20)
set(gca,'linewidth',2,'Xminortick','off','Yminortick','off')

% ================== Soil moisture (%) depth averaged ==================
axes('Position',[0.1,0.36,0.88,0.28])
ax=gca;
ax.YAxis(1).Color = 'k';
hold on
% plot melt seasons
yy1=[0,max(FDC_ave(:)),max(FDC_ave(:)),0];
xx1=[NM(peakday1),NM(peakday1),NM(meltoutday1),NM(meltoutday1)];
p(7)=fill(xx1, yy1,color1,'EdgeColor','none','FaceAlpha',0.3);
xx2=[NM(peakday2),NM(peakday2),NM(meltoutday2),NM(meltoutday2)];
p(8)=fill(xx2, yy1,color2,'EdgeColor','none','FaceAlpha',0.3);

% plot VWC IQR
q75 = prctile(FDC_ave,75,2);
q25 = prctile(FDC_ave,25,2);
x2 = [NM, fliplr(NM)];
inBetween = [q25', fliplr(q75')];
p(3)=fill(x2, inBetween ,[211 211 211]/255,'EdgeColor','none');

% Median of VWC
p(4)=plot(NM,nanmedian(FDC_ave,2),'-k','linewidth',3);
% WY 2021 VWC
p(5)=plot(NM,FDC_ave(:,end),'-','color',color1,'linewidth',4);
% WY 2017 VWC
p(6)=plot(NM,FDC_ave(:,iyear),'-','color',color2,'linewidth',4);

% Plot snow start days
plot([NM(Idate1) NM(Idate1)], ylim,'--','color',color1,'linewidth',2)
plot([NM(Idate2) NM(Idate2)], ylim,'--','color',color2,'linewidth',2)
% Plot Antecedent soil moisture
plot(NM(Idate1),FDC_ave(Idate1,end),'x','color',color1,'Markersize',20,'linewidth',4)
plot(NM(Idate2),FDC_ave(Idate2,iyear),'x','color',color2,'Markersize',20,'linewidth',4)

% subplot settings
ylim([0 max(FDC_ave(:))]);
datetick('x','mmm')
yl=ylabel('VWC (%)');
yl.Position(1)=pos_ylb;
box on
grid off
xticklabels('')
set(gca,'fontsize',20)
set(gca,'linewidth',2,'Xminortick','off','Yminortick','off')

% ================== Streamflow ==================
axes('Position',[0.1,0.04,0.88,0.28])
ax=gca;
ax.YAxis(1).Color = 'k';
hold on

% plot melt seasons
yy1=[0,max(FDC_R(:)),max(FDC_R(:)),0];
xx1=[NM(peakday1),NM(peakday1),NM(meltoutday1),NM(meltoutday1)];
p(7)=fill(xx1, yy1,color1,'EdgeColor','none','FaceAlpha',0.3);
xx2=[NM(peakday2),NM(peakday2),NM(meltoutday2),NM(meltoutday2)];
p(8)=fill(xx2, yy1,color2,'EdgeColor','none','FaceAlpha',0.3);

% plot streamflow IQR
q75 = prctile(FDC_R,75,2);
q25 = prctile(FDC_R,25,2);
x2 = [NM, fliplr(NM)];
inBetween = [q25', fliplr(q75')];
p(3)=fill(x2, inBetween ,[211 211 211]/255,'EdgeColor','none');

% Median of streamflow
p(4)=plot(NM,nanmedian(FDC_R,2),'-k','linewidth',3);
% WY 2021 streamflow
p(5)=plot(NM,FDC_R(:,end),'-','color',color1,'linewidth',4);
% WY 2017 streamflow
p(6)=plot(NM,FDC_R(:,iyear),'-','color',color2,'linewidth',4);

% subplot settings
ylim([0 max(FDC_R(:))]);
box
grid off
datetick('x','mmm')
xlabel('')
xticklabels(Month_tick)
yl=ylabel('Streamflow (m^3/s)');
yl.Position(1)=pos_ylb;
set(gca,'fontsize',20)
set(gca,'linewidth',2,'Xminortick','off','Yminortick','off')
