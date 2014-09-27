%% -*- erlang -*-
Header "%% Copyright (C) K2 Informatics GmbH"
"%% @private"
"%% @Author Bikram Chatterjee"
"%% @Email razorpeak@gmail.com".

Nonterminals
    ucp.

Terminals
    TERM
    '/'.

Rootsymbol ucp.

% Grammer
ucp -> TERM '/' : "".

Erlang code.

-behaviour(application).
-behaviour(supervisor).

% application callbacks
-export([start/0, start/2, stop/1]).

% supervisor callbacks
-export([init/1]).

% Application
start() -> application:start(?MODULE).
start(_StartType, _StartArgs) -> start_link().
stop(_State) -> ok.

% Supervisor
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).
init([]) ->
    {ok, { {one_for_one, 5, 10}, []} }.

