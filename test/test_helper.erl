-module(test_helper).

-export([get_tests/0]).

get_tests() ->
    {ok, Cwd} = file:get_cwd(),
    [_|RootPath] = lists:reverse(filename:split(Cwd)),
    TestDir = filename:join(lists:reverse(["test" | RootPath])),
    {ok, Tests} = file:consult(filename:join(TestDir, "messages")),
    [{lists:nth(2, T), lists:flatten(T), L, P} || {T,L,P} <- Tests].
