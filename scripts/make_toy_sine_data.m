%tb
flyname = 'tb';
toyGain = [];
toyGain(1,:) = [0.5, 0.5, 0.55, 0.65, 0.8, 0.75, 0.7, 0.5, 0.4, 0.3 ,0.2];
toyGain(2,:) = [0.45, 0.45, 0.5, 0.6, 0.8, 0.65, 0.5, 0.15, 0.4, 1 , 0.5];

% phase in deg, +ve = phase-lag
toyPhase = [];
toyPhase(1,:) = [30, 30, 25, 25, 25, 0, 0, 0, 5, 15, 25];
toyPhase(2,:) = [30, 30, -10, -10, -10, -10, 0, 10, 15, 0, 0];

fpsVec = [50,50,60,125,250,500,500,500,1000,1200,1200];
stimfreqs = [0.06,0.1,0.3,0.6,1,3,6,10,15,20,25];
%%
flies = 1;
stims = struct;
framerates = struct;
headroll = struct;
for fidx = 1:length(stimfreqs)
    for cidx = 1:2
      %%
        t = linspace(0,50,50*fpsVec(fidx)) ;
        p = fpsVec(fidx)*stimfreqs(fidx);
        stim = 30*sin(2*pi*stimfreqs(fidx).*t);
        stims.cond(cidx).freq(fidx).trial(:,1) = stim;
        
        
        resp = 30*toyGain(cidx,fidx)*sin(2*pi*stimfreqs(fidx).*t - deg2rad(toyPhase(cidx,fidx)));
        
        resp = circshift((-toyGain(cidx,fidx).*stim ),round(toyPhase(cidx,fidx)*fpsVec(fidx)/(360*stimfreqs(fidx))))+ stim;
        
        headroll.cond(cidx).freq(fidx).trial(:,1) = resp;
        
        framerates(1).cond(cidx).freq(fidx).trial(1) = fpsVec(fidx);
    
     %{
 figure,plot([t;t]',[stim;resp]')
%}
        %%
    end
end

try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
getHRplotParams

%{
save(fullfile(rootpathHR,'..\mat\TOY_fixed_sines.mat'),'toyGain','toyPhase','headroll','framerates','stims','flies','stimfreqs');
%}

flyname = ['toy_' flyname];
condSelect = [1,2];
color_mat = {};
color_mat{condSelect(1)} = tb_col;
color_mat{condSelect(2)} = darkGreyCol;
legCell = {'no ocelli';'no halteres'};

bodeprintflag = 0;
plot_slipspeed_script