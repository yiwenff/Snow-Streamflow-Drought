%% Figure 3c and 3d
% Written by Yiwen Fang, 2022

%% all sites averaged across sites
clear;clc;

DATA_PATH='/Users/yiwenff/Desktop/2_SnowDrought/pushlish_GitHub/data/';
% Plot domain maps
load([DATA_PATH '/2_Soil_Moisture/SMS_CA_WY2003_2021'])
load([DATA_PATH '/2_Soil_Moisture/SMS_CO_WY2003_2021'])

% load DEM
DATA=ncread([DATA_PATH '/3_mask_shapefile/SRTM_elevation_large_matrix.nc'],'DATA');
DATA(DATA<0)=nan;
lon_map_array_480=ncread([DATA_PATH '/3_mask_shapefile/SRTM_elevation_large_matrix.nc'],'lon_map_array_480');
lat_map_array_480=ncread([DATA_PATH '/3_mask_shapefile/SRTM_elevation_large_matrix.nc'],'lat_map_array_480');
[LON,LAT] = meshgrid(double(lon_map_array_480),double(lat_map_array_480));

% Boundaries
load([DATA_PATH '/3_mask_shapefile/shape_sub_WUS'])
load([DATA_PATH '/3_mask_shapefile/WUS_HUC2_boundaries'])

% Define colors
RdYBu = getPyPlot_cMap('RdYlBu',12);
spec = getPyPlot_cMap('Spectral',12);
RdBu = [RdYBu(1:3,:);spec([5:6,8:9],:);RdYBu(10:12,:)];
bdr=[0.9290, 0.6940, 0.1250];

% load processed pre-snow PPT in situ
SN=load([DATA_PATH '/2_Soil_Moisture/Processed_insitu_presnow_soil_PPT_CA']);
UCRB=load([DATA_PATH '/2_Soil_Moisture/Processed_insitu_presnow_soil_PPT_CO']);

%% HUC2 lat/lon
ival_site=SN.ival_site;
% Compute percentile of soil moisture from 26 sites
dummy_soil=SN.VWC_per.ave(:,ival_site);
% =============== c) SN =============== 
figure,set(gcf,'position',[29,81,388,650])
ax1 = axes('Position',[-0.005,0.53,0.9,0.45]);
usamap([38.4,39.2],[-120.3, -119.3])
scaleruler on
s = handlem('scaleruler1');
setm(handlem('scaleruler1'), "MajorTick",[0,10,20,30], "FontSize",16,"RulerStyle",...
    "patches",'linewidth',0.5,'XLoc',-4e4,'YLoc',4.602e6,...
    'MinorTick',0,'FontWeight','bold','MajorTickLength',2.2)
hold on
% Plot DEM
pcolorm(LAT,LON,DATA)
hold on
set(gca,'ydir','normal')
colormap(flipud(gray));
caxis([1200,3800])
% American boundary
plotm(HUC_boundary.american.Y,HUC_boundary.american.X,'color',bdr,'Linewidth',1.5)
% Carson boundary
plotm(HUC_boundary.carson.Y,HUC_boundary.carson.X,'color',bdr,'Linewidth',1.5) 

% Plot soil site
select_site=find(SMS_CA.station_id==1049);
plotm(SMS_CA.lat(select_site),SMS_CA.lon(select_site),'s','color',[194 10 10]/255,'Markersize',25,'linewidth',3);
% plot streamflow gague
plotm(38.77,-119.83,'p','color',[21 67 96]/255,'markersize',30,'linewidth',3);
mlabel off;plabel off;gridm off

p(1)=plotm(nan,nan,'s','color',[194 10 10]/255,'Markersize',10,'linewidth',3);
p(2)=plotm(nan,nan,'p','color',[21 67 96]/255,'markersize',15,'linewidth',2);
lg=legend(p,'Forestdale','Streamflow gage');
lg.FontSize=18;
set(gca,'Layer','top','linewidth',2)
box on

%==== SN =====
whitebg(([245/255,245/255,245/255]))
ax2 = axes('Position',[0.05,0.05,0.9,0.45]);
axis equal
hold on

% plot HUC2
% Truckee boundary
plot(HUC_boundary.truckee.X,HUC_boundary.truckee.Y,'color','k','Linewidth',1.5) 
% Walker boundary
plot(HUC_boundary.walker.X,HUC_boundary.walker.Y,'color','k','Linewidth',1.5) 
% American boundary
plot(HUC_boundary.american.X,HUC_boundary.american.Y,'color',bdr,'Linewidth',1.5)
% Carson boundary
plot(HUC_boundary.carson.X,HUC_boundary.carson.Y,'color',bdr,'Linewidth',1.5) 

for isite=1:length(ival_site)
scatter(SMS_CA.lon(ival_site(isite)),SMS_CA.lat(ival_site(isite)),500,dummy_soil(end,isite)*100,...
    'filled','s','MarkerEdgeColor','k','linewidth',1)
end
isite=find(SMS_CA.station_id==1049);
scatter(SMS_CA.lon(isite),SMS_CA.lat(isite),500,dummy_soil(end,isite)*100,'s','filled')
scatter(SMS_CA.lon(isite),SMS_CA.lat(isite),600,'ks','linewidth',4)

ylabel('')
xlabel('')
xticklabels('')
yticklabels('')

set(gca,'FontSize',22,'xtick',[],'ytick',[])
ylim([38,39.7])
xlim([-120.73,-119.1])
colormap(ax2,RdBu);
caxis([0,100])
title('')
c=colorbar;
box 
set(gca,'linewidth',2)
grid off

%% ===== CO ====
I=find(~isnan(UCRB.VWC_per.ave(end,UCRB.ival_site)));
ival_site=UCRB.ival_site(I);
dummy_soil=UCRB.VWC_per.ave(:,ival_site);

figure,set(gcf,'position',[29,81,388,650])
ax1 = axes('Position',[0.05,0.53,0.9,0.45]);
whitebg(([245/255,245/255,245/255]))
axis equal
hold on

for j=[4]
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color','k','Linewidth',2)
end
% Headwaters boundary
plot(HUC_boundary.headwaters.X,HUC_boundary.headwaters.Y,'color',bdr,'Linewidth',1.5)
% San Juan
plot(HUC_boundary.sanjuan.X,HUC_boundary.sanjuan.Y,'color','k','Linewidth',1.5)

for isite=1:length(ival_site)
scatter(SMS_CO.lon(ival_site(isite)),SMS_CO.lat(ival_site(isite)),500,...
    dummy_soil(end,isite)*100,'filled','d','MarkerEdgeColor','k','linewidth',1)
end

% Plot soil moisture site position
isite=find(SMS_CO.station_id==335);
scatter(SMS_CO.lon(isite),SMS_CO.lat(isite),500,dummy_soil(end,isite)*100,'d','filled')
% Plot streamflow gague position
scatter(SMS_CO.lon(isite),SMS_CO.lat(isite),600,'kd','linewidth',4)
ylabel('')
xlabel('')
xticklabels('')
yticklabels('')
set(gca,'FontSize',25)
ylim([37.1,41.1])
xlim([-109.1,-105.3353])
colormap(ax1,RdBu);
caxis([0,100])
title('')
c=colorbar;
%c.Position(1)=0.12;
box 
set(gca,'linewidth',2)
grid off

ax2 = axes('Position',[-0.005,0.05,0.9,0.45]);
usamap([39.7,40],[-105.925, -105.55])
scaleruler on
s = handlem('scaleruler1');
getm(s)
setm(handlem('scaleruler1'), "MajorTick",0:5:15, "FontSize",16,"RulerStyle",...
    "patches",'linewidth',0.5,'XLoc',-0.3e4,'YLoc',4.771e6,...
    'MinorTick',0,'FontWeight','bold','MajorTickLength',0.8)
hold on

pcolorm(LAT,LON,DATA)
set(gca,'ydir','normal')
colormap(ax2,flipud(gray));
caxis([2500,max(DATA(:))])

% Headwaters boundary
plotm(HUC_boundary.headwaters.Y,HUC_boundary.headwaters.X,'color',bdr,'Linewidth',1.5)

% soil moisture site
select_site=find(SMS_CO.station_id==335);
plotm(SMS_CO.lat(select_site),SMS_CO.lon(select_site),'d','color',[194 10 10]/255,'Markersize',25,'linewidth',3);
% streamflow gage site
plotm(39.84582,-105.75195,'p','color',	[21 67 96]/255,'markersize',30,'linewidth',3);
p2(1)=plotm(nan,nan,'d','color',[194 10 10]/255,'Markersize',10,'linewidth',3);
p2(2)=plotm(nan,nan,'p','color',	[21 67 96]/255,'markersize',15,'linewidth',2);
lg=legend(p2,'Berthoud Summit','Streamflow gage');
lg.FontSize=18;
set(gca,'Layer','top','linewidth',2)
mlabel off;plabel off;gridm off

%% WUS
figure,set(gcf,'position',[29,81,388,201])
hold on
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[169 169 169]/255,'Linewidth',1.5)
end
for j=[1,4]
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color','k','Linewidth',1.5)
end
axis equal
box on
xticks('')
yticks('')
grid off
shp=shaperead('usastatehi.shp');
idx=[3 5 6 12 26 28 37 44 47 50];
for j=1:length(idx)
    plot(shp(idx(j)).X,shp(idx(j)).Y,'-','color',[128 128 128]/255,'linewidth',1)
end

% draw HUC8 CA boundaries
% American boundary
plot(HUC_boundary.american.X,HUC_boundary.american.Y,'color',bdr,'Linewidth',1.5)
% Carson boundary
plot(HUC_boundary.carson.X,HUC_boundary.carson.Y,'color',bdr,'Linewidth',1.5) 

select_site=find(SMS_CA.station_id==1049);
plot(SMS_CA.lon(select_site),SMS_CA.lat(select_site),'s','color',[194 10 10]/255,'Markersize',10,'linewidth',3)

% CO
% plot Headwaters boundary
plot(HUC_boundary.headwaters.X,HUC_boundary.headwaters.Y,'color',bdr,'Linewidth',1.5)
select_site=find(SMS_CO.station_id==335);

plot(SMS_CO.lon(select_site),SMS_CO.lat(select_site),'d','color',[194 10 10]/255,'Markersize',10,'linewidth',3)
xlim([-125,-103.5])
ylim([31,46])
set(gca,'Visible','off')