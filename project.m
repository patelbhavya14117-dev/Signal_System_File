
function EnergyPowerClassifier

clc;
close all;

% ENERGY VS POWER SIGNAL CLASSIFIER WITH GUI

T = 20;
dt = 0.01;
t = -T:dt:T;

% Define 8 test signals
x{1} = exp(-abs(t));
x{2} = exp(-t).*(t >= 0);
x{3} = sin(2*pi*t);
x{4} = cos(2*pi*t);
x{5} = ones(size(t));
x{6} = t.*exp(-abs(t));
x{7} = exp(-t.^2);
x{8} = sin(4*pi*t) + cos(2*pi*t);

names = {'Exponential','Decaying Exponential',...
         'Sine','Cosine','Constant',...
         'Damped Ramp','Gaussian','Combined Signal'};

% Create GUI window
f = figure('Name','Energy vs Power Signal Classifier',...
    'NumberTitle','off',...
    'Position',[100 100 1000 600],...
    'Color',[0.90 0.95 1.00]);

% Main heading
uicontrol(f,'Style','text',...
    'String','ENERGY VS POWER SIGNAL CLASSIFIER',...
    'Position',[200 550 600 35],...
    'FontSize',16,...
    'FontWeight','bold',...
    'BackgroundColor',[0.90 0.95 1.00]);

% Signal selection
uicontrol(f,'Style','text',...
    'String','Select Test Signal:',...
    'Position',[30 500 150 25],...
    'FontSize',11,...
    'BackgroundColor',[0.90 0.95 1.00]);

signalMenu = uicontrol(f,'Style','popupmenu',...
    'String',names,...
    'Position',[180 500 200 30],...
    'FontSize',11);

% Output area
resultBox = uicontrol(f,'Style','edit',...
    'Position',[30 180 400 300],...
    'Max',20,...
    'Min',0,...
    'HorizontalAlignment','left',...
    'FontSize',11,...
    'BackgroundColor','white',...
    'String','Select a signal and click Calculate Results.');

% Plot axes
ax = axes('Parent',f,...
    'Position',[0.52 0.35 0.43 0.48]);

% Calculate button
uicontrol(f,'Style','pushbutton',...
    'String','Calculate Results',...
    'Position',[30 130 180 35],...
    'Callback',@calculateResults);

% Plot button
uicontrol(f,'Style','pushbutton',...
    'String','Plot Signal',...
    'Position',[230 130 180 35],...
    'Callback',@plotSignal);

% Plot all signals button
uicontrol(f,'Style','pushbutton',...
    'String','Plot All 8 Signals',...
    'Position',[30 80 180 35],...
    'Callback',@plotAllSignals);

% Animation button
uicontrol(f,'Style','pushbutton',...
    'String','Pulse Animation',...
    'Position',[230 80 180 35],...
    'Callback',@pulseAnimation);

% Crossover button
uicontrol(f,'Style','pushbutton',...
    'String','Crossover Amplitude',...
    'Position',[430 80 180 35],...
    'Callback',@crossoverAmplitude);

% Viva button
uicontrol(f,'Style','pushbutton',...
    'String','Viva Answer',...
    'Position',[630 80 150 35],...
    'Callback',@vivaAnswer);

% Clear button
uicontrol(f,'Style','pushbutton',...
    'String','Clear Output',...
    'Position',[800 80 150 35],...
    'Callback',@clearOutput);


% FUNCTION 1: Calculate Energy and Power

function calculateResults(~,~)

    k = get(signalMenu,'Value');

    E = trapz(t,abs(x{k}).^2);
    P = E/(2*T);

    if k == 1 || k == 2 || k == 6 || k == 7
        type = 'Energy Signal';
    else
        type = 'Power Signal';
    end

    output = {
        ['Signal: ',names{k}]
        ['Energy = ',num2str(E,'%.4f')]
        ['Average Power = ',num2str(P,'%.4f')]
        ['Classification: ',type]
        ' '
        'Note: Numerical results are approximations.'
        'Energy signals have zero theoretical average power.'
        };

    set(resultBox,'String',output);

end


% FUNCTION 2: Plot Selected Signal

function plotSignal(~,~)

    k = get(signalMenu,'Value');

    plot(ax,t,x{k},'LineWidth',1.5);
    title(ax,names{k});
    xlabel(ax,'Time');
    ylabel(ax,'Amplitude');
    grid(ax,'on');

end


% FUNCTION 3: Plot All 8 Signals

function plotAllSignals(~,~)

    figure('Name','All Eight Test Signals');

    for k = 1:8

        subplot(4,2,k);
        plot(t,x{k},'LineWidth',1.2);
        title(names{k});
        xlabel('Time');
        ylabel('Amplitude');
        grid on;

    end

end


% FUNCTION 4: Rectangular Pulse Animation

function pulseAnimation(~,~)

    A = 1;
    tau = [1 2 4 8 16 32 64 128 256];

    figure('Name','Rectangular Pulse Animation');

    t2 = -140:dt:140;

    for n = 1:length(tau)

        width = tau(n);

        pulse = A*(abs(t2) <= width/2);

        subplot(2,1,1);

        plot(t2,pulse,'LineWidth',1.5);

        title(['Rectangular Pulse, Tau = ',num2str(width)]);
        xlabel('Time');
        ylabel('Amplitude');
        axis([-140 140 -0.2 1.2]);
        grid on;

        subplot(2,1,2);

        plot(tau(1:n),A^2*tau(1:n),'o-','LineWidth',1.5);

        title('Energy Increases as Pulse Duration Increases');
        xlabel('Pulse Duration (Tau)');
        ylabel('Energy');
        grid on;

        drawnow;
        pause(0.4);

    end

end


% FUNCTION 5: Crossover Amplitude

function crossoverAmplitude(~,~)

    tau = [1 2 4 8 16 32 64 128 256];

    E0 = 1;

    Astar = sqrt(E0./tau);

    output = {
        'Fixed Reference Energy E0 = 1'
        'Amplitude A* = sqrt(E0/Tau)'
        ' '
        };

    for n = 1:length(tau)

        output{end+1} = ['Tau = ',num2str(tau(n)),...
            ', A* = ',num2str(Astar(n),'%.4f')];

    end

    set(resultBox,'String',output);

end


% FUNCTION 6: Viva Answer

function vivaAnswer(~,~)

    P = (3^2/2) + (4^2/2);

    output = {
        'VIVA QUESTION:'
        'x(t) = 3sin(2*pi*t) + 4cos(6*pi*t)'
        ' '
        'Average Power = A1^2/2 + A2^2/2'
        ' '
        'Power = 9/2 + 16/2'
        ['Answer = ',num2str(P)]
        };

    set(resultBox,'String',output);

end


% FUNCTION 7: Clear Output

function clearOutput(~,~)

    set(resultBox,'String','Output cleared.');

    cla(ax);

end

end
