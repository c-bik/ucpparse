%% -*- erlang -*-
Header "%% Copyright (C) Bikram Chaterjee"
"%% @private"
"%% @Author Bikram Chatterjee"
"%% @Email razorpeak@gmail.com".

Nonterminals
    header
    data
    checksum
    ucp.

Terminals
    TERM
    'stx'
    'etx'
    'O'
    'R'
    ':'
    '/'.

Rootsymbol ucp.

% Grammer
ucp -> 'stx' header '/' data '/' checksum 'etx'
       : [{header, '$2'}, {data, '$4'}, {checksum, '$6'}].

checksum -> '$empty'    : undefined.
checksum -> TERM        : '$1'.

header -> '$empty'      : undefined.
header -> TERM          : '$1'.

data -> '$empty'        : undefined.
data -> TERM            : '$1'.

Erlang code.

-behaviour(application).
-behaviour(supervisor).

% application callbacks
-export([start/0, start/2, stop/1]).

% supervisor callbacks
-export([init/1]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

% Application
start() -> application:start(?MODULE).
start(_StartType, _StartArgs) -> start_link().
stop(_State) -> ok.

% Supervisor
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).
init([]) ->
    {ok, { {one_for_one, 5, 10}, []} }.

-ifdef(TEST).
ucp_parser_test_() ->
    {inparallel
     , [{S,
         fun() ->
                 ?assertMatch({ok, L, _}, ucplex:string(T)),
                 P1 = ucpparse:parse(L),
                 if P1 /= P ->
                        ?debugFmt("Test ~s~nLexed ~p", [S,P1]),
                        ?assertEqual(P, P1);
                    true -> ok
                 end
         end}
        || {S,T,L,P} <- test_helper:get_tests()]}.

-endif.
