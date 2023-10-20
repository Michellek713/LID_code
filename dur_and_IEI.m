function dur_and_IEI(lfp_dir_control, lfp_dir_LID, channel_to_useCON,channel_to_useLID,sess_size_CON, sess_size_LID) %, channel_to_useLID)
%% CONTROL:
%%%%determine duration and IEI size for peak 80hz period and plot all sessions overlaying each other

duration_secCON={};
for i=1:size(lfp_dir_control,2)
 lfp=LK_Load_and_Clean_LFP(string(lfp_dir_control(1,i)),string(channel_to_useCON(1,i)))
    %lfp = LK_Load_and_Clean_LFP(lfp_dir,LFP_files);
   
   % fsample=lfp.LFP.sfreq;
    bplfp=bandpass(lfp.LFP,[75 90],fsample);

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

    %% find 80hz events above power threshold
    %calculate peak envelope power

    hil=abs(hilbert(peakperiod1));
    %figure
    %hold on
    %plot(peaktime,peakperiod1)
    %plot(peaktime,hil)
    %ylabel('voltage')
    %xlabel('time(min)')


    % set threshold (75th percentile), determine where data crosses threshold

    t75=prctile(hil,75);
    pass75=hil>t75;
    basepass75=hil_base>t75;

    % logistical configuration things for pass matrix
    if size(pass75,1)>1
        pass75=pass75';
    end

    if pass75(end) == 1
        newpass75=[pass75, 0];
        pass75=newpass75;
    end

    if pass75(1,1)== 1
        newpass75=[0,pass75];
        pass75=newpass75;
    end

    % repeat same thing for basepass matrix

    if size(basepass75,1)>1
        basepass75=basepass75';
    end

    if basepass75(end) == 1
        newpass75=[basepass75, 0];
        basepass75=newpass75;
    end

    if basepass75(1,1)== 1
        newpass75=[0,basepass75];
        basepass75=newpass75;
    end


    %figure
    %hold on
    %plot(peaktime,peakperiod1)
    %plot(peaktime,hil)
    %plot(peaktime,pass75)
    %yline(t75)


    % event onset and offset for envelope during peak period
    onset75=find(diff(pass75(:))==1);
    onset75=single(onset75);

    offset75=find(diff(pass75(:))==-1);
    offset75=single(offset75);

    % repeat for baseline onset and offset
    baseonset75=find(diff(basepass75(:))==1);
    baseonset75=single(baseonset75);

    baseoffset75=find(diff(basepass75(:))==-1);
    baseoffset75=single(baseoffset75);

    % plot event duration and IEI duration

    duration_secCON{i}=(offset75-onset75)/500;
    IEI_secCON{i}=(onset75(2:end)-offset75(1:end-1))/500;

    base_duration_secCON{i}=(baseoffset75-baseonset75)/500;
    base_IEI_secCON{i}=(baseonset75(2:end)-baseoffset75(1:end-1))/500;

end

% separate by rat




% histcounts to control for bin size, and use lines instead of the
% histogram function...use Probability density function instead of counts
% and add constraints to the x-axis
% too

% figure
% for i=1:size(durationsec,2)
%
% hold on
% histogram(durationsec{1,i},30)
% xlabel 'duration (sec)'
% ylabel 'count'
% title 'Event duration in seconds'
% end

figure
subplot(2,1,1)
N={};
edges1={};

edges=0:.01:.3;
edges1=edges(2:end);
for i=1:size(duration_secCON,2)
    hold on
    [N1]=histcounts(duration_secCON{1,i},edges);
   plot(edges1,N1)
    ylabel 'Count'
    xlabel 'Duration (sec)'
    title 'CONTROL: 80hz event duration during peak 80hz activity'
end

mean_duration_secCON=[];
for i=1:size(duration_secCON,2)
    mean_duration_secCON(i)=mean(duration_secCON{1,i})
    % IEI_sec{i}=IEI_sec{i}(IEI_sec{i}<=5);
    % hold on
    % histogram(IEI_sec{1,i},30)
    % xlabel 'IEI (sec)'
    % xlim ([0,2])
    % ylabel 'count'
    % title 'Inter event interval in seconds'
    % end
end

mean_duration_secCON=[];
for i=1:size(duration_secCON,2)
   for j=1:size(sess_size_CON,2)
    mean_duration_secCON(i,sess_size_CON(1,j))=mean(duration_secCON{1,sess_size_CON(1,j)})
end
end


subplot(2,1,2)
hold on
plot(mean_duration_secCON)
% plot(mean_duration_secCON(1:26));
%  plot(mean_duration_secCON(26:26+8));
%   plot(mean_duration_secCON(26+8+12:26));
%    plot(mean_duration_secCON(1:26));
%     plot(mean_duration_secCON(1:26));
xlabel 'Session'
ylabel 'Duration (sec)'
title 'CONTROL: Mean 80hz event duration during peak 80hz activity'


figure
subplot(2,1,1)
edges1={};
edges=0:.01:.3;
edges1=edges(2:end);
for i=1:size(IEI_secCON,2)
    hold on
    [N]=histcounts(IEI_secCON{1,i},edges);
    plot(edges1,N)
    ylabel 'Count'
    xlabel 'Duration (sec)'
    title 'CONTROL: 80hz IEI duration during peak 80hz activity'
end

for i=1:size(IEI_secCON,2)
    mean_IEI_secCON(i)=mean(IEI_secCON{1,i})
    % IEI_sec{i}=IEI_sec{i}(IEI_sec{i}<=5);
    % hold on
    % histogram(IEI_sec{1,i},30)
    % xlabel 'IEI (sec)'
    % xlim ([0,2])
    % ylabel 'count'
    % title 'Inter event interval in seconds'
    % end
end
subplot(2,1,2)
plot(mean_IEI_secCON);
xlabel 'Session'
ylabel 'Duration (sec)'
title 'CONTROL: Mean 80hz IEI duration during peak 80hz activity'

%%%%determine duration and IEI size for baseline

figure
subplot(2,1,1)
N={};
edges1={};
edges=0:.01:.3;
edges1=edges(2:end);
for i=1:size(base_duration_secCON,2)
    hold on
    [N]=histcounts(base_duration_secCON{1,i}, edges);
    plot(edges1,N)
    ylabel 'Count'
    xlabel 'Duration (sec)'
    title 'CONTROL: 80hz event duration during baseline'
end

for i=1:size(base_duration_secCON,2)
    base_mean_duration_secCON(i)=mean(base_duration_secCON{1,i})
    % IEI_sec{i}=IEI_sec{i}(IEI_sec{i}<=5);
    % hold on
    % histogram(IEI_sec{1,i},30)
    % xlabel 'IEI (sec)'
    % xlim ([0,2])
    % ylabel 'count'
    % title 'Inter event interval in seconds'
    % end
end
subplot(2,1,2)
hold on
plot(base_mean_duration_secCON);
xlabel 'Session'
ylabel 'Duration (sec)'
title 'CONTROL: Mean 80hz event duration during baseline'




figure
subplot(2,1,1)
edges1={};
edges=0:.01:.3;
edges1=edges(2:end);
for i=1:size(base_IEI_secCON,2)
    hold on
    [N]=histcounts(base_IEI_secCON{1,i}, edges);
    plot(edges1,N)
    ylabel 'Count'
    xlabel 'Duration (sec)'
    title 'CONTROL: 80hz IEI duration during baseline'
end

for i=1:size(base_IEI_secCON,2)
    base_mean_IEI_secCON(i)=mean(base_IEI_secCON{1,i})
    % IEI_sec{i}=IEI_sec{i}(IEI_sec{i}<=5);
    % hold on
    % histogram(IEI_sec{1,i},30)
    % xlabel 'IEI (sec)'
    % xlim ([0,2])
    % ylabel 'count'
    % title 'Inter event interval in seconds'
    % end
end
subplot(2,1,2)
hold on
plot(base_mean_IEI_secCON);
xlabel 'Session'
ylabel 'Duration (sec)'
title 'CONTROL: Mean 80hz IEI duration during baseline'



%% LID: determine duration and IEI size for peak 80hz period and plot all sessions overlaying each other
base_duration_secLID={};
for i=1:size(lfp_dir_LID,2)

    lfp=LK_Load_and_Clean_LFP(string(lfp_dir_LID(1,i)),string(channel_to_useLID(1,i)))

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

    %% find 80hz events above power threshold
    %calculate peak envelope power

    hil=abs(hilbert(peakperiod1));
    %figure
    %hold on
    %plot(peaktime,peakperiod1)
    %plot(peaktime,hil)
    %ylabel('voltage')
    %xlabel('time(min)')


    % set threshold (75th percentile), determine where data crosses threshold

    t75=prctile(hil,75);
    pass75=hil>t75;
    basepass75=baseperiod>t75;

    if size(pass75,1)>1
        pass75=pass75';
    end

    if pass75(end) == 1
        newpass75=[pass75, 0];
        pass75=newpass75;
    end

    if pass75(1,1)== 1
        newpass75=[0,pass75];
        pass75=newpass75;
    end


    % repeat same thing for basepass matrix

    if size(basepass75,1)>1
        basepass75=basepass75';
    end

    if basepass75(end) == 1
        newpass75=[basepass75, 0];
        basepass75=newpass75;
    end

    if basepass75(1,1)== 1
        newpass75=[0,basepass75];
        basepass75=newpass75;
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

    % repeat for baseline onset and offset
    baseonset75=find(diff(basepass75(:))==1);
    baseonset75=single(baseonset75);

    baseoffset75=find(diff(basepass75(:))==-1);
    baseoffset75=single(baseoffset75);

    % plot event duration and IEI duration

    duration_secLID{i}=(abs(onset75-offset75))/500;
    IEI_secLID{i}=(onset75(2:end)-offset75(1:end-1))/500;

    base_duration_secLID{i}=(abs(baseonset75-baseoffset75))/500;
    base_IEI_secLID{i}=(baseonset75(2:end)-baseoffset75(1:end-1))/500;

end

% histcounts to control for bin size, and use lines instead of the
% histogram function...use Probability density function instead of counts
% and add constraints to the x-axis
% too

% figure
% for i=1:size(durationsec,2)
%
% hold on
% histogram(durationsec{1,i},30)
% xlabel 'duration (sec)'
% ylabel 'count'
% title 'Event duration in seconds'
% end

figure
subplot(2,1,1)
N={};
edges1={};
edges=0:.01:.3;
edges1=edges(2:end);
for i=1:size(duration_secLID,2)
    hold on
    [N]=histcounts(duration_secLID{1,i},edges);
    plot(edges1,N)
    ylabel 'Count'
    xlabel 'Duration (sec)'
    title 'LID: 80hz event duration during peak 80hz activity'
end

for i=1:size(duration_secLID,2)
    mean_duration_secLID(i)=mean(duration_secLID{1,i})
    % IEI_sec{i}=IEI_sec{i}(IEI_sec{i}<=5);
    % hold on
    % histogram(IEI_sec{1,i},30)
    % xlabel 'IEI (sec)'
    % xlim ([0,2])
    % ylabel 'count'
    % title 'Inter event interval in seconds'
    % end
end
subplot(2,1,2)
plot(mean_duration_secLID)
xlabel 'Session'
ylabel 'Duration (sec)'
title 'LID: Mean 80hz event duration during peak 80hz activity'


figure
subplot(2,1,1)
N={};
edges1={};
edges=0:.01:.3;
edges1=edges(2:end);
for i=1:size(IEI_secLID,2)
    hold on
    [N]=histcounts(IEI_secLID{1,i},edges);
    plot(edges1,N)
    ylabel 'Count'
    xlabel 'Duration (sec)'
    title 'LID: 80hz IEI duration during peak 80hz activity'
end

for i=1:size(IEI_secLID,2)
    mean_IEI_secLID(i)=mean(IEI_secLID{1,i})
    % IEI_sec{i}=IEI_sec{i}(IEI_sec{i}<=5);
    % hold on
    % histogram(IEI_sec{1,i},30)
    % xlabel 'IEI (sec)'
    % xlim ([0,2])
    % ylabel 'count'
    % title 'Inter event interval in seconds'
    % end
end

subplot(2,1,2)
plot(mean_IEI_secLID)
xlabel 'Session'
ylabel 'Duration (sec)'
title 'LID: Mean 80hz IEI duration during peak 80hz activity'

%%%%determine duration and IEI size for baseline

figure
subplot(2,1,1)
N={};
edges1={};
edges=0:.01:.3;
edges1=edges(2:end);
for i=1:size(base_duration_secLID,2)
    hold on
    [N]=histcounts(base_duration_secLID{1,i}, edges);
    plot(edges1,N)
    ylabel 'Count'
    xlabel 'Duration (sec)'
    title 'LID: 80hz event duration during baseline'
end

for i=1:size(base_duration_secLID,2)
    base_mean_duration_secLID(i)=mean(base_duration_secLID{1,i})
    % IEI_sec{i}=IEI_sec{i}(IEI_sec{i}<=5);
    % hold on
    % histogram(IEI_sec{1,i},30)
    % xlabel 'IEI (sec)'
    % xlim ([0,2])
    % ylabel 'count'
    % title 'Inter event interval in seconds'
    % end
end
subplot(2,1,2)
plot(base_mean_duration_secLID);
xlabel 'Session'
ylabel 'Duration (sec)'
title 'LID: Mean 80hz event duration during baseline'




figure
subplot(2,1,1)
N={};
edges1={};
edges=0:.01:.3;
edges1=edges(2:end);
for i=1:size(base_IEI_secLID,2)
    hold on
    [N]=histcounts(base_IEI_secLID{1,i},edges);
    plot(edges1,N)
    ylabel 'Count'
    xlabel 'Duration (sec)'
    title 'LID: 80hz IEI duration during baseline'
end

for i=1:size(base_IEI_secLID,2)
    base_mean_IEI_secLID(i)=mean(base_IEI_secLID{1,i})
    % IEI_sec{i}=IEI_sec{i}(IEI_sec{i}<=5);
    % hold on
    % histogram(IEI_sec{1,i},30)
    % xlabel 'IEI (sec)'
    % xlim ([0,2])
    % ylabel 'count'
    % title 'Inter event interval in seconds'
    % end
end
subplot(2,1,2)
hold on
plot(base_mean_IEI_secLID);
xlabel 'Session'
ylabel 'Duration (sec)'
title 'LID: Mean 80hz IEI duration during baseline'
