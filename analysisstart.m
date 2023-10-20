% purpose: create directories for each session for each rat, and apply oscillatory detection algorithms on each
% creates: 80h event duration, as well as IEI intervals using the envelope of the 80hz signal. Also finds number of cycles per 80hz event.


sig_name = 'gamma_80';

d_CON = dir('C:\Users\Winter\Documents\MATLAB\rat_data\control\*\*');
d_LID = dir('C:\Users\Winter\Documents\MATLAB\rat_data\LID\*\*');

% change input based on analysis needed.. 'LID', 'CON', or 'Both'
input= 'LID';
fsample= 500;
%initialize variables
[lfp_dir_control, lfp_dir_LID, sess_size_CON, sess_size_LID,totalCON, totalLID] = initialize_param(d_CON,d_LID);


% find best channel for each session and rat...output is savevd as
% channel_to_useCON/LID...do not re-run if you already have these
% variables, this script takes forever
[OUT_control, channel_to_useCON, OUT_LID, channel_to_useLID] = find_best_chan (sig_name,totalCON, totalLID,input);

% find 80hz duration and IEI interval duration
[onset75, offset75, baseonset75, baseoffset75] = dur_and_IEI(totalCON, totalLID, channel_to_useCON, channel_to_useLID, sess_size_CON, sess_size_LID, fsample)

% find number of cycles per 80hz event
find_cycle_num (totalCON, totalLID,lfp_dir_control,lfp_dir_LID, channel_to_useCON, channel_to_useLID, onset75, offset75, baseonset75, baseoffset75)