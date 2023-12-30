%%% Get indices of start/stop events in input data. Used for detrending
function event_inds = get_event_inds(event, inp)
    event_times = event.time_stamps(contains(event.time_series, ["start", "end"]));
    event_inds = zeros(1, length(event_times));

    for ind = 1:length(event_times)
        [~, event_ind] = min(abs(event_times(ind) - inp.time_stamps));
        event_inds(ind) = event_ind;
    end
end



