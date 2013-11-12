-module(csv).
-export([parse/1, parse_str/1, my_split/4, binary_to_smth/1]).
-export([load/1, read/1, write/2, save/1]).
-export([no_dublicates/1]).

parse(File) ->
	{ok, Binary} = file:read_file(File),
	Strings = binary:split(Binary, [list_to_binary("\n")], [global]),
	lists:map(fun parse_str/1, Strings).
	
parse_str(String) ->
	%%list_to_tuple(lists:map(fun binary_to_smth/1, binary:split(String, [list_to_binary(",")], [global]))).
	list_to_tuple(lists:map(fun binary_to_smth/1, my_split(String, false, <<>>, []))).
	
my_split(<<>>, _InsideQuotes, Acc, ListAcc) ->
	lists:reverse([Acc|ListAcc]);	
my_split(<<"\"", Rest/binary>>, false, Acc, ListAcc) ->
	my_split(Rest, true, <<Acc/binary, "\"">>, ListAcc);
my_split(<<"\"", Rest/binary>>, true, Acc, ListAcc) ->
	my_split(Rest, false, <<Acc/binary, "\"">>, ListAcc);
my_split(<<",", Rest/binary>>, true, Acc, ListAcc) ->
	my_split(Rest, true, <<Acc/binary, ",">>, ListAcc);
my_split(<<",", Rest/binary>>, InsideQuotes, Acc, ListAcc) ->
	my_split(Rest, InsideQuotes, <<>>, [Acc|ListAcc]);	
my_split(Bin, InsideQuotes, Acc, ListAcc) ->
	<<Start:1/binary, Rest/binary>> = Bin,
	my_split(Rest, InsideQuotes, <<Acc/binary, Start/binary>>, ListAcc).
	
binary_to_smth(<<>>) ->
	<<>>;
binary_to_smth(<<"\"", Rest1/binary>>) ->
	[Text, _Quote] = binary:split(Rest1, [list_to_binary("\"")], [global]),
	Text;
binary_to_smth(Val) ->
	try binary_to_integer(Val) of
		Int -> Int
	catch
		_Class:_Error -> 
			list_to_float(binary_to_list(Val))		
	end.
	
float_or_int({'EXIT', _}, Val) ->
	list_to_float(binary_to_list(Val));
float_or_int(Int, _Val) ->
	Int.
	
load(File) ->
	ets:new(accounts, [named_table]),
	ets:insert(accounts, parse(File)).
	
read(UserId) ->
	ets:lookup(accounts, UserId).
	
write(UserId, Amount) ->
	ets:insert(accounts, {UserId, Amount}).

val_to_binary(Val) when is_integer(Val) ->
	integer_to_binary(Val);
val_to_binary(Val)  ->
	float_to_binary(Val,  [{decimals, 4}, compact]).	
	
save(File) ->
	file:write_file(File, 
	<< << (<<"\"">>)/binary, X/binary, (<<"\"">>)/binary, (<<",">>)/binary, 
	(val_to_binary(Y))/binary, (<<"\n">>)/binary>> || {X, Y} <- ets:tab2list(accounts)>>).
	
no_dublicates(File) ->
	List = [ UserId || {UserId, Amout} <- parse(File) ],
	sets:size(sets:from_list(List)) =:= length(List).
	
