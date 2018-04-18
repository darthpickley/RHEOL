%generate model


load planet;
load rock;

Celsius=273.15;

%% planet
% ip = 
%Ts = planet(ip).env.Ts;
%Ti = planet(ip).env.Ti;
%G = planet(ip).env.G;
%P0 = planet(ip).env.P0;
%g = planet(ip).global.gravity;

%% thermal

% surface temp
% Ts = 
%surface temp gradient
% G = 
%adiabatic temp
% Ti = 
del=2*(Ti-Ts)/(G*sqrt(pi));

% setup temperature
switch thid
    case 2
        Temperature=@(z)Ts+(Ti-Ts)*erf(z/del);
    otherwise
        Temperature=@(z)min(Ts+z*G,Ti);
end

%% def

% did =  %deformation
    % 1 - compression
    % 2 - extension
    % 3 - strike-slip
% e =    %strain rate

%% model

il=0;
Pbot=P0;ztop=0;zbot=0;

for il = 1:(size(model,2))
       
    %% parse fxblox{}
    
    ki=1;
    
    model(il).nrock=length(model(il).irock);
    model(il).Ci=ones(1,model(il).nrock)/model(il).nrock; %Concentration initialize

%     if model(il).nrock>1;
%         anz=input('Enter the volume proportion of each rock type');
%         if anz ~= "def"
%             model(il).Ci=anz/sum(anz);
%         end
%     end
    
    if ~isempty(model(il).irock);
        %% thickness
        
        % model(il).thick =
        model(il).ztop=zbot;
        zbot=zbot+model(il).thick;
        model(il).zbot=zbot;
        
        ibrit=[];
        
        %disp('  1: Byerlee, low P branch');
        %disp('  2: Byerlee, high P branch');
        %disp('  3: Tensile strength');
        %anz=input('Desired brittle rheology (can be a vector): ');
        %nrheol=size(rock(model(il).irock(im)).rheol,2);
        %for ir=1:nrheol
        %    disp(sprintf('%4d: %s: %s',...
        %        ir,...
        %        rock(model(il).irock(im)).rheol(ir).name,...
        %        rock(model(il).irock(im)).rheol(ir).ref));
        %end
        %anz=input('Desired ductile rheology (can be a vector; enter 0 for brittle only): ');
        %anz = str2num(fxblox{ki}); %ductile rheology
        %ki=ki+1;
        %disp(['ductile rheologies: ',sprintf('%i ',anz)]);
        %if ~isempty(anz)
        %    if anz==0;
        %        nduct=0;
        %        iduct=[];
        %    else
        %        nduct=length(anz);
        %        iduct=anz;
        %    end
        
        %% rheologies
        
        for im=1:model(il).nrock
            
            % model(il).rock(im).irheol=
            model(il).rock(im).nrheol=length(model(il).rock(im).irheol);
            model(il).rock(im).Wk=1;
            
            ibrit = []; iduct = []; nbrit = 0; nduct = 0;
            
            for ia = 1:model(il).rock(im).nrheol
                rhla = model(il).rock(im).irheol(ia);
                if (rhla < 0)
                    ibrit = [ibrit,-rhla];
                    nbrit = nbrit+1;
                else
                    iduct = [iduct,rhla];
                    nduct = nduct+1;
                end
            end % end for(ia)
        end % end im--nrock loop
        
        %ibrit=[1,2];
        %if model(il).irock==10;
        %    anz=input('Serpentine detected: Is it lizardite (low F, default = no): ');
        %    if ~isempty(anz);
        %        if or(strncmpi(anz,'yes',1),anz==1);
        %            ibrit=[3,4];
        %        end
        %    end
        %end
        
        %% pore fluid pressure
        
        % model(il).pf =
        model(il).Ptop=Pbot;
        rhoav=0;
        for im=1:model(il).nrock;
            rhoav=rhoav+rock(model(il).irock(im)).density*model(il).Ci(im);
        end
        if model(il).pf=='p'
            model(il).rhog=(rhoav-1e3)*...
                planet(ip).global.gravity;
        else
            model(il).rhog=rhoav*(1-model(il).pf)*...
                planet(ip).global.gravity;
        end
        Pbot=model(il).Ptop+model(il).thick*model(il).rhog;
        model(il).Pbot=Pbot;
        
        %% grain dependence
        
        for im=1:model(il).nrock
            %model(il).gs(im)=0;
            
            %model(il).rock(im).gc = 
            %model(il).rock(im).gs = 
            model(il).rock(im).gdep=zeros([nrock,nduct+2]);
            for ir=1:nduct
                if (rock(model(il).irock(im)).rheol(iduct(ir)).m~=0);
                    model(il).rock(im).gdep(ir)=1;%(model(il).gs(im)==0);
                    model(il).rock(im).gs=10e-3; %model(il).gs(im)=100e-6;
                    %                     if (rock(model(il).irock(im)).rheol(iduct(ir)).m~=0)&...
                    %                             (model(il).rock(im).gs==0);%(model(il).gs(im)==0);
                    %                         model(il).rock(im).gs=10e-3; %model(il).gs(im)=100e-6;
                end
            end
            
            if model(il).rock(im).gs~=0;
                %disp(sprintf('Detecting grain-size-dependent laws; default grain size: %g microns',model(il).rock(im).gs*1e6));
                %disp(sprintf('Detecting grain-size-dependent laws\n default behavior: grain size fixed at %g microns',...
                %    model(il).rock(im).gs*1e6));
                
                npiez=numel(rock(model(il).irock(im)).piezo);
                        %number of piezometers
                if npiez==0
                    %anz=input(sprintf(...
                    %    'Enter new grain size for layer %d (in m):',il));
                    %no piezometers opt
                    
                    %disp(['grain size is now   ',sprintf('%f',model(il).rock(im).gs)]);
                    
                else
                    % piezometer or grain size
                    %disp(['gs code:  ', sprintf('%g',model(il).rock(im).gc)]);
                    GC = model(il).rock(im).gc;
                    if GC==0;
                        % model(il).rock(im).gs = 
                    else
                        % imposes limits to 1 micron and 1 meter
                        model(il).rock(im).gs=@(s)min(max(rock(model(il).irock(im)).piezo(GC).geq(s),1e-6),1);
                    end %if anz~=0
                end %if npiez==0
            end %if model(il).rock(im).gs~=0
            model(il).rock(im).Wk=1;
        end
        
        model(il).rock(im).Ty=NaN;
        if ~isempty(find(ibrit==0));
            fprintf('Default tensile strength: Ty=%g MPa \n',model(il).rock(im).Ty);
            anz=input('Enter desired tensile strength (in MPa): ');
            if ~isempty(anz)
                model(il).rock(im).Ty=anz*1e6;
            end
        end
    end
end