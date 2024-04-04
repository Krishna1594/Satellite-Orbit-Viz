%% Our data
[FileName,PathName] = uigetfile('*.txt','Select the Text file');
ADDR = fopen(FileName, 'r');
TLE = textscan(ADDR, '%s', 'Delimiter', '\n');
fclose(ADDR);

% Extract data from TLE cell array
TLE = TLE{1};  % Extracting the content from the cell array
orbs = plot_tle(TLE)