function find_cycle_num (lfp_dir_control,lfp_dir_LID, channel_to_useCON, channel_to_useLID)
%% CONTROL: determine number of oscillations per event during peak 80hz period and overlay all sessions over each other
% what portion of peak period data passes threshold
num_of_osc75CON={};
M75CON={};
base_M75CON={};
num_of_oscCON={};
for i=1:size(lfp_dir_control,2)
    lfp=LK_Load_and_Clean_LFP(string(lfp_dir_control(1,i)),string(channel_to_useCON(1,i)));
    bplfp=bandpass(lfp.LFP,[75 90],500);
    peakperiod1=bplfp(2400000:end);
    baseperiod=bplfp(1:1350000);
    passosc75=peakperiod1>t75;
    basepassosc75=baseperiod>t75;

    % logistical formatting stuffs of the pass matrix
    if size(passosc75,1)>1
        passosc75=passosc75';
    end

    if passosc75(end) == 1
        newpass75=[passosc75, 0];
        passosc75=newpass75;
    else passosc75(1)== 1
        newpass75=[0,passosc75];
        passosc75=newpass75;
    end

    % repeat the same thing for the basepass matrix
    if size(basepassosc75,1)>1
        basepassosc75=basepassosc75';
    end

    if basepassosc75(end) == 1
        newpass75=[basepassosc75, 0];
        basepassosc75=newpass75;
    elseif basepassosc75(1)== 1
        newpass75=[0,basepassosc75];
        basepassosc75=newpass75;
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

    % find on and off data points for baseline period data
    baseoscon75=find(diff(basepassosc75(:))==1);
    baseoscon75=single(baseoscon75);
    baseoscoff75=find(diff(basepassosc75(:))==-1);
    baseoscoff75=single(baseoscoff75);


    % concatenate on and off times for envelope and peak data into one matrix
    onandofftimes75=cat(2,onset75,offset75);
    osconandoff75=cat(2,oscon75,oscoff75);

    % concatenate on and off times for envelope and baseline data into one matrix
    baseonandofftimes75=cat(2,baseonset75,baseoffset75);
    baseosconandoff75=cat(2,baseoscon75,baseoscoff75);

    % create a cell array of oscillation values located between the envelope
    % values

    for j=1:length(onandofftimes75)
        M75CON{j} = osconandoff75((osconandoff75 >= onandofftimes75(j,1)) & (osconandoff75 <= onandofftimes75(j,2)));
    end

    for j=1:length(baseonandofftimes75)
        base_M75CON{j} = baseosconandoff75((baseosconandoff75 >= baseonandofftimes75(j,1)) & (baseosconandoff75 <= baseonandofftimes75(j,2)));
    end

    % count array size to determine number of cycles per envelope event

    for j=1:size(M75CON,2)
        num_of_osc75CON{j}=length(M75CON{j});
    end

    for j=1:size(base_M75CON,2)
        base_num_of_osc75CON{j}=length(base_M75CON{j});
    end

    num_of_oscCON=[num_of_osc75CON{:}];
    num_of_oscCON=num_of_oscCON(num_of_oscCON>0);
    num_of_osc_newCON{i}=num_of_oscCON/2;


    base_num_of_oscCON=[base_num_of_osc75CON{:}];
    base_num_of_oscCON=base_num_of_oscCON(base_num_of_oscCON>0);
    base_num_of_osc_newCON{i}=base_num_of_oscCON/2;

end

figure
subplot(2,1,1)
for i=1:size(num_of_osc_newCON,2)
    hold on
    [N,edges]=histcounts(num_of_osc_newCON{1,i}),
    %histogram(num_of_osc_newCON{i},20)
    xlabel 'number of cylces'
    ylabel 'count'
    title 'number of cycles per event during peak 80hz activity'
end
subplot(2,1,2)
for i=1:size(base_num_of_osc_newCON,2)
    hold on
    [N,edges]=histcounts(base_num_of_osc_newCON{1,i}),
    %histogram(base_num_of_osc_newCON{i},20)
    xlabel 'number of cylces'
    ylabel 'count'
    title 'number of cycles per event during baseline'
end

%% LID: determine number of cycles per event during peak 80hz period and overlay all sessions over each other
% what portion of peak period data passes threshold
num_of_osc75LID={};
M75LID={};
base_M75LID={};
num_of_oscLID={};
for i=1:size(lfp_dir_LID,2)
    lfp=LK_Load_and_Clean_LFP(string(lfp_dir_LID(1,i)),string(channel_to_useLID(1,i)));
    bplfp=bandpass(lfp.LFP,[75 90],500);
    peakperiod1=bplfp(2400000:end);
    passosc75=peakperiod1>t75;


    % logistical formatting stuffs of the pass matrix
    if size(passosc75,1)>1
        passosc75=passosc75';
    end

    if passosc75(end) == 1
        newpass75=[passosc75, 0];
        passosc75=newpass75;
    else passosc75(1)== 1
        newpass75=[0,passosc75];
        passosc75=newpass75;
    end

    % repeat the same thing for the basepass matrix
    if size(basepassosc75,1)>1
        basepassosc75=basepassosc75';
    end

    if basepassosc75(end) == 1
        newpass75=[basepassosc75, 0];
        basepassosc75=newpass75;
    elseif basepassosc75(1)== 1
        newpass75=[0,basepassosc75];
        basepassosc75=newpass75;
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

    % find on and off data points for baseline period data
    baseoscon75=find(diff(basepassosc75(:))==1);
    baseoscon75=single(baseoscon75);
    baseoscoff75=find(diff(basepassosc75(:))==-1);
    baseoscoff75=single(baseoscoff75);


    % concatenate on and off times for envelope and peak data into one matrix
    onandofftimes75=cat(2,onset75,offset75);
    osconandoff75=cat(2,oscon75,oscoff75);

    % concatenate on and off times for envelope and baseline data into one matrix
    baseonandofftimes75=cat(2,baseonset75,baseoffset75);
    baseosconandoff75=cat(2,baseoscon75,baseoscoff75);

    % create a cell array of oscillation values located between the envelope
    % values

    for j=1:length(onandofftimes75)
        M75LID{j} = osconandoff75((osconandoff75 >= onandofftimes75(j,1)) & (osconandoff75 <= onandofftimes75(j,2)));
    end

    for j=1:length(baseonandofftimes75)
        base_M75LID{j} = baseosconandoff75((baseosconandoff75 >= baseonandofftimes75(j,1)) & (baseosconandoff75 <= baseonandofftimes75(j,2)));
    end

    % count array size to determine number of cycles per envelope event

    for j=1:size(M75LID,2)
        num_of_osc75LID{j}=length(M75LID{j});
    end

    for j=1:size(base_M75LID,2)
        base_num_of_osc75LID{j}=length(base_M75LID{j});
    end

    num_of_oscLID=[num_of_osc75LID{:}];
    num_of_oscLID=num_of_oscLID(num_of_oscLID>0);
    num_of_osc_newLID{i}=num_of_oscLID/2;


    base_num_of_oscLID=[base_num_of_osc75LID{:}];
    base_num_of_oscLID=base_num_of_oscLID(base_num_of_oscLID>0);
    base_num_of_osc_newLID{i}=base_num_of_oscLID/2;

end

figure
subplot(2,1,1)
for i=1:size(num_of_osc_newLID,2)
    hold on
    [N,edges]=histcounts(num_of_osc_newLID{1,i},'normalization','pdf');
    edges=edges(2:end);
    plot(edges,N)
    %histogram(num_of_osc_newLID{i},20)
    xlabel 'number of cylces'
    ylabel 'count'
    title 'number of cycles per event during peak 80hz activity'
end
subplot(2,1,2)
for i=1:size(base_num_of_osc_newLID,2)
    hold on
    [N,edges]=histcounts(base_num_of_osc_newLID{1,i},'normalization','pdf'),
    edges=edges(2:end);
    plot(edges,N)
    %histogram(base_num_of_osc_newLID{i},20)
    xlabel 'number of cylces'
    ylabel 'count'
    title 'number of cycles per event during baseline'
end

