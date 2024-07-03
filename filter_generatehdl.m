function filter_generatehdl(filtobj)
%  -------------------------------------------------------------
%  HDL Code Generation Options:
%  TargetLanguage: VHDL
%  FIRAdderStyle: tree
%  AddInputRegister: off
%  InputPort: data_in
%  OutputPort: data_out
%  UserComment: Basic FIR Design
%  TestBenchName: basic_filter_tb
%  TestBenchStimulus: impulse step ramp chirp noise 
%  GenerateHDLTestbench: on
% 
%  Filter Settings:
%  Discrete-Time FIR Filter (real)
%  -------------------------------
%  Filter Structure  : Direct-Form FIR
%  Filter Length     : 51
%  Stable            : Yes
%  Linear Phase      : Yes (Type 1)
%  Arithmetic        : fixed
%  Numerator         : s16,16 -> [-5.000000e-01 5.000000e-01)
%  Input             : s16,15 -> [-1 1)
%  Filter Internals  : Specify Precision
%    Output          : s16,31 -> [-1.525879e-05 1.525879e-05)
%    Product         : s31,31 -> [-5.000000e-01 5.000000e-01)
%    Accumulator     : s40,31 -> [-256 256)
%    Round Mode      : floor
%    Overflow Mode   : saturate

%  -------------------------------------------------------------

% Generating HDL code
generatehdl(filtobj, 'TargetLanguage', 'VHDL',... 
               'FIRAdderStyle', 'tree',... 
               'AddInputRegister', 'off',... 
               'InputPort', 'data_in',... 
               'OutputPort', 'data_out',... 
               'UserComment', 'Basic FIR Design',... 
               'TestBenchName', 'basic_filter_tb',... 
               'TestBenchStimulus',  {'impulse', 'step', 'ramp', 'chirp', 'noise'},... 
               'GenerateHDLTestbench', 'on');

% [EOF]
