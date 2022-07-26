% Scripts of Figure 4. Radar plot of streamflow and its contributors
% Written by Yiwen Fang, 2022

%% Figure settings
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultLineLineWidth',1.5,'DefaultLineMarkerSize',6,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',14,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',16)

% load percentile data
DATA_PATH='../data/';
load([DATA_PATH 'streamflow_contributor_percentiles_WY1988_2021.mat'])

Basin_str={'Feather','American','Kern','Headwaters','Gunnison'};
nbasin=length(Basin_str);
basin_idx=1:nbasin;

WYs=1985:2021;
WYs_sub=1988:2021;
ist_year=find(WYs_sub(1)==WYs);
nyears=length(WYs_sub);

select_year=[2015,2021];
select_year2=[2002,2021];

for j=1:length(select_year)
    iyear(j)=find(WYs_sub==select_year(j));
    iyear2(j)=find(WYs_sub==select_year2(j));
end

%% Radar plot
figure
set(gcf,'position',[40,85,1680,900])
ha=tight_subplot(2,3,[0.08,0.05],[0.02 0.05],[0.02,0.02]);
delete(ha(6))

% pre-allocate data
data=nan(length(select_year),6);

for idx=1:nbasin
    pidx=basin_idx(idx);
    axes(ha(idx))
    for iyr=1:length(select_year)
        if idx==1 || idx==2 || idx==3
            % Collect contributors and steamflow percentiles for each basin
            % and each year
            data(iyr,:) = [SWE_ano_per(pidx,iyear(iyr));...
                PPT_spring_per(pidx,iyear(iyr));meltout_day_per(pidx,iyear(iyr));
                Ta_post_snow_per(pidx,iyear(iyr));...
                flow_per(pidx,iyear(iyr));PPT_pre_s_per(pidx,iyear(iyr))];
            legend_str =num2str(WYs_sub(iyear)');
                        
        else
            % Collect contributors and steamflow percentiles for each basin
            % and each year
            data(iyr,:) = [SWE_ano_per(pidx,iyear2(iyr));...
                PPT_spring_per(pidx,iyear2(iyr));meltout_day_per(pidx,iyear2(iyr));
                Ta_post_snow_per(pidx,iyear2(iyr));...
                flow_per(pidx,iyear2(iyr));PPT_pre_s_per(pidx,iyear2(iyr))];
            legend_str =num2str(WYs_sub(iyear2)');            
        end
    end
    
    % Spider plot
    spider_plot_mod(data,...
        'AxesInterval', 4,...
        'AxesPrecision', 0,...
        'AxesDisplay', 'one',...
        'AxesLimits', [0 0 0 0 0 0; 100 100 100 100 100 100],...
        'FillOption', 'on',...
        'FillTransparency', 0.1,...
        'Color', [139, 0, 0;0 0 0]/255,...
        'LineWidth', 3,...
        'Marker', 'o',...
        'AxesFont', 'Arial',...
        'AxesFontSize', 18,...
        'LabelFontSize', 18,...
        'AxesColor', [0.8, 0.8, 0.8],...
        'AxesLabelsEdge', 'none',...
        'AxesLabels',  {[{'OCT-JUL snowmelt'}],[{'APR-JUL'} {'PPT'}],...
        [{'Melt-out'} {'day'}],[{'Post-snow T_a'}],...
        [{'OCT-JUL'} {'streamflow'}],[{'Pre-snow'} {'PPT'}]},...
        'AxesRadial', 'off');
    grid off
    
    % Title and legend properties
    title(Basin_str(pidx),...
        'FontSize', 24);
    lg=legend(legend_str, 'Location', 'northeast');
    lg.FontSize=18;
    pos=lg.Position;
    lg.Position=[pos(1)+0.02 pos(2)+0.02 pos(3) pos(4)];
end