function radial_profile = radial_profile_phase(matfile, varname, cx, cy)
% radial_profile_phase - Compute radial phase profile from a zone plate file
%
% Usage:
%   radial_profile = radial_profile_phase(matfile, varname, cx, cy)
%
% Inputs:
%   matfile  - Path to .mat file containing the zone plate variable
%   varname  - Name of the variable inside the .mat file
%   cx, cy   - Centre coordinates (pixels)
%
% Output:
%   radial_profile - The computed mean phase profile as a function of radius
% 
% Record of commands (w/ estimated center coords of zone plates): 
%     radial_profile_phase('V1PE4000_optics_2.mat', 'obj', 1070, 917)
%     radial_profile_phase('V1PE3000_optics_2.mat', 'obj', 1490, 1448)
%     radial_profile_phase('V1PE2000_optics_2.mat', 'obj', 1608, 874)
%     radial_profile_phase('V1PE1500_optics_2.mat', 'obj', 437, 446)

    % Load specified variable
    S = load(matfile, varname);
    data = S.(varname);

    % Get wrapped phase
    data = angle(data);

    [height, width] = size(data);
    [xx, yy] = meshgrid(1:width, 1:height);
    r = sqrt((xx-cx).^2 + (yy-cy).^2);
    r_rounded = round(r);

    max_r = floor(min([width-cx, cx, height-cy, cy]));
    radial_profile = zeros(1, max_r);

    for rad = 1:max_r
        mask = (r_rounded == rad);
        vals = data(mask);
        % Use circular mean for phase
        radial_profile(rad) = angle(mean(exp(1i*vals(:))));
    end

    % Unwrap phase profile
    radial_profile = unwrap(radial_profile);

    % Plot profile
    radii = 1:max_r;
    figure;
    plot(radii, radial_profile, 'LineWidth', 1.5);
    xlabel('Radius (pixels)');
    ylabel('Mean phase (radians)');
    title('Zone Plate Radial Phase Profile');
    grid on;
end