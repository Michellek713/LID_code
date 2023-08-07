function boscstreamlined(lfp_dir,fnames)
%% essential question this script is trying to answer: is this 80hz signal oscilitory? 
%% load data in directory
lfp=LK_Load_and_Clean_LFP(lfp_dir,fnames)
%lfp = LK_Load_and_Clean_LFP(lfp_dir,LFP_files);
bplfp=bandpass(lfp.LFP,[75 90],500);

data.time=linspace(0,length(lfp.LFP)/500,length(lfp.LFP));
timemin=data.time/60;

baseperiod=bplfp(1:1350000);
peakperiod1=bplfp(2400000:end);
peaktime=timemin(2400000:end);

peakperiod_raw=lfp.LFP(2400000:end);
baseperiod_raw=lfp.LFP(1:1350000);
%% find 80hz events above power threshold
%calculate peak envelope power
hil=abs(hilbert(peakperiod1));
hil_base=abs(hilbert(baseperiod));
%figure
%hold on
%plot(peaktime,peakperiod1)
%plot(peaktime,hil)
%ylabel('voltage')
%xlabel('time(min)')


data.time=linspace(0,length(lfp.LFP)/500,length(lfp.LFP));
timemin=data.time/60;




%% find 80hz events above power threshold
%calculate peak envelope power

hil=abs(hilbert(peakperiod1));
%figure
%hold on
%plot(peaktime,peakperiod1)
%plot(peaktime,hil)
%ylabel('voltage')
%xlabel('time(min)')

% autocorr of envelope and total signal
%%% figure out the pearson correlation and the lags of the signal
acoren=xcorr(hil,hil,1000);

figure
plot(timemin(1:size((acoren),1)),acoren)
title 'autocorr of envelope during peak period'

acor=xcorr(lfp.LFP,lfp.LFP,500);
title 'autocorr of total raw data'

figure
plot(timemin(1:size((acor),1)),acor)

% set threshold (75th percentile), determine where data crosses threshold

t75=prctile(hil,75);
pass75=hil>t75;

if pass75(end) == 1
  newpass75=[pass75', 0];
  pass75=newpass75;
end
    
if pass75(1,1)== 1
 newpass75=[0,pass75]; 
 pass75=newpass75;
end
 
%figure
%hold on
%plot(peaktime,peakperiod1)
%plot(peaktime,hil)
%plot(peaktime,pass75)
%yline(t75)


% event onset and offset for envelope
onset75=find(diff(pass75(:))==1);
onset75=single(onset75);

offset75=find(diff(pass75(:))==-1);
offset75=single(offset75);






onsettime75=onset75./500;
onsettime75=single(onsettime75);

offsettime75=offset75./500;
offsettime75=single(offsettime75);

% plot event duration and IEI duration
durationsec=(abs(onset75-offset75))/500;

figure
hist(durationsec,30)
xlabel 'duration (sec)'
ylabel 'count'
title 'Event duration in seconds'

IEI_sec=(onset75(2:end)-offset75(1:end-1))/500;

figure
hist(IEI_sec,30)
xlabel 'IEI (sec)'
ylabel 'count'
title 'Inter event interval in seconds'

figure
plot(onsettime75,durationsec)
xlabel 'Time (Seconds)'
ylabel 'Event duration (Seconds)'
title 'Event durations across time during peak 80hz period'

%% determine number of oscillations per event
% what portion of peak period data passes threshold
passosc75=peakperiod1>t75;

if passosc75(end) == 1
  newpass75=[passosc75', 0];
  passosc75=newpass75;
elseif passosc75(1)== 1
  newpass75=[0,passosc75']; 
  passosc75=newpass75;
end
    

%figure
%hold on
%plot(peaktime,peakperiod1)
%plot(peaktime,peakperiod1)
%yline(t75)
%yyaxis right
%plot(peaktime,passosc75)

% find on and off data points for peak period data
oscon75=find(diff(passosc75(:))==1);
oscon75=single(oscon75);
oscoff75=find(diff(passosc75(:))==-1);
oscoff75=single(oscoff75);



% concatenate on and off times for envelope and peak data into one matrix
onandofftimes75=cat(2,onset75,offset75);
osconandoff75=cat(2,oscon75,oscoff75);

% create a cell array of oscillation values located between the envelope
% values
M75={};
for i=1:length(onandofftimes75)
M75{i} = osconandoff75((osconandoff75 >= onandofftimes75(i,1)) & (osconandoff75 <= onandofftimes75(i,2)));
end

% count array size to determine number of cycles per envelope event
num_of_osc75={}
for i=1:size(M75,2)
   num_of_osc75{i}=length(M75{1,i});
end

num_of_osc75=[num_of_osc75{:}];

num_of_osc75=num_of_osc75(num_of_osc75>0);
num_of_osc75=num_of_osc75/2;

figure
hist(num_of_osc75,20)
xlabel 'number of cylces'
ylabel 'count'
title 'number of cycles per event during peak 80hz activity'
%% visualize number of events across each threshold across time
baseperiod=bplfp(1:1350000);

base=prctile(baseperiod,75);
basepass75=baseperiod>t75;

if basepass75(end) == 1
  newpass75=[basepass75', 0];
  basepass75=newpass75;
elseif basepass75(1)== 1
  newpass75=[0,basepass75']; 
  basepass75=newpass75;
end
    
basepassosc75=baseperiod>t75;

if basepassosc75(end) == 1
  newpass75=[basepass75osc', 0];
  basepassosc75=newpass75;
elseif basepassosc75(1)== 1
  newpass75=[0,basepassosc75']; 
  basepassosc75=newpass75;
end
    

baseonset75=find(diff(basepass75(:))==1);
baseonset75=single(baseonset75);
baseoffset75=find(diff(basepass75(:))==-1);
baseoffset75=single(baseoffset75);


baseoscon75=find(diff(basepassosc75(:))==1);
baseoscon75=single(baseoscon75);
baseoscoff75=find(diff(basepassosc75(:))==-1);
baseoscoff75=single(baseoscoff75);

baseoscon75time=baseoscon75./500;

baseonandofftimes75=cat(2,baseonset75,baseoffset75);

baseosconandoff75=cat(2,baseoscon75,baseoscoff75);


base75={};
for i=1:length(baseonandofftimes75)
base75{i} = baseosconandoff75((baseosconandoff75 >= baseonandofftimes75(i,1)) & (baseosconandoff75 <= baseonandofftimes75(i,2)));
end

% count array size to determine number of oscillations per envelope event
num_of_osc_base={}
for i=1:size(base75,2)
   num_of_osc_base{i}=length(base75{1,i});
end

num_of_osc_base=[num_of_osc_base{:}];

num_of_osc_base=num_of_osc_base(num_of_osc_base>0);
num_of_osc_base=num_of_osc_base/2;


figure
hist(num_of_osc_base,20)
xlabel 'number of cycles'
ylabel 'count'
title 'number of cycles per event during baseline'

baseonset75=find(diff(basepass75(:))==1);
baseonset75=single(baseonset75);
baseoffset75=find(diff(basepass75(:))==-1);
baseoffset75=single(baseoffset75);


baseonset75time=baseonset75./500;

% plot event duration and IEI duration
basedurationsec=(abs(baseonset75-baseoffset75))/500;

figure
hist(basedurationsec,30)
xlabel 'duration (sec)'
ylabel 'count'
title 'event duration during baseline'

baseIEI_sec=(baseonset75(2:end)-baseoffset75(1:end-1))/500;

figure
hist(baseIEI_sec,30)
xlabel 'IEI (sec)'
ylabel 'count'
title 'inter event interval duration during baseline'



figure
plot(baseIEI_sec)
xlabel 'Time (Seconds)'
ylabel 'Event duration (Seconds)'
title 'IEI durations across time during peak 80hz period'

%% random spectrogram of bandpass @ 75th percentile
%pass75=zscore(pass75);

%s=spectrogram(pass75,500,500/2,1:.2:100,500);
%s= 10*log10(abs(s))';
%figure
%imagesc(timemin,5:1:100,s')
%axis xy
%xlabel 'Time minutes'
%ylabel 'Frequency Hz'
%colorbar
%caxis(prctile(s(:),[1 99]))

%passosc75=double(passosc75);
%figure
%pwelch(passosc75,500,500/2,.1:.2:190,500);

%hil=double(hil);
%figure
%pwelch(hil,500,500/2,.1:.2:190,500);

%% test out number of oscillations at different thresholds
% create matrix with threshold values
%threshold_values=(50:1:90);
%pass={};
%passosc={};

% calculate percentile values at each threshold
%t=[];
%for i=1:length(threshold_values)
%t(i)=prctile(hil,threshold_values(i));
%end

% determine portion of data that passes each threshold for envelope and
% peak data
%for i=1:length(t)
%pass{i}=hil>t(i);
%passosc{i}=peakperiod1>t(i);
%end

%onset={};
%offset={};
%onandofftimes={};

% calculate onset and offset matrix for envelope

%for i=1:size(pass,2)
%onset{i}=find(diff(pass{1,i})==1);
%offset{i}=find(diff(pass{1,i})==-1);
%onandofftimes{i}=cat(2,onset{1,i},offset{1,i});
%end

% calculate onset and offset matrix for peakperiod
%oscon={};
%oscoff={};
%osconandoff={};
%for i=1:length(passosc)
%oscon{i}=find(diff(passosc{1,i})==1);
%oscoff{i}=find(diff(passosc{1,i})==-1);
%osconandoff{i}=cat(2,oscon{1,i},oscoff{1,i});
%end


%
%M1={};
%for j=1:length(onandofftimes)
  
   % for i=1:length(onandofftimes{1,j})
   % M1{j,i} = osconandoff{j}((osconandoff{j} >= onandofftimes{j}(i,1)) & (osconandoff{j} <= onandofftimes{j}(i,2)));
   % end
%end


%num_of_osc={}   

%for i=1:41
  %  for j=1:size(M1,2)
  % num_of_osc{j,i}=size(M1{i,j},1);
  %  end
%end

%for i=1:41
 %   for j=1:length(num_of_osc)
 %       num_of_osc{j,i}(num_of_osc{j,i}==0) = NaN;
%num_of_osc{j,i}=num_of_osc{j,i}./2;
 %   end
%end

%M = [];
%for i=1:41
%n=cell2mat(num_of_osc(:,i));
%edges=[0.5 1.5 2.5 3.5 4.5 5.5 6.5];
%M(i,:)=histcounts(n,edges);
%end
%figure
%imagesc(M)

%Mn = M./sum(M,2);
%figure
%imagesc(Mn)
%% Implement duration threshold at the 75th percentile
% duration threshold at 3 for now...show stephen bar plot when he returns
% and get his opinion on choosing a threshold

%num_of_osc75(num_of_osc75<3)=nan;
%num_of_oscpass=num_of_osc75>=3;

%num_of_oscpass=double(num_of_oscpass);

%s=spectrogram(num_of_osc75,500,500/2,1:.2:100,500);
%s= 10*log10(abs(s))';
%figure
%imagesc(timemin,5:1:100,s')
%axis xy
%xlabel 'Time minutes'
%ylabel 'Frequency Hz'
%colorbar
%caxis(prctile(s(:),[1 99]))

%% compute event triggered average
% use find peaks command to look at peaks above threshold on envelope, and do an
% average of those peaks +or- 500 points
% autocorr of the pks

%%% eta of envelope of bp filtered data during peak 80hz
[pks_env,locs_env]=findpeaks(hil);

idx_env= find(locs_env > 500);

window_begin_env=locs_env(idx_env(1,1):(end-500))-500;
window_end_env=locs_env(idx_env(1,1):(end-500))+500;
time_array= (-500:1:500)/500*1000;

eta_array_env={};

for i=1:size(window_begin_env,1)
eta_array_env{i}=hil(window_begin_env(i):window_end_env(i),1);
end                                                                                                                                                     
eta_array_env=cell2mat(eta_array_env);

% calculate eta
my_eta_env=(sum(eta_array_env,2))./(size(eta_array_env,1));

figure
plot(time_array,my_eta_env) 
xlabel('Time (ms)')
ylabel ('Amplitude')
title('ETA of the envelope of 80hz bpf signal during peak 80hz period')

%%% eta of bp filtered data during baseline of envelope 
[pks_base_env,locs_base_env]=findpeaks(hil_base);

idx_base_env= find(locs_base_env > 500);

window_begin_base_env=locs_base_env(idx_base_env(1,1):(end-500))-500;
window_end_base_env=locs_base_env(idx_base_env(1,1):(end-500))+500;

eta_array_base_env={};

for i=1:size(window_begin_base_env,1)
eta_array_base_env{i}=hil_base(window_begin_base_env(i):window_end_base_env(i),1);
end                                                                                                                                                     
eta_array_base_env=cell2mat(eta_array_base_env);

% calculate eta
my_eta_base_env=(sum(eta_array_base_env,2))./(size(eta_array_base_env,1));

figure
plot(time_array,my_eta_base_env) 
xlabel('Time (ms)')
ylabel ('Amplitude')
title('ETA of the envelope of 80hz bpf signal during baseline')

%%% eta of total bp signal during peak 80hz period
[pks_tot_bp,locs_tot_bp]=findpeaks(peakperiod1);

idx_tot_bp= find(locs_tot_bp> 500);

window_begin_tot_bp=locs_tot_bp(idx_tot_bp(1,1):(end-500))-500;
window_end_tot_bp=locs_tot_bp(idx_tot_bp(1,1):(end-500))+500;

eta_array_tot_bp={};

for i=1:size(window_begin_tot_bp,1)
eta_array_tot_bp{i}=peakperiod1(window_begin_tot_bp(i):window_end_tot_bp(i),1);
end                                                                                                                                                     
eta_array_tot_bp=cell2mat(eta_array_tot_bp);

% calculate eta
my_eta_tot_bp=(sum(eta_array_tot_bp,2))./(size(eta_array_tot_bp,1));

figure
plot(time_array,my_eta_tot_bp) 
xlabel('Time (ms)')
ylabel ('Amplitude')
title('ETA of bp filtered signal during 80hz peak period')


%%% eta of total bp signal during baseline
[pks_tot_base,locs_tot_base]=findpeaks(baseperiod);

idx_tot_base= find(locs_tot_base> 500);

window_begin_tot_base=locs_tot_base(idx_tot_base(1,1):(end-500))-500;
window_end_tot_base=locs_tot_base(idx_tot_base(1,1):(end-500))+500;

eta_array_tot_base={};

for i=1:size(window_begin_tot_base,1)
eta_array_tot_base{i}=baseperiod(window_begin_tot_base(i):window_end_tot_base(i),1);
end                                                                                                                                                     
eta_array_tot_base=cell2mat(eta_array_tot_base);

% calculate eta
my_eta_tot_base=(sum(eta_array_tot_base,2))./(size(eta_array_tot_base,1));

figure
plot(time_array,my_eta_tot_base) 
xlabel('Time (ms)')
ylabel ('Amplitude')
title('ETA of BP filtered signal during baseline period')

%%% eta of total raw data during peak 80hz
[pks_raw,locs_raw]=findpeaks(peakperiod_raw);

idx_raw= find(locs_raw > 500);

window_begin_raw=locs_raw(idx_raw(1,1):(end-500))-500;
window_end_raw=locs_raw(idx_raw(1,1):(end-500))+500;


%%% eta of total raw data during peak 80hz
[pks_raw_base,locs_raw_base]=findpeaks(baseperiod_raw);

idx_raw_base= find(locs_raw_base > 500);

window_begin_raw_base=locs_raw_base(idx_raw_base(1,1):(end-500))-500;
window_end_raw_base=locs_raw_base(idx_raw_base(1,1):(end-500))+500;

eta_array_raw_base={};

for i=1:size(window_begin_raw_base,1)
eta_array_raw_base{i}=baseperiod_raw(window_begin_raw_base(i):window_end_raw_base(i),1);
end                                                                                                                                                     
eta_array_raw_base=cell2mat(eta_array_raw_base);

% calculate eta
my_eta_raw_base=(sum(eta_array_raw_base,2))./(size(eta_array_raw_base,1));

hold on
plot(time_array,my_eta_raw_base) 
xlabel('Time (ms)')
ylabel ('Amplitude')
title('ETA of raw signal during baseline period')


%% autocorrelations of raw, bpfiltered, envelope

% autocorr of total envelope peak period
[acoren,lags]=xcorr(hil,hil,1000);

figure
plot(lags/500,acoren)
xlabel('Seconds')
title 'autocorr of total envelope peak period'

% autocor of total signal
[acor,lagstot]=xcorr(lfp.LFP,lfp.LFP,500);
figure
plot(lagstot/500,acor)
xlabel('Seconds')
title 'autocorr of total signal'

% autocorr of envelope during peak 80hz
[acoren,lags]=xcorr(peakperiod1,peakperiod1,1000);

figure
plot(lags/500,acoren)
xlabel('Seconds')
title 'autocorr of envelope during peak 80hz'

% autocorr of envelope during baseline
[acoren,lags]=xcorr(baseperiod,baseperiod,1000);

figure
plot(lags/500,acoren)
xlabel('Seconds')
title 'autocorr of envelope during baseline'

% autocorr of bpfiltered data during 80hz
[acoren,lags]=xcorr(hil,hil,1000);

figure
plot(lags/500,acoren)
xlabel('Seconds')
title 'autocorr of bpfiltered data during peak 80hz'

% autocorr of bpfiltered data during baseline
[acoren,lags]=xcorr(hil,hil,1000);

figure
plot(lags/500,acoren)
xlabel('Seconds')
title 'autocorr of bpfiltered data during peak 80hz'


% autocorr of total peak period
[acoren,lags]=xcorr(hil,hil,1000);

figure
plot(lags/500,acoren)
xlabel('Seconds')
title 'autocorr of total peak period'

% autocorr of total baseline
[acoren,lags]=xcorr(hil,hil,1000);

hold on
plot(lags/500,acoren)
xlabel('Seconds')
title 'autocorr of total baseline'

outputfilename='output';
MysaveAll(lfp_dir, outputfilename);
close all


MysaveAll(lfp_dir,1)

close all
end
