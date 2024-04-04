function orb = plot_tle(data)
    % These Values are specific for Earth only !
    mu = 398600.4418;
    r = 6781; % Earth's radius in km
    D = 24 * 0.997269; % one day

    orb = cell(length(data)/2, 1);
    for i = 1:length(data)/2
        if data{(i-1)*2+1}(1) ~= '1'
            disp(['Wrong TLE format at line ', num2str((i-1)*2+1), '. Lines ignored.']);
            continue;
        end

        if str2double(data{(i-1)*2+1}(19:20)) > mod(year(datetime), 100)
            t_str = ['19', data{(i-1)*2+1}(19:20), ' ', num2str(str2double(data{(i-1)*2+1}(21:23))), ' ',...
                num2str(24 * str2double(data{(i-1)*2+1}(23:32))), ' ',...
                num2str(24 * 60 * str2double(data{(i-1)*2+1}(23:32))), ' ',...
                num2str(24 * 60 * 60 * str2double(data{(i-1)*2+1}(23:32)))];
        else
            t_str = ['20', data{(i-1)*2+1}(19:20), ' ', num2str(str2double(data{(i-1)*2+1}(21:23))), ' ',...
                num2str(24 * str2double(data{(i-1)*2+1}(23:32))), ' ',...
                num2str(24 * 60 * str2double(data{(i-1)*2+1}(23:32))), ' ',...
                num2str(24 * 60 * 60 * str2double(data{(i-1)*2+1}(23:32)))];
        end
%         orb{i}.t = datetime(t_str, 'InputFormat', 'yy dd HH mm ss');
        orb{i}.name = strtrim(data{(i-1)*2+2}(3:7));
        orb{i}.e = str2double(['0.', data{(i-1)*2+2}(27:34)]);
        orb{i}.a = (mu / ((2*pi*str2double(data{(i-1)*2+2}(53:63))/(D*3600))^2))^(1/3);
        orb{i}.i = str2double(data{(i-1)*2+2}(9:16)) * pi / 180;
        orb{i}.RAAN = str2double(data{(i-1)*2+2}(18:25)) * pi / 180;
        orb{i}.omega = str2double(data{(i-1)*2+2}(35:42)) * pi / 180;
        orb{i}.b = orb{i}.a * sqrt(1 - orb{i}.e^2);
        orb{i}.c = orb{i}.a * orb{i}.e;
        % Calculate points on the orbit
        R = [cos(orb{i}.RAAN), -sin(orb{i}.RAAN), 0; sin(orb{i}.RAAN), cos(orb{i}.RAAN), 0; 0, 0, 1] ...
            * [1, 0, 0; 0, cos(orb{i}.i), -sin(orb{i}.i); 0, sin(orb{i}.i), cos(orb{i}.i)];
        R = R * [cos(orb{i}.omega), -sin(orb{i}.omega), 0; sin(orb{i}.omega), cos(orb{i}.omega), 0; 0, 0, 1];

        x = [];
        y = [];
        z = [];
        theta = linspace(0, 2*pi, 100);
        for j = 1:length(theta)
            P = R * [orb{i}.a * cos(theta(j)); orb{i}.b * sin(theta(j)); 0] - R * [orb{i}.c; 0; 0];
            x = [x, P(1)];
            y = [y, P(2)];
            z = [z, P(3)];
        end
        plot3(x,y,z)
        grid on;
        hold on;
        % Lets visualize earth first using mesh
        [u, v] = meshgrid(linspace(0, 2*pi, 50), linspace(0, pi, 30));
        % Convert spherical coordinates to Cartesian coordinates
        x_sphere = r * cos(u).* sin(v);
        y_sphere = r * sin(u) .* sin(v);
        z_sphere = r * cos(v);
        % Full sphere
        surf(x_sphere, y_sphere, z_sphere, 'FaceColor', 'none', 'FaceAlpha', 0.5,...
        'EdgeColor', 'b', 'DisplayName', 'Earth');
        hold on;

        % Plot details
        % title(['Orbits plotted in the ECE frame as of ', datestr(orb.t, 'mm yyyy')]);
        xlabel("X-Distance in Km");
        ylabel("Y-Distance in Km");
        zlabel("Z-Distance in Km");

        % Display legend
        if length(data) / 2 < 20
        legend;
        else
            lgd = legend('Location', 'eastoutside', 'FontSize', 7);
        end    
    end
end