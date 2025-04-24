% Script: process_zone_plate_ptyochography.m
% Purpose: Load and visualize amplitude and phase from zone plate ptychography reconstructions

clc;
clear;
close all;

% --- Setup ---
% Folder containing the .mat files
data_folder = '/home/jinko/University files/Micro optics project/optics';

% List of files
file_names = {
    'V1PE4000_optics_2.mat',...
    'V1PE3000_optics_2.mat',...
    'V1PE2000_optics_2.mat',...
    'V1PE1500_optics_2.mat'
};

% Output folder for amplitude and phase images
output_folder = fullfile(data_folder, 'output_images');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Struct to hold all loaded objects 
all_objs = struct();

% --- Loop over files ---
for i = 1:length(file_names)
    file_path = fullfile(data_folder, file_names{i});
    fprintf('Processing: %s\n', file_path);

    % Load the .mat file as a struct
    S = load(file_path);

    % Get the (first) variable name in the mat file
    fieldNames = fieldnames(S);
    if isempty(fieldNames)
        error('No data found in %s', file_names{i});
    end

    % Extract the object (complex array)
    obj = S.(fieldNames{1});

    % Store in struct with a field based on filename (without extension and illegal chars)
    [~, base_name, ~] = fileparts(file_names{i});
    base_name = matlab.lang.makeValidName(base_name); % ensures valid field name
    all_objs.(base_name) = obj;

    % --- Amplitude and Phase Extraction ---
    amplitude = abs(obj);
    phase = angle(obj);

    % --- Visualization ---
    figure('Name', file_names{i}, 'NumberTitle', 'off', 'Position', [100 100 1200 450]);
    subplot(1,2,1);
    imagesc(amplitude); axis image off; colormap gray; colorbar;
    title('Object Map');

    subplot(1,2,2);
    imagesc(phase); axis image off; colormap hsv; colorbar;
    title('Phase Map');

    sgtitle(sprintf('Results for %s', file_names{i}), 'Interpreter', 'none');

    % --- Save images ---
    % % Normalize for saving as 8-bit PNG
    % amp_img = uint8(255 * mat2gray(amplitude));
    % phase_img = uint8(255 * mat2gray(phase)); % phase is in [-pi, pi]
    % 
    % [~, base_name, ~] = fileparts(file_names{i});
    % imwrite(amp_img, fullfile(output_folder, [base_name '_amplitude.png']));
    % imwrite(phase_img, fullfile(output_folder, [base_name '_phase.png']));
    % 
    % % Optionally: save as .mat for further processing
    % save(fullfile(output_folder, [base_name '_amplitude.mat']), 'amplitude');
    % save(fullfile(output_folder, [base_name '_phase.mat']), 'phase');
end

disp('Processing complete. Images saved to:');
disp(output_folder);

% End of script