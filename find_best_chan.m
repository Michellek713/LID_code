function [OUT_control, channel_to_useCON, OUT_LID, channel_to_useLID] = find_best_chan (sig_name, totalCON, totalLID,input)
%% find best channels for each session for each rat
if isequal(input,'both')
OUT_control={};
for i=1:size(totalCON,2)
    OUT_control{i} = LK_Find_best_LFP_for_a_band_Michelle(sig_name,string(totalCON(i)))
end

channel_to_useCON=[];
for i=1:size(OUT_control,2)
    channel_to_useCON{i}=OUT_control{i}.best_non_reref
end

save('channel_to_useCON.mat', 'channel_to_useCON')

OUT_LID={};
for i=1:size(totalLID,2)
    OUT_LID{i} = LK_Find_best_LFP_for_a_band(sig_name,string(totalLID(i)))
end

channel_to_useLID=[];
for i=1:size(OUT_LID,2)
    channel_to_useLID{i}=OUT_LID{i}.best_non_reref
end
save('channel_to_useLID.mat', 'channel_to_useLID')

end 

if isequal(input,'CON')

OUT_control={};
for i=1:size(lfp_dir_control,2)
    OUT_control{i} = LK_Find_best_LFP_for_a_band(sig_name,string(totalCON(i)))
end

channel_to_useCON=[];
for i=1:size(OUT_control,2)
    channel_to_useCON{i}=OUT_control{i}.best_non_reref
end

save('channel_to_useCON.mat', 'channel_to_useCON')

end


OUT_LID={};
for i=1:size(totalLID,2)
    OUT_LID{i} = LK_Find_best_LFP_for_a_band_Michelle(sig_name,string(totalLID(i)))
end

channel_to_useLID=[];
for i=1:size(OUT_LID,2)
    channel_to_useLID{i}=OUT_LID{i}.best_non_reref
end
save('channel_to_useLID.mat', 'channel_to_useLID')
end
