-module(pp).
-export([start/0, ping/1, pong/1]).

pong(10) ->
	io:format("No more pongs ~n");
pong(N) ->
	receive
		{Pid, ping} -> 
			io:format("Pong get ping ~n"),
			Pid ! pong,
			timer:sleep(1000),
			pong(N+1)
	end.

ping(Pid) ->
	Pid ! {self(), ping},
	receive
		pong -> 
			io:format("Ping get pong ~n"),
			ping(Pid) 
	after
		6000 ->
			io:format("No more pings ~n")
	end.


start() ->
	Pid = spawn(?MODULE, pong, [0]),
	spawn(?MODULE, ping, [Pid]).