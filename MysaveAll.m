function MysaveAll(sessionDir, sessionName)
    % Check if the sessionDir exists, if not, create it
    if ~exist(sessionDir, 'dir')
        mkdir(sessionDir);
    end

    % Create a new folder for the current session
    sessionOutputDir = fullfile(sessionDir, sessionName);
    if ~exist(sessionOutputDir, 'dir')
        mkdir(sessionOutputDir);
    end

    % Get the list of open figures
    figHandles = findall(0, 'Type', 'figure');

    % Save each figure to the session output folder
    for i = 1:numel(figHandles)
        figHandle = figHandles(i);
        figName = get(figHandle, 'Name');
        
        % If the figure has no name, use a default filename
        if isempty(figName)
            figName = sprintf('Figure_%d', figHandle.Number);
        end

        % Remove special characters from the filename to ensure compatibility
        figName = regexprep(figName, {'[^a-zA-Z0-9]', '\s+'}, '_', 'preservecase');

        % Save the figure in the session output folder as PNG format
        saveas(figHandle, fullfile(sessionOutputDir, [figName, '.png']), 'png');
    end
end


% FolderName = '/Users/michellekrumm/Documents/LID_LFP_Practice/Rat380_all_trials/01/output';   % Your destination folder
% FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
% for iFig = 1:length(FigList)
%   FigHandle = FigList(iFig);
%   ax = findobj(FigHandle, 'type', 'axes');
%   FigName   = ax.Title.String;
%   savefig(FigHandle, fullfile(FolderName, [FigName '.fig'])); % in this case, no need to use set(0, 'CurrentFigure', FigHandle);
% end


