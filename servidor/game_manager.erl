-module(game_manager).
-export([start/0, play/2]).

start() ->
    GM = spawn(fun()-> game_manager([]) end),
    register(?MODULE, GM).

play(User, Level) ->
    ?MODULE ! {play, User, Level, self()},
    receive 
        {Gamepid, ?MODULE} -> Gamepid
    end.


% Player : {User, Level, Pid}
game_manager(Players) ->
    receive
        {play, User, Level, From} -> 
            case lists:filter(fun({_, L, _}) -> (L==Level) or (L==Level+1) or (L==Level-1) end, Players) of
                [] -> 
                    game_manager(Players ++ [{User, Level, From}]);
                [H | _] ->
                    {User_H, _, Pid_H} = H,
                    Game = spawn(fun() -> game({User_H, Pid_H}, {User, From}, 
                                               {{100,200,0}, {300,200,math:pi()}, 
                                                [], {{rand:uniform()*400, rand:uniform()*400}, 
                                                     {rand:uniform()*400, rand:uniform()*400}}
                                               }, {[],[]} ) end),
                    {ok, _} = timer:send_interval(100, Game, send_now),
                    {ok, _} = timer:send_interval(10000, Game, send_enemy),
                    From ! Pid_H ! {start_game, Game},
                    game_manager(Players -- [H])
            end
    end.




%Player   : {User, Pid}
%GInfo    : {{x1, y1, a1, vel1, va1}, {x2, y2, a2, vel2, va2}, [VVm], {VVd, VVd} }
%VVd, VVm : {x, y}
%Interval : {[{Act1, Time}], [{Act2, Time}]}
%Act      : pl | pf | pr | rl | rf | rr
game(Player1, Player2, GInfo, Interval) ->
    {_, Pid1} = Player1,
    {_, Pid2} = Player2,
    {Pos1, Pos2, VVm, VVd} = GInfo,
    {_, _} = Interval,
    receive
        send_now -> 
            New_GInfo = update(GInfo, Interval),
            Pid2 ! Pid1 ! {game_info, New_GInfo},
            game(Player1, Player2, New_GInfo, {[], []});
        send_enemy ->
            game(Player1, Player2, 
                 {Pos1, Pos2, 
                  [{rand:uniform(), rand:uniform()} | VVm], 
                  VVd}, Interval)
    end.

update(GInfo, Interval) ->
    io:fwrite("ole~p~p\n", [GInfo, Interval]).



