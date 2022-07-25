%% Figure 3a Berthoud Summit analysis
% Written by Yiwen Fang, 2022

% Month and WYs 
WYs=2003:2021;
Month_tick={'','1 NOV','','1 JAN','', '1 MAR','','1 MAY','','1 JUL','','1 SEP'};
DATA_PATH='/Users/yiwenff/Desktop/2_SnowDrought/pushlish_GitHub/data/2_Soil_Moisture/';

% load soil moisture data at Berthoud Summit
load([DATA_PATH 'SMS_CO_WY2003_2021'])

% Read BS SWE, streamflow
load([DATA_PATH 'BS_data'])

% Extract soil moisture at Berthoud summit (335)
isite=find(SMS_CO.station_id==335);
BS_d2=SMS_CO.SMS_d2(:,:,isite); % 2 inches
BS_d8=SMS_CO.SMS_d8(:,:,isite); % 8 inches
BS_d20=SMS_CO.SMS_d20(:,:,isite); % 20 inches

% Compute averaged soil moisture
% depth of 3 layers 10 cm (0-10 cm), 20 cm (10-30 cm), 40 cm(30 - 70 cm)
d2=10;d8=20;d20=40;
BS_ave=(d2*BS_d2+d8*BS_d8+d20*BS_d20)/(d2+d8+d20);


% Define colors for two years
color1=[21 67 96]/255;
color2=[194 10 10]/255;

%% Plot time series of SWE, VWC and streamflow at Berthoud Summit
% Define datetime
NM=datenum(2019,10,1):datenum(2020,9,30);

% Extract peak SWE, peak SWE days and melt out day
year_se=2011;
iyear=find(year_se==WYs);
[~,peakday1]=max(BS_SWE(:,end)); % WY 2021
[~,peakday2]=max(BS_SWE(:,iyear));  % WY 2011
meltoutday1=find(BS_SWE(peakday1:end,end)==0,1,'first')+peakday1;
meltoutday2=find(BS_SWE(peakday2:end,iyear)==0,1,'first')+peakday2;

% Find snow onset date (first day when SWE is greater than 1 cm for at least 5 continuous days)
thre=0.01;
dummy=BS_SWE(:,end);
idx = dummy>thre & [dummy(2:end)>thre;false] &  [dummy(3:end)>thre;false;false] &...
    [dummy(4:end)>thre;false;false; false] & [dummy(5:end)>thre;false;false;false;false];
Idate1=find(idx==1,1,'first');

dummy=BS_SWE(:,iyear);
idx = dummy>thre & [dummy(2:end)>thre;false] &  [dummy(3:end)>thre;false;false] &...
    [dummy(4:end)>thre;false;false; false] & [dummy(5:end)>thre;false;false;false;false];
Idate2=find(idx==1,1,'first');

% ================== SWE ==================
figure,
set(gcf,'position',[200,200,890,700])
axes('Position',[0.1,0.68,0.88,0.28])
ax=gca;
ax.YAxis(1).Color = 'k';
hold on
% plot melt seasons
yy1=[0,1000,1000,0];
xx1=[NM(peakday1),NM(peakday1),NM(meltoutday1),NM(meltoutday1)];
p(7)=fill(xx1, yy1,color1,'EdgeColor','none','FaceAlpha',0.3);
xx2=[NM(peakday2),NM(peakday2),NM(meltoutday2),NM(meltoutday2)];
p(8)=fill(xx2, yy1,color2,'EdgeColor','none','FaceAlpha',0.3);

% plot SWE IQR
q75 = prctile(BS_SWE,75,2);
q25 = prctile(BS_SWE,25,2);
x2 = [NM, fliplr(NM)];
inBetween = [q25', fliplr(q75')];
p(3)=fill(x2, inBetween ,[211 211 211]/255,'EdgeColor','none','FaceAlpha',0.5);

% Median of SWE
p(4)=plot(NM,nanmedian(BS_SWE,2),'-k','linewidth',2);
% WY 2021 SWE
p(5)=plot(NM,BS_SWE(:,end),'-','color',color1,'linewidth',3);
% WY 2011 SWE
p(6)=plot(NM,BS_SWE(:,iyear),'-','color',color2,'linewidth',3);

% Plot snow start days
plot([NM(Idate1) NM(Idate1)], ylim,'--','color',color1,'linewidth',2)
plot([NM(Idate2) NM(Idate2)], ylim,'--','color',color2,'linewidth',2)

yl=ylim;
ylim(yl);
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
title('Berthoud Summit and downstream site')

%  ================== Soil moisture (%) depth averaged  ================== 
axes('Position',[0.1,0.36,0.88,0.28])
ax=gca;
ax.YAxis(1).Color = 'k';
hold on

% plot melt seasons
yy1=[0,max(BS_ave(:)),max(BS_ave(:)),0];
xx1=[NM(peakday1),NM(peakday1),NM(meltoutday1),NM(meltoutday1)];
p(7)=fill(xx1, yy1,color1,'EdgeColor','none','FaceAlpha',0.3);
xx2=[NM(peakday2),NM(peakday2),NM(meltoutday2),NM(meltoutday2)];
p(8)=fill(xx2, yy1,color2,'EdgeColor','none','FaceAlpha',0.3);

% plot VWC IQR
q75 = prctile(BS_ave,75,2);
q25 = prctile(BS_ave,25,2);
x2 = [NM, fliplr(NM)];
inBetween = [q25', fliplr(q75')];
p(3)=fill(x2, inBetween ,[211 211 211]/255,'EdgeColor','none');

% Median of VWC
p(4)=plot(NM,nanmedian(BS_ave,2),'-k','linewidth',2);
% WY 2021 VWC
p(5)=plot(NM,BS_ave(:,end),'-','color',color1,'linewidth',3);
% WY 2011 VWC
p(6)=plot(NM,BS_ave(:,iyear),'-','color',color2,'linewidth',3);

% Plot snow start days
plot([NM(Idate1) NM(Idate1)], ylim,'--','color',color1,'linewidth',2)
plot([NM(Idate2) NM(Idate2)], ylim,'--','color',color2,'linewidth',2)
% Plot Antecedent soil moisture
plot(NM(Idate1),BS_ave(Idate1,end),'x','color',color1,'Markersize',20,'linewidth',3)
plot(NM(Idate2),BS_ave(Idate2,iyear),'x','color',color2,'Markersize',20,'linewidth',3)

% subplot settings
ylim([0 max(BS_ave(:))]);
datetick('x','mmm')
ylabel('VWC (%)')
box
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
yy1=[0,max(BS_R(:)),max(BS_R(:)),0];
xx1=[NM(peakday1),NM(peakday1),NM(meltoutday1),NM(meltoutday1)];
p(7)=fill(xx1, yy1,color1,'EdgeColor','none','FaceAlpha',0.3);
xx2=[NM(peakday2),NM(peakday2),NM(meltoutday2),NM(meltoutday2)];
p(8)=fill(xx2, yy1,color2,'EdgeColor','none','FaceAlpha',0.3);

% plot streamflow IQR
q75 = prctile(BS_R,75,2);
q25 = prctile(BS_R,25,2);
x2 = [NM, fliplr(NM)];
inBetween = [q25', fliplr(q75')];
p(3)=fill(x2, inBetween ,[211 211 211]/255,'EdgeColor','none');

% Median of streamflow
p(4)=plot(NM,nanmedian(BS_R,2),'-k','linewidth',2);
% WY 2021 streamflow
p(5)=plot(NM,BS_R(:,end),'-','color',color1,'linewidth',3);
% WY 2011 streamflow
p(6)=plot(NM,BS_R(:,iyear),'-','color',color2,'linewidth',3);

% subplot settings
ylim([0 5]);
box
grid off
datetick('x','mmm')
xticklabels(Month_tick)
ylabel('Streamflow (m^3/s)')
set(gca,'fontsize',20)
set(gca,'linewidth',2,'Xminortick','off','Yminortick','off')