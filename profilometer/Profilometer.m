% List of files to plot (in desired subplot order)
filenames = {
    'V1CE4000_profilometer_2.csv'
    'V1PE3000_profilometer_2.csv'
    'V1PE2000_profilometer_2.csv'
    'V1PE1500_profilometer_2.csv'
    };

% Number of subplots
nrows = 2;
ncols = 2;

figure ("Color", 'white');
for k = 1:length(filenames)
    % Read CSV data
    data = readmatrix(filenames{k}); 
    if isnan(data(1,1)) || isnan(data(1,2))
        data = readmatrix(filenames{k},'NumHeaderLines',1);
    end
    
    % Define matricies variables
    lateral = data(:,1);
    profile = data(:,2);

    % Subplot
    subplot(nrows, ncols, k);
    plot(lateral, profile, 'Color', [0 0 0], 'LineWidth', 1.5);
    xlabel('Lateral Position (mm)');
    ylabel('Profile (nm)');
    ylim([-500 2500]);
    grid on;
end


