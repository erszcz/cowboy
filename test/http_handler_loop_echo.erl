%% Feel free to use, reuse and abuse the code in this file.

-module(http_handler_loop_echo).
-behaviour(cowboy_loop_handler).
-export([init/3, info/3, terminate/3]).

init({_Transport, http}, Req, _Opts) ->
	HasBody = cowboy_req:has_body(Req),
	{Len, Req2} = cowboy_req:body_length(Req),
	error_logger:info_msg("~s's alive! has? ~p, len: ~p~n",
		[?MODULE, HasBody, Len]),
	self() ! echo,
	{loop, Req2, []}.

info(echo, Req, State) ->
	error_logger:info_msg("~s:info/3~n", [?MODULE]),
	{ok, Body, Req2} = cowboy_req:body(Req),
	error_logger:info_msg("recv: ~p~n", [Body]),
	{ok, Req3} = cowboy_req:reply(200, [], Body, Req2),
	{ok, Req3, State}.

terminate(_, _, _) ->
	ok.
