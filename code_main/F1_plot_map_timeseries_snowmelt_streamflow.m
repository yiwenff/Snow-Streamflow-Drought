% Scripts of Figure 1. snowmelt streamflow percentile
% Written by Yiwen Fang, 2022

% Generate peak SWE over average map and time series of WUS total snow
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',6,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',16,...
    'DefaultAxesFontWeight','bold',...
    'DefaultAxesLineWidth',2,...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',16)

% Set colorbar
RdYBu = getPyPlot_cMap('RdYlBu',12);
spec = getPyPlot_cMap('Spectral',12);
RdBu = [RdYBu(1:3,:);spec([5:6,8:9],:);RdYBu(10:12,:)];

%% Load dataset
DATA_PATH=['/Users/yiwenff/Desktop/2_SnowDrought/pushlish_GitHub/data/' ];

% 1) SWE and flow time series percentile
load([DATA_PATH '/0_naturalized_flow/Basin_SWE_flow_percentile']);

% 2) negative SWE time series percentile
load([DATA_PATH '/1_SWE/snowmelt_basinwide_percentile_OCT_JUL_WY1988_2021'])

% 3) negative SWE map
load([DATA_PATH '/1_SWE/snowmelt_pixelwise_percentile_OCT_JUL_WY1988_2021'])

% 4) Reanalysis SWE mask
load([DATA_PATH '/3_mask_shapefile/Reanalysis_SN_480m_mask.mat'])

% 5) HUC2 lat/lon
HUC2_PATH='//Users/yiwenff/Desktop/1_WUS_SR_descriptor/publish_github/data/';
load([HUC2_PATH 'WUS_HUC2_boundaries'],'HUC2_string','HUC2')

% 6) Median SWE path
load([DATA_PATH '/1_SWE/mean_peak_SWE'],'median_peak_SWE','description')

lon_map_array = [-125:-102]; lat_map_array = [49:-1:31]; % updated 01/30/2020
lon_map_array_480 = lon_map_array(1)+1/225/2:1/225:lon_map_array(end)+1-1/225/2;
lat_map_array_480 = lat_map_array(1)+1-1/225/2:-1/225:lat_map_array(end)+1/225/2;
[LON,LAT]=meshgrid(lon_map_array_480,lat_map_array_480);

% Define SN and UCRB basin Name
basinname={'uppersac','feather','yuba','american','stanislaus','tuolumne',...
    'merced','sanjoaquin','kings','kaweah','kern','tule','mokelumne','headwaters','gunnison'};
load([DATA_PATH '/3_mask_shapefile/shape_sub_WUS'])

%% Define study period
WYs=1985:2021;
WYs_sub=1988:2021;
nyears=length(WYs_sub);
ist_year=find(WYs_sub(1)==WYs);

%% plot Time series
% =================== subplot d) WUS time-series ==================
figure
whitebg(([245/255,245/255,245/255]))
set(gcf,'position',[18 270 1150 550])
ax1=axes('position',[0.0200    0.03    0.36    0.295]);
set(ax1,'position',[0.0200    0.03    0.36    0.295])
% a) plot gray-white background
idxyr=1:2:34;
hold on
for j=1:length(idxyr)
    pos=[WYs_sub(idxyr(j))-0.5,0,1,100];
    rectangle('Position',pos,'facecolor',[169 169 169 100]/255,'edgecolor','none')
end
rectangle('Position',[WYs(1)-0.5,0,37,30],'facecolor',[RdBu(4,:) 0.5],'edgecolor','none')
plot([WYs_sub(1)-1 WYs_sub(end)+1],[30 30],'--k')

% b) Plot SWE percentiles over WUS
p1(1)=plot(nan,nan,'s','color','k','linewidth',2);
p1(2)=plot(WYs_sub,SWE_WUS_percentile*100,'d','color',RdBu(1,:),'linewidth',2);

% c) Figure settings
xlim([WYs_sub(1)-0.5,WYs_sub(end)+0.5])
set(gca,'YAxisLocation','left','Layer','top')
yyaxis right
yticklabels('')
set(gca,'YColor',[0 0 0]);
ylabel('')
set(gca,'FontSize',12)
xticks([1990 2000 2010 2020])
box on
grid off
lg=legend(p1,'streamflow','snowmelt','location','northwest');
lg.Color='none';
lg.Box='on';

% =================== subplot e) Sierra Nevada =========================
ax2=axes('position',[0.405    0.03    0.26    0.295]);
yticks([30,50,70])
% 1) plot gray-white background
idxyr=1:2:34;
for j=1:length(idxyr)
    pos=[WYs_sub(idxyr(j))-0.5,0,1,100];
    rectangle('Position',pos,'facecolor',[169 169 169 100]/255,'edgecolor','none')
end
rectangle('Position',[WYs(1)-0.5,0,37,30],'facecolor',[RdBu(4,:) 0.5],'edgecolor','none')

% 2) Plot SWE and flow percentile
id=[3,34]; % year 1990, 2021
hold on
plot([WYs_sub(1)-1 WYs_sub(end)+1],[30 30],'--k')
plot(WYs_sub,Flow_sn_percentile*100,'ks','linewidth',2);
p1=scatter(WYs_sub(id),Flow_sn_percentile(id)*100,'ks','linewidth',2,'MarkerFaceColor',[0 0 0],'MarkerFaceAlpha',0.8);
plot(WYs_sub,SWE_sn_percentile*100,'d','color',RdBu(1,:),'linewidth',2);
scatter(WYs_sub(id),SWE_sn_percentile(id)*100,'d','Markeredgecolor',RdBu(1,:),...
    'linewidth',2,'MarkerFaceColor',RdBu(1,:),'MarkerFaceAlpha',0.8);

% 3) Figure settings
yticklabels('')
set(gca,'YAxisLocation','left','Layer','top')
yyaxis right
yticks([30,50,70])
ylim([0,100])
yticklabels('')
set(gca,'YColor',[0 0 0]);
grid off
box on
set(gca,'FontSize',12)
xlim([WYs_sub(1)-0.5,WYs_sub(end)+0.5])
xticks([1990 2000 2010 2020])

% =================== subplot f) UCRB ========================
ax3=axes('position',[0.675    0.03    0.26    0.295]);
yticks([30,50,70,100])

% 1) plot gray-white background
idxyr=1:2:34;
for j=1:length(idxyr)
    pos=[WYs_sub(idxyr(j))-0.5,0,1,100];
    rectangle('Position',pos,'facecolor',[169 169 169 100]/255,'edgecolor','none')
end
rectangle('Position',[WYs(1)-0.5,0,37,30],'facecolor',[RdBu(4,:) 0.5],'edgecolor','none')
id=[3,34]; % year 1990, 2021
hold on
% plot 30th percentile threshold
plot([WYs_sub(1) WYs_sub(end)],[30 30],'--k')

% 2) plot SWE, flow percentile
p1(1)=plot(WYs_sub,Flow_ucrb_percentile*100,'s','color','k','linewidth',2);
p1(2)=plot(WYs_sub,SWE_ucrb_percentile*100,'d','color',RdBu(1,:),...
    'linewidth',2);
scatter(WYs_sub(id),Flow_ucrb_percentile(id)*100,'s','Markeredgecolor','k','linewidth',2,...
    'MarkerFaceAlpha',0.8,'MarkerFaceColor','k');
scatter(WYs_sub(id),SWE_ucrb_percentile(id)*100,'d','Markeredgecolor',RdBu(1,:),...
    'linewidth',2,'MarkerFaceColor',RdBu(1,:),'MarkerFaceAlpha',0.8);

% 3) figure settings
xlim([WYs_sub(1)-0.5,WYs_sub(end)+0.5])
set(gca,'YAxisLocation','left','Layer','top')
grid off
box on
yticklabels('')
yyaxis right
yticks([30,50,70])
ylim([0,100])
set(gca,'YColor',[0 0 0]);
xlim([WYs_sub(1)-0.5,WYs_sub(end)+0.5])
xticks([1990 2000 2010 2020])
yl=ylabel('(percentile)');
yl.Position(1)=2025;
set(gca,'FontSize',12)

nanmedian(Flow_sn_percentile*100-SWE_sn_percentile*100)
nanmedian(Flow_ucrb_percentile*100-SWE_ucrb_percentile*100)

Flow_sn_percentile(end)*100-SWE_sn_percentile(end)*100
Flow_ucrb_percentile(end)*100-SWE_ucrb_percentile(end)*100
%% WUS subplot a)
ax4=axes('position',[0.0200    0.32    0.36    0.65]);
hold on
imAlpha=ones(size(SWE_percentile,1),size(SWE_percentile,2));
imAlpha(isnan(median_peak_SWE)| median_peak_SWE<0.05)=0;

% 1) plot SWE percentile
imagesc(lon_map_array_480,lat_map_array_480,squeeze(SWE_percentile(:,:,end))*100,'AlphaData',imAlpha)
axis equal

% 2) add HUC2 basin boundary
for j=1: length(HUC2_string)
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[72 72 72]/255,'Linewidth',1.5)
end
for j=[1,4]
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color','k','Linewidth',2)
end
 colormap(RdBu)

% 3) plot states
shp=shaperead('usastatehi.shp');
idx=[3 5 6 12 26 28 37 44 47 50];
for j=1:length(idx)
    plot(shp(idx(j)).X,shp(idx(j)).Y,'-','color',[128 128 128]/255,'linewidth',1)
end

% 4) figure settings
axis equal
set(gca,'YDir','normal')
xlim([-125,-102])
ylim([31,49])
caxis([0,100])
grid off
ax=gca;
ax.Layer='top';
box on
set(ax4,'position',[0.0200    0.35    0.36    0.60])
set(gca,'xAxisLocation','top')
set(gca,'FontSize',12)
yticks([35,40,45])
xticks([-122 -117 -111 -106])

%% Sierra Nevada only subplot b)
ax5=axes('position',[0.405    0.35    0.26    0.58]);
hold on
imAlpha=ones(size(SWE_percentile,1),size(SWE_percentile,2));
imAlpha(isnan(median_peak_SWE)| median_peak_SWE<0.05|isnan(SN_SR480.domain_mask))=0;

% 1) plot SWE percentile
imagesc(lon_map_array_480,lat_map_array_480,SWE_percentile(:,:,end).*SN_SR480.domain_mask*100,'AlphaData',imAlpha)
hold on

% 2) plot HUC2 boundary
for j=[1]
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[96 96 96]/255,'Linewidth',1)
end

% 3) plot subbains
HUC8_id=[2,4,11];
for j=1:length(HUC8_id)
    plot(HUC_boundary.(char(basinname(HUC8_id(j)))).X,HUC_boundary.(char(basinname(HUC8_id(j)))).Y,'color','k','Linewidth',2.5)
end

% 4) plot flow station
for isite=1:length(site_CA.lon)
    plot(site_CA.lon(isite),site_CA.lat(isite),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',3,'linewidth',3)
end

% 5) figure settings
colormap(RdBu)
axis equal
caxis([0,100])
ylim([35.2,42])
xlim([-123.5,-117.2])
box on
yticks([35,37,39,41])
xticks([-122 -120 -118])
grid off
hold on 
set(ax5,'position',[0.405    0.35    0.26    0.60])
set(gca,'YDir','normal','xAxisLocation','top','yAxisLocation','left',...
    'FontSize',12,'Layer','top')

%% UCRB only subplot c)
% UCRB mask
in = inpoly2([LON(:),LAT(:)],[HUC2.s14.X;HUC2.s14.Y]');
mask_UCRB=nan(size(LON));
mask_UCRB(in==1 )=1;
ax6=axes('position',[0.675    0.32    0.32    0.65]);
hold on
imAlpha=ones(size(SWE_percentile,1),size(SWE_percentile,2));
imAlpha(isnan(median_peak_SWE)| median_peak_SWE<0.05|isnan(mask_UCRB))=0;

% 1) plot SWE percentile
imagesc(lon_map_array_480,lat_map_array_480,SWE_percentile(:,:,end).*mask_UCRB*100,'AlphaData',imAlpha)

% 2) plot basin boundaries
for j=[4]
    plot(HUC2.(['s' HUC2_string(j,:)]).X,HUC2.(['s' HUC2_string(j,:)]).Y,'color',[96 96 96]/255,'Linewidth',1)
end

HUC6_id=[14,15];
for j=1:length(HUC6_id)
    plot(HUC_boundary.(char(basinname(HUC6_id(j)))).X,HUC_boundary.(char(basinname(HUC6_id(j)))).Y,'color','k','Linewidth',2.5)
end

% 3) plot gage lat/lon
for site_id=[1,2]
    plot(site_CO.lon(site_id),site_CO.lat(site_id),'-o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',3,'linewidth',2.5)
end

% 4) figure settings
grid off
% axis image
axis equal
set(gca,'YDir','normal','xAxisLocation','top','yAxisLocation','right')
colormap(RdBu)
caxis([0,100])
c=colorbar;
ylabel(c,'(percentile)')
c.Label.Position(1)=2.7;
c.Position=[0.9562 0.3755 0.01 0.5807];
set(gca,'FontSize',12)
ax=gca;
ax.Layer='top';
xlim([-113,-105])
ylim([35.15,43.8])
box on
hold on
yticks([36,39,42])
xticks([-112 -110 -108 -106])
set(ax6,'position',[0.675    0.35    0.26    0.60])
