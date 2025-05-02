function spot_intensity = spot_intensity_roi(matfile, varname, centre, radius)
% spot_intensity_roi - Compute and plot integrated intensity in a circular ROI
%
% Usage:
%   spot_intensity = spot_intensity_roi(matfile, varname, centre, radius)
%
% Inputs:
%   matfile  - Name of .mat file containing the matrix variable
%   varname  - Name of variable inside the .mat file (string)
%   centre   - [cx, cy] center of ROI (pixels)
%   radius   - ROI radius (pixels)
%
% Output:
%   spot_intensity - Sum of intensity inside the circular ROI
% 
% Notes:
%     spot_intensity_roi('snap_V1PE4000.mat', 'dp', [316 465], 13)
%     spot_intensity_roi('snap_V1PE3000.mat', 'dp', [850 186], 2)
%     spot_intensity_roi('snap_V1PE2000.mat', 'dp', [165 319], 6)
%     spot_intensity_roi('snap_V1PE1500.mat', 'dp', [21 268], 7)

    % Load variable from .mat file
    S = load(matfile, varname);
    dp = S.(varname); % matrix (e.g. intensity or field)
    [height, width] = size(dp);

    % If dp is complex, convert to intensity
    % if ~isreal(dp)
    %     intensity = abs(dp).^2;
    % else
    %     intensity = dp;
    % end

    intensity = dp;

    % Generate circular mask
    [xx, yy] = meshgrid(1:width, 1:height);
    mask = sqrt((xx-centre(1)).^2 + (yy-centre(2)).^2) <= radius;

    % Compute integrated intensity in ROI
    spot_intensity = mean(intensity(mask));

    % Plot intensity map and ROI to verify mask region
    figure;
    imagesc(intensity); axis image; colormap gray; colorbar;
    hold on;
    viscircles(centre, radius, 'EdgeColor', 'b', 'LineWidth', 1.5);
    plot(centre(1), centre(2), 'bx', 'MarkerSize', 12, 'LineWidth', 2);
    hold off;
    title(sprintf('Integrated Intensity in ROI: %.3f', spot_intensity));
    xlabel('X (pixels)'); ylabel('Y (pixels)');
end