%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% rheol.m
%
% Laurent Montesi, 11/17/2014
% Tools for manipulating strength profiles
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load planet data
%load planet
% load rock data
%load rock
% Some constant
%Celsius=273.15;


% Define model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%choose_planet
%choose_th
%choose_def
%choose_model
%%

parse_script;
disp(sprintf('%4d: %s',1,'Compression'));
disp(sprintf('%4d: %s',2,'Extension'));
disp(sprintf('%4d: %s',3,'Strike-slip'));
%did=input('Enter style of deformation: ');
did=1;

Options(1).Name='Single profile';
Options(2).Name='Grain size reduction';
Options(3).Name='Brittle strength reduction';


ifig=1;
calc_strength;
plot_strength_integrate;

%Choice=-1;
%while (Choice<0)|(Choice>numel(Options));
%    disp(sprintf('\nChoice %2d: Stop',0));
%    for ic=2:numel(Options)
%        disp(sprintf('Choice %2d: %s',ic-1,Options(ic).Name));
%    end
%    ans=input('Enter new Choice');
%    if ~isempty(ans);
%        Choice=ans;
%    end
%    
%    switch Choice
%       case 1
%           DriveGrainSize;
%            Choice=-1;
%        case 2
%            DriveBrittle;
%            Choice=-1;
%    end
%end

%ifig=1; plot_strength_integrate