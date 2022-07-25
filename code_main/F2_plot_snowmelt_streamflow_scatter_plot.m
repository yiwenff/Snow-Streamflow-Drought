% Scripts of Figure 2. scatter plot of OCT-JUL snowmelt and streamflow
% Written by Yiwen Fang, 2022

%% Figure settings
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','off','DefaultAxesYminortick','off',...
    'DefaultAxesLineWidth',3,...
    'DefaultLineLineWidth',2,'DefaultLineMarkerSize',12,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',18,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',16)
PuOr=getPyPlot_cMap('PuOr',121);
%% Load data
% Data_path
DATA_PATH=['/Users/yiwenff/Desktop/2_SnowDrought/pushlish_GitHub/data/'];

% 1) load negative SWE
load([DATA_PATH '/1_SWE/snowmelt_basinwide_OCT_JUL_WY1988_2021'],'SWE_neg_basin','basinname')
SWE_basin=SWE_neg_basin;

% 2) load SWE and flow percentile
load([DATA_PATH '/0_naturalized_flow/Flow_perday_CA'])
load([DATA_PATH '/0_naturalized_flow/Flow_perday_CO'])

%% Define study period
WYs=1985:2021;
WYs_sub=1988:2021;
nyears=length(WYs_sub);
ist_year=find(WYs_sub(1)==WYs);
select_year=[2015,2021];
for j=1:length(select_year)
    iyear(j)=find(WYs_sub==select_year(j));
end
%% Scatter plot of each basin (CA)
SWE_percentile=nan(5,nyears);
flow_percentile=nan(5,nyears);

figure(12), whitebg([1 1 1])
set(gcf,'position',[30,180,1550,905])
ha1=tight_subplot(2,3,[0.08,0.05],[0.06,0.03],[0.05,0.05]);
delete(ha1(6))

ulim=100; % upper limit 

% ============== Feather basin ================
isite=find(strcmp(basinname,'feather')==1);
SWE_metric=nan(37,1);
SWE_metric(ist_year:end)=SWE_basin(isite,:);
isite=find(strcmp(FNF_CA.site,'ORO')==1);
flow=squeeze(nanmean(FNF_CA.Nflow_monthly(isite,1:10,:),2)*10); % km^3
inan=find(isnan(flow)==1);
SWE_metric(inan)=nan;

axes(ha1(1))
ax=gca;
ax.XAxis.TickValues=[0 30 50 70 100];
ax.YAxis.TickValues=[0 30 50 70 100];
hold on
% plot reference lines
patch([0 30 30 0],[0 0 30 30],[211 211 211]/255,'FaceAlpha',1,'Edgecolor','none')
plot([0 100],[30,30],'--','color',[32 32 32]/255)
plot([30 30],[0,100],'--','color',[32 32 32]/255)

% plot scatters
disp('Feather:')
[SWE_percentile(1,:),flow_percentile(1,:),residual(1,:)]=plot_scatter(SWE_metric(ist_year:end),...
    flow(ist_year:end),WYs_sub,iyear);

% Highlight drought years in section 3.4
scatter(SWE_percentile(1,iyear),flow_percentile(1,iyear),200,'k')   

ylabel('OCT-JUL streamflow (percentile)')
title('Feather')
caxis([0,ulim])
xlim([0, ulim])
ylim([0, ulim])
box off
set(gca,'Layer','top')

% ============== American ================
isite=find(strcmp(basinname,'american')==1);
SWE_metric=nan(37,1);
SWE_metric(ist_year:end)=SWE_basin(isite,:);
isite=find(strcmp(FNF_CA.site,'NAT')==1);
flow=squeeze(nanmean(FNF_CA.Nflow_monthly(isite,1:10,:),2)*10); % km^3
inan=find(isnan(flow)==1);
SWE_metric(inan)=nan;

axes(ha1(2))
ax=gca;
ax.XAxis.TickValues=[0 30 50 70 100];
ax.YAxis.TickValues=[0 30 50 70 100];
hold on

% plot reference lines
patch([0 30 30 0],[0 0 30 30],[211 211 211]/255,'FaceAlpha',1,'Edgecolor','none')
plot([0 100],[30,30],'--','color',[32 32 32]/255)
plot([30 30],[0,100],'--','color',[32 32 32]/255)

% plot scatters
disp('American:')
[SWE_percentile(2,:),flow_percentile(2,:),residual(2,:)]=plot_scatter(SWE_metric(ist_year:end),...
    flow(ist_year:end),WYs_sub,iyear);

% Highlight drought years in section 3.4
scatter(SWE_percentile(2,iyear),flow_percentile(2,iyear),200,'k')

title('American')
box off
set(gca,'Layer','top')
xlim([0, ulim])
ylim([0, ulim])
caxis([0,ulim])

% ============== Kern ==============
SWE_percentile=nan(4,nyears);
flow_percentile=nan(4,nyears);
isite=find(strcmp(basinname,'kern')==1);
SWE_metric=nan(37,1);
SWE_metric(ist_year:end)=SWE_basin(isite,:);
isite=find(strcmp(FNF_CA.site,'ISB')==1);
flow=squeeze(nanmean(FNF_CA.Nflow_monthly(isite,1:10,:),2)*10); % km^3
inan=find(isnan(flow)==1);
SWE_metric(inan)=nan;

axes(ha1(3))
ax=gca;
ax.XAxis.TickValues=[0 30 50 70 100];
ax.YAxis.TickValues=[0 30 50 70 100];

hold on
% plot reference lines
patch([0 30 30 0],[0 0 30 30],[211 211 211]/255,'FaceAlpha',1,'Edgecolor','none')
plot([0 100],[30,30],'--','color',[32 32 32]/255)
plot([30 30],[0,100],'--','color',[32 32 32]/255)

% plot scatters
disp('Kern:')
[SWE_percentile(2,:),flow_percentile(2,:),residual(2,:)]=plot_scatter(SWE_metric(ist_year:end),...
    flow(ist_year:end),WYs_sub,iyear);
% Highlight drought years in section 3.4
scatter(SWE_percentile(2,iyear),flow_percentile(2,iyear),200,'k')

set(gca,'Layer','top')
xlabel('OCT-JUL snowmelt (percentile)')
title('Kern')
box off
caxis([0,ulim])
xlim([0, ulim])
ylim([0, ulim])

%% Scatter plot of each basin (CO)
select_year2=[2002,2021];
for j=1:length(select_year2)
    iyear(j)=find(WYs_sub==select_year2(j));
end

% ============== Headwater ============== 
isite=find(strcmp(basinname,'headwaters')==1);
SWE_metric=nan(37,1);
SWE_metric(ist_year:end)=SWE_basin(isite,:);
flow=RAW_flow(1,:);
inan=find(isnan(flow)==1);
SWE_metric(inan)=nan;

axes(ha1(4))
ax=gca;
ax.XAxis.TickValues=[0 30 50 70 100];
ax.YAxis.TickValues=[0 30 50 70 100];

hold on
% plot reference lines
patch([0 30 30 0],[0 0 30 30],[211 211 211]/255,'FaceAlpha',1,'Edgecolor','none')
plot([0 100],[30,30],'--','color',[32 32 32]/255)
plot([30 30],[0,100],'--','color',[32 32 32]/255)

% plot scatters
disp('Headwaters:')
[SWE_percentile(3,:),flow_percentile(3,:)]=plot_scatter(SWE_metric(ist_year:end),...
flow(ist_year:end),WYs_sub,iyear);

% Highlight drought years in section 3.4
scatter(SWE_percentile(3,iyear),flow_percentile(3,iyear),200,'k')

xlabel('OCT-JUL snowmelt (percentile)')
title('Headwaters')
box off
caxis([0,ulim])
xlim([0, ulim])
ylim([0, ulim])
set(gca,'Layer','top')
ylabel('OCT-JUL streamflow (percentile)')

% ============== Gunnison ============== 
for j=1:length(select_year2)
    iyear(j)=find(WYs_sub==select_year2(j));
end
isite=find(strcmp(basinname,'gunnison')==1);
SWE_metric=nan(37,1);
SWE_metric(ist_year:end)=SWE_basin(isite,:);
flow=RAW_flow(2,:);
inan=find(isnan(flow)==1);
SWE_metric(inan)=nan;

axes(ha1(5))
ax=gca;
ax.XAxis.TickValues=[0 30 50 70 100];
ax.YAxis.TickValues=[0 30 50 70 100];

% plot reference lines
hold on
patch([0 30 30 0],[0 0 30 30],[211 211 211]/255,'FaceAlpha',1,'Edgecolor','none')
plot([0 100],[30,30],'--','color',[32 32 32]/255)
plot([30 30],[0,100],'--','color',[32 32 32]/255)

% plot scatters
disp('Gunnison:')

[SWE_percentile(4,:),flow_percentile(4,:)]=plot_scatter(SWE_metric(ist_year:end),...
    flow(ist_year:end),WYs_sub,iyear);

% Highlight drought years in section 3.4
scatter(SWE_percentile(4,iyear),flow_percentile(4,iyear),200,'k')

ax=gca;
ax.XAxis.TickValues=[0 30 50 70 100];
ax.YAxis.TickValues=[0 30 50 70 100];
xlabel('OCT-JUL snowmelt (percentile)')
title('Gunnison')
set(gca,'Layer','top')
box off
ylabel('')
caxis([0,ulim])
xlim([0, ulim])
ylim([0, ulim])
colormap(PuOr)
c=colorbar;
set(c,'location', 'southoutside','position',[0.69    0.38   0.25    0.02])
c.Label.String='(streamflow/snowmelt) percentile';
c.AxisLocation='out';

%% Function
function [x_percentile,y_percentile,residual]=plot_scatter(x,y,WYs,iyear)
norm_idx=1:length(WYs);
norm_idx(iyear)=[];

x_annual=x;
y_annual=y;

% compute percentile of x
[~,I_sort]=sort(x_annual);
x_percentile(I_sort)=(1:length(x_annual))/length(x_annual)*100;

% compute percentile of y
[~,I_sort]=sort(y_annual);
y_percentile(I_sort)=(1:length(y_annual))/length(y_annual)*100;

% compute ratio of y/x
ratio=y(:)./x(:);
[~,I_sort]=sort(ratio);
R_percentile(I_sort)=(1:length(ratio))/length(ratio)*100;

% fit linear regression
a=x_percentile;
b=y_percentile;

mdl = fitlm(a(1:end),b(1:end),'linear','Intercept',false);
R2=mdl.Rsquared.Ordinary;

mdl2 = fitlm(a(1:end-1),b(1:end-1),'linear','Intercept',false);
[b_est,confident]=predict(mdl2,a(end));
disp(['predicted streamflow is off by ' num2str((b_est-b(end))/b_est*100) '%'])
disp(['Predicted: ' num2str(b_est)])
disp(['Observed: ' num2str(b(end))])
disp(['R^2: ' num2str(mdl2.Rsquared.Ordinary)])

residual=mdl.Residuals.Pearson;

% plot linear regression line
plot(x_percentile(1:end),mdl.Fitted,'color',[169 169 169]/255)
hold on 
% plot scatter plots
scatter(x_percentile,y_percentile,100,R_percentile,'filled')

axis image
xticklabels(num2cell(xticks))
yticks(xticks);
yticklabels(num2cell(yticks))
set(gca,'XMinorTick','on')
set(gca,'YMinorTick','on')

text(x_percentile(norm_idx)+2,y_percentile(norm_idx)-0.5,num2str(WYs(norm_idx)'),'fontsize',14)
text(x_percentile(iyear)+2,y_percentile(iyear)-0.5,num2str(WYs(iyear)'),'fontsize',16,'Fontweight','bold')

Inan=find(~isnan(x_percentile)|~isnan(y_percentile));
R=corr(x_percentile(Inan)',y_percentile(Inan)');
text(2,97,['R^2 = ' num2str(R2,'%2.2f')])
end