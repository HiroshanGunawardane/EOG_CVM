clear;
close all;
global raw_data LR_data blink_times;

raw_data = load("all_data.mat");
LR_data = load("all_data_LR.mat");
blink_times = load("blink_times.mat");

all_saccades_with_blinks = [];

participants = fieldnames(raw_data);
conditions = ["C1" "C2" "C3"];
for i = 1:length(participants) % Loop through participants
    participant = participants{i};
    for j = 1:length(conditions) % Loop through conditions
        condition = conditions(j);
        
        opbci_raw = raw_data.(participant).(condition).opbci; 
        elink_raw = raw_data.(participant).(condition).elink; 
        opbci_LR = LR_data.(participant).(condition).opbci; 
        elink_LR = LR_data.(participant).(condition).elink; 
        event = raw_data.(participant).(condition).event;
        
        [saccades_list, saccades_labels] = extract_saccades(participant,condition);
        for k = 1:length(saccades_labels)
            all_saccades_with_blinks.(saccades_labels(k)) = saccades_list(k);
        end
    end
end

% Now that we found all saccades with blinks, loop through and plot
trial_names = fieldnames(all_saccades_with_blinks);
for i = 1:length(trial_names)
    label = trial_names{i};
    saccade_struct = all_saccades_with_blinks.(label);
   
    figure();
    hold on;
    title(strrep(label, "_", " "));
    xlabel('Time (s)')
    yyaxis left;
    plot(saccade_struct.opbci_raw.time_stamps, saccade_struct.opbci_raw.time_series);
    ylabel('Raw')
    yyaxis right;
    plot(saccade_struct.opbci_LR.time_stamps, saccade_struct.opbci_LR.time_series);
    plot(saccade_struct.elink.time_stamps, saccade_struct.elink.time_series);
    ylabel('Degrees')
    grid on;
end


function [elink_filter, opbci_filter] = get_blink_filters(participant, condition)
    global raw_data blink_times;
    opbci_raw = raw_data.(participant).(condition).opbci; 
    elink_raw = raw_data.(participant).(condition).elink; 
    event = raw_data.(participant).(condition).event;

    % Add first time_stamp to blinks
    current_blink_times = blink_times.(participant).(condition)...
        + event.time_stamps(1);

    elink_filter = zeros(1, length(elink_raw.time_series));
    opbci_filter = zeros(1, length(opbci_raw.time_series));

    % Loop through blinks
    for k = 1:length(current_blink_times)
        elink_filter = elink_filter + ...
            elink_raw.time_stamps >= current_blink_times(k, 1) & ...
            elink_raw.time_stamps <= current_blink_times(k, 2);
        opbci_filter = opbci_filter + ...
            opbci_raw.time_stamps >= current_blink_times(k, 1) & ...
            opbci_raw.time_stamps <= current_blink_times(k, 2);
    end
end
% Loop through event data and extract saccades as struct
function [saccades_list, saccades_labels] = extract_saccades(participant, condition)
    global raw_data LR_data;
    points = ["A", "B", "C", "D"];
    
    opbci_raw = raw_data.(participant).(condition).opbci; 
    event = raw_data.(participant).(condition).event;
    [elink_filter, opbci_filter] = get_blink_filters(participant, condition);

    saccades_list = [];
    saccades_labels = [];
    for ind = 1:length(event.time_series)
        % Extract tag name, eg, t20_exp_D_end
        tag = strsplit(event.time_series{ind},'_');  
        extract = false;
        
        % Experimental values
        if startsWith(tag{1}, 't') && strcmp(tag{2}, 'exp') ...
          && strcmp(tag{4}, 'start')&& ismember(tag{3}, points)
                % Start, end
                extract = true;
        % If calibration and horizontal
        elseif startsWith(tag{1}, 't') && strcmp(tag{2}, 'calib') ...
          && strcmp(tag{3}, 'H') && strcmp(tag{5}, 'start') && ismember(tag{4}, points)
                extract = true;
        end

        % Extract single saccade
        if extract
            start = event.time_stamps(ind);
            stop = event.time_stamps(ind+2);
            
            % Extract if blink is contained
            blinks_contained = opbci_raw.time_stamps(opbci_filter);
            if any(blinks_contained >= start & blinks_contained <=stop)
                label = strjoin([participant '_' condition '_' strjoin(tag(1:length(tag)-1), "_")], "");
                % Save saccade as struct
                single_saccade = isolate_saccade(participant, condition, start, stop);
                saccades_list = [saccades_list single_saccade];
                saccades_labels = [saccades_labels label];
            end
        end
    end
end
function single_saccade = isolate_saccade(participant, condition, start, stop)
    global raw_data LR_data;
    
    opbci_raw = raw_data.(participant).(condition).opbci; 
    elink_LR = LR_data.(participant).(condition).elink; 
    opbci_LR = LR_data.(participant).(condition).opbci; 
    
    % Save saccade as struct
    single_saccade = struct();
    saccade_filter_opbci = opbci_raw.time_stamps >= start ...
        & opbci_raw.time_stamps <=stop;
    saccade_filter_elink = elink_LR.time_stamps >= start ...
        & elink_LR.time_stamps <=stop;

    single_saccade.opbci_raw = struct( ...
        "time_stamps", opbci_raw.time_stamps(saccade_filter_opbci), ...
        "time_series", opbci_raw.time_series(saccade_filter_opbci));
    single_saccade.elink = struct( ...
        "time_stamps", elink_LR.time_stamps(saccade_filter_elink), ...
        "time_series", elink_LR.time_series(saccade_filter_elink));
    single_saccade.opbci_LR = struct( ...
        "time_stamps", opbci_LR.time_stamps(saccade_filter_opbci), ...
        "time_series", opbci_LR.time_series(saccade_filter_opbci));
end
% function plot_single_trial(title, saccade_struct)
% 
% end
