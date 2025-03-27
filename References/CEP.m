%Plot GNSS CEP50
%NED position converts from lat / lon / height to north east down
%Plot CEP & SEP take in NED positions and percentile to make plots
cep_state           = plot_cep(ned_position(log_data.state.position), 50);
sep_state           = plot_sep(ned_position(log_data.state.position), 50);