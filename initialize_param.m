function [lfp_dir_control, lfp_dir_LID, sess_size_CON, sess_size_LID,totalCON, totalLID]= initialize_param(d_CON,d_LID)
%% load data and create parameters...

% create directories for control animals
%%% remove all files (isdir property is 0)
dfolders_CON = d_CON([d_CON(:).isdir])
%%% remove '.' and '..'
dfolders_control = dfolders_CON(~ismember({dfolders_CON(:).name},{'.','..'}))

lfp_dir_control={};
for i=1:size(dfolders_control,1)
    lfp_dir_control{i}=dfolders_control(i).folder;
end

lfp_dir_control=unique(lfp_dir_control);

sess_size_CON=[];
for i=1:size(lfp_dir_control,2)
    sess_size_CON(i)=size(ls(string(lfp_dir_control(i))),1)-2;
end

dfolders_top_CON={};
for i=1:size(dfolders_control,1)
    dfolders_top_CON{i}=dfolders_control(i).folder;
end
dfolders_top_CON=unique(dfolders_top_CON);


% create directories for LID animals

%%% remove all files (isdir property is 0)
dfolders_LID = d_LID([d_LID(:).isdir])
%%% remove '.' and '..'
dfolders_LID = dfolders_LID(~ismember({dfolders_LID(:).name},{'.','..'}))

lfp_dir_LID={};
for i=1:size(dfolders_LID,1)
    lfp_dir_LID{i}=dfolders_LID(i).folder;
end

lfp_dir_LID=unique(lfp_dir_LID);

sess_size_LID=[];
for i=1:size(lfp_dir_LID,2)
    sess_size_LID(i)=size(ls(string(lfp_dir_LID(i))),1)-2;
end

dfolders_top_LID={};
for i=1:size(dfolders_LID,1)
    dfolders_top_LID{i}=dfolders_LID(i).folder;
end
dfolders_top_LID=unique(dfolders_top_LID);

% create updated diretory for control 

totalCON={};
for i=1:size(dfolders_control, 1)

totalCON{i}=strcat(string(dfolders_control(i).folder), '\',string(dfolders_control(i).name), '\LFP')

end


% create updated directory for LID
totalLID={};
for i=1:size(dfolders_LID, 1)
totalLID{i}=strcat(string(dfolders_LID(i).folder), '\',string(dfolders_LID(i).name), '\LFP')
end

for i=1:size(totalLID,2)
if ~exist(totalLID{i})
totalLID{i}={};
end
end
totalLID=totalLID(~cellfun('isempty',totalLID))
end
