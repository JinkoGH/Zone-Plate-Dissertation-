% Main script to generate a range of binary bitmaps

% Input parameters
% 2 micro meter scale
% focal_lengths = [1, 2, 3, 4, 5] * 10^-02
% pixel_sizes = 2 * 10^-6;
% 5 micro meter scale
focal_lengths = [5, 10, 15, 20, 25, 30] * 10^-02;
pixel_sizes = 5 * 10^-6;
% 10 micro meter scale
% focal_lengths = [20, 40, 60, 80, 100] * 10^-2;
% pixel_sizes = 10 * 10^-6;	
 
% Fixed input values
wavelength = 675 * 10^-9;   % Wavelengths in meters
image_size = 512;           % Image sizes in pixels
 
% Total number of combinations
num_combinations = numel(focal_lengths) * numel(pixel_sizes);
figure;
plot_idx = 1;
 
% Loop through each combination of focal length and pixel size
for f = focal_lengths
	for p = pixel_sizes
    	% Generate and display binary bitmap for each parameter set
    	bitmap = generate_binary_bitmap(f, wavelength, p, image_size);

    	% Add white plot (1024 x 1024) canvus
    	% bordered_bitmap = add_border(bitmap, 768);
        bordered_bitmap = add_border(bitmap, 1024);
 
    	% Display bitmap in a subplot
    	subplot(ceil(sqrt(num_combinations)), ceil(sqrt(num_combinations)), plot_idx);
    	imshow(bordered_bitmap);
    	title(sprintf('f=%.2fcm, p=%.1fμm', f*100, p*1e6));
    	plot_idx = plot_idx + 1;

	end
end
disp('Bitmap generation process & file download ended.');
 
% Function to create a binary bitmap
function bitmap = generate_binary_bitmap(focal_length, wavelength, pixel_size, image_size)
	% Initialize variablesI
	center = image_size / 2;           	            % Centre of the square image
	max_radius = (image_size / 2) * pixel_size;     % Max radius in meters
	bitmap = zeros(image_size);        	            % Initialize the bitmap as all zeros (black)
	
    % Calculate the radii for the transparent/opaque zones
	n = 1;          % Zone counter
	radii = [];     % Array to store the radii of the zone boundaries
	while true
    	% Calculate the radius for each nth zone
    	rn = sqrt((n * wavelength * focal_length) + 1/4 * (n^2 * wavelength^2));
    	if rn > max_radius
        	break;                        
    	end
    	radii = [radii, rn]; 
    	n = n + 1;     
	end
	
	% Convert radii to pixel distances
	radii_pixels = radii / pixel_size;
	
	% Generate the binary pattern
	for x = 1:image_size
    	for y = 1:image_size
        	% Calculate the distance from the center of the image in pixels
        	dist = sqrt((x - center)^2 + (y - center)^2);
        	
        	% Determine if the distance falls within an opaque or transparent zone
        	zone = find(radii_pixels > dist, 1);
        	if mod(zone, 2) == 1
            	bitmap(x, y) = 1;      	% White (transparent) zone
        	else
            	bitmap(x, y) = 0;      	% Black (opaque) zone
        	end
    	end
	end
 
	% Scale the bitmap to the range [0, 255] for 8 bit image
	bitmap = uint8(bitmap * 255);
end
 
% Add a white border around the bitmap to reach target size
function bordered_bitmap = add_border(bitmap, target_size) 
	% Validate inputs
	[original_size, ~] = size(bitmap);
	
	% Calculate border size
	padding = (target_size - original_size) / 2;
 
	% Create a white canvas
	bordered_bitmap = uint8(255 * ones(target_size, target_size)); % White canvas
	
	% Embed the original bitmap in the center of the canvas
	start_idx = padding + 1;
	end_idx = start_idx + original_size - 1;
	bordered_bitmap(start_idx:end_idx, start_idx:end_idx) = bitmap;
end 