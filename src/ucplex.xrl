%% -*- erlang -*-
%% Copyright (C) Bikram Chaterjee
%% @private
%% @Author Bikram Chatterjee
%% @Email razorpeak@gmail.com

Definitions.
D = [0-9A-Fa-f]

Rules.
\x02        : {token, {stx, TokenLine}}.
\x03        : {token, {etx, TokenLine}}.
\x2F        : {token, {'/', TokenLine}}.
{D}+        : {token, {'TERM', TokenLine, TokenChars}}.
(O|R|\:)    : {token, {list_to_atom(TokenChars), TokenLine}}.

Erlang code.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

ucp_lexer_test_() ->
    {inparallel
     , [{S,
         fun() ->
                 {ok, L1, _} = string(T),
                 if L1 /= L ->
                        ?debugFmt("Test ~s~nLexed ~p", [S,L1]),
                        ?assertEqual(L, L1);
                    true -> ok
                 end
         end}
        || {S,T,L,_} <- test_helper:get_tests()]}.
-endif.
