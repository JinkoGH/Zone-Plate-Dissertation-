% Main script to generate a range of continuous zone bitmaps

% Final ranges for parameters
% focal_lengths = [5, 10, 15, 25, 30] * 10^-2;
% pixel_sizes = 5 * 10^-6;            
% num_steps = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];

focal_lengths = 10 * 10^-2;
pixel_sizes = 5 * 10^-6;
num_steps = 5:5:30;

% Fixed values
wavelength = 675 * 10^-9;              % Wavelength in meters
image_size = 512;                       % Image size in pixels

% Total number of combinations
num_combinations = numel(focal_lengths) * numel(pixel_sizes) * numel(num_steps);
figure;
plot_idx = 1;

% Loop through each combination of focal length and pixel size
for f = focal_lengths
    for p = pixel_sizes
        for steps = num_steps
            % Generate and display continuous bitmap for each parameter set
            bitmap = generate_continuous_bitmap(f, wavelength, p, image_size, steps);

            % Add white plot (1024 x 1024) canvas
            bordered_bitmap = add_border(bitmap, 1024);
            
            % Display bitmap in a subplot
            subplot(ceil(sqrt(num_combinations)), ceil(sqrt(num_combinations)), plot_idx);
            % imshow(bordered_bitmap);
            imshow(bitmap);
            title(sprintf('f=%.2fcm, p=%.1fμm, steps=%d', f*100, p*1e6, steps));
            plot_idx = plot_idx + 1;

            % Save the bitmap as a BMP file
            % filename = sprintf('continuous_bitmap_f%.2fcm_p%.1fum_steps%d.bmp', f*100, p*1e6, steps);
            % imwrite(uint8(bitmap * (255 / max(bitmap(:)))), filename); % Normalize to 0-255
            % disp(['Saved bitmap as ', filename]);
        end
    end
end


% Function to create a continuous zone bitmap
function bitmap = generate_continuous_bitmap(focal_length, wavelength, pixel_size, image_size, num_steps)
    % Define parameters
    k = pi / (focal_length * wavelength);  % Scale constant for sinusoidal formula
    center = image_size / 2;              % Center of the square image
    max_radius = (image_size / 2) * pixel_size; % Max radius in meters
    step_size = 1 / num_steps;            % Step size for quantization (normalized to 0-1)

    % Initialize the bitmap
    bitmap = zeros(image_size);           % Create an empty matrix for the image

    % Generate the zone plate
    for x = 1:image_size
        for y = 1:image_size
            % Calculate distance from the center in meters
            dx = (x - center) * pixel_size;
            dy = (y - center) * pixel_size;
            dist = sqrt(dx^2 + dy^2);        % Radial distance from the center

            % Check if the radius exceeds the maximum allowable radius
            if dist > max_radius
                continue;                 % Skip points outside the maximum radius
            end

            % Apply the sinusoidal formula and quantize it
            smooth_opacity = (1 + cos(k * dist^2)) / 2; % Smooth sinusoidal function
            quantized_opacity = floor(smooth_opacity / step_size) * step_size; % Quantize
            bitmap(x, y) = quantized_opacity; % Assign the quantized value to the bitmap
        end
    end

    % Scale the bitmap to the range [0, 255] for 8 bit image
    bitmap = uint8(bitmap * 255);
end

function bordered_bitmap = add_border(bitmap, target_size)  
    % Validate inputs
    [original_size, ~] = size(bitmap);
    
    % Calculate border size
    border = (target_size - original_size) / 2;

    % Create a white canvas
    bordered_bitmap = uint8(255 * ones(target_size, target_size)); % White canvas
    
    % Embed the original bitmap in the center of the canvas
    start_idx = border + 1;
    end_idx = start_idx + original_size - 1;
    bordered_bitmap(start_idx:end_idx, start_idx:end_idx) = bitmap;
end
