addpath('3rdparty');
addpath('helpers');
addpath('core');
addpath('dist');
addpath('compare');

global simoututils_stats_get_ simoututils_version;
simoututils_stats_get_ = @stats_get_pphpc;
simoututils_version = '1.2';

fprintf('\n * SimOutUtils v%s loaded\n', simoututils_version);
fprintf(' * Default "stats_get_*" function: %s\n\n', ...
    getfield(functions(simoututils_stats_get_), 'function'));
