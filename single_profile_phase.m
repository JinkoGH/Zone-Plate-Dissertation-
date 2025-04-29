function single_profile_phase()
    profile = improfile;
    
    % Unwrap profile
    unwrapped_profile = unwrap(profile);
    
    figure;
    plot(unwrapped_profile, 'LineWidth', 2);
    xlabel('Radius (Pixels)');
    ylabel('Unwrapped phase (radians)');
    title('Unwrapped Phase Profile');
    grid on;
end