clear all ;clc ;close all;
%% Designing a decimation filter.

Decimation_Factor=64;
Passband_Ripple=.006; %dB
Stopband_Attenuation=90; %dB
Fs=48e3;
Passband=21.6e3;  %dB
Stopband=26.4e3; %dB

Input_Sampling_Rate = Decimation_Factor*Fs;
%%
f=fdesign.decimator(Decimation_Factor,'lowpass',Passband,Stopband,...
    Passband_Ripple,Stopband_Attenuation,Input_Sampling_Rate);
%% Run ONCE and then Comment these lines.
% h=design(f);
% save one_stage h
%% Plain Visualization of the Filter
load('one_stage.mat')
fvtool(h,'Fs',Input_Sampling_Rate);
%% Further Design steps of the Filter
% 1. launch fdatool from CMD
% 2. Import Filter from the workspace (CTRL+I)
% 3. Click the Set Quantization Parameters button  in the left-side toolbar. 
% 4. Select Fixed-point from the Filter arithmetic list. Then select Specify all from the Filter precision list. 
% The Filter Designer displays the first of three tabbed panels of quantization parameters across the bottom half of the window.
% Coefficients	Numerator word length	16
%  	Best-precision fraction lengths	Selected
%  	Use unsigned representation	Cleared
%  	Scale the numerator coefficients to fully utilize the entire dynamic range	Cleared
% Input/Output	Input word length	16
%  	Input fraction length	15
%  	Output word length	16
% Filter Internals	Rounding mode	Floor
%  	Overflow mode	Saturate 	
% Accum. word length	40
% Run fdatool
% File> Open Session "fdatool-paramset.fda"
%% % fdatool-param-script();

Fs = 48000;  % Sampling Frequency

Fpass = 9600;            % Passband Frequency
Fstop = 12000;           % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
dens  = 16;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);
% Set the arithmetic property.
set(Hd, 'Arithmetic', 'fixed', ...
    'CoeffWordLength', 16, ...
    'CoeffAutoScale', true, ...
    'Signed',         true, ...
    'InputWordLength', 16, ...
    'inputFracLength', 15, ...
    'FilterInternals',  'SpecifyPrecision', ...
    'OutputWordLength',  16, ...
    'OutputFracLength',  31, ...
    'ProductWordLength', 31, ...
    'ProductFracLength', 31, ...
    'AccumWordLength',   40, ...
    'AccumFracLength',   31, ...
    'RoundMode',         'floor', ...
    'OverflowMode',      'Saturate');
%%
% File > Save Session As 
% File > Export to Simulink Model. 
% %% Select Targets > Generate HDL in the Filter Designer tool.
% Filter Architecture Tab : Leave Defaults
% Global Settings Tab:
%   General Sub-Tab  >> Comment in Header = "Basic FIR Design"
%   Ports Sub-Tab >> Input Port:  data_in 
%                    Output Port : data_out
%                    Deselect  Add Input Register
% Testbench Tab: 
%                Filename:  basic_filter_tb

%% % filter_generatehdl(h)

generatehdl(Hd, 'TargetLanguage', 'VHDL',... 
               'FIRAdderStyle', 'tree',... 
               'AddInputRegister', 'off',... 
               'InputPort', 'data_in',... 
               'OutputPort', 'data_out',... 
               'UserComment', 'Basic FIR Design',... 
               'TestBenchName', 'basic_filter_tb',... 
               'TestBenchStimulus',  {'impulse', 'step', 'ramp', 'chirp', 'noise'},... 
               'GenerateHDLTestbench', 'on');

