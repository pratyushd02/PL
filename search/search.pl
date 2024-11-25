%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here:
%%%%%%%%%%%%%%%%%%%%%%

% Helper predicates

% Check if a door is passable
passable(CurrentRoom, NextRoom, _Keys) :-
    door(CurrentRoom, NextRoom);
    door(NextRoom, CurrentRoom).

passable(CurrentRoom, NextRoom, Keys) :-
    (locked_door(CurrentRoom, NextRoom, LockColor);
     locked_door(NextRoom, CurrentRoom, LockColor)),
    member(LockColor, Keys).

% Add key to the key list if present in the room
pickup_keys(CurrentRoom, Keys, UpdatedKeys) :-
    (key(CurrentRoom, KeyColor), \+ member(KeyColor, Keys) ->
        UpdatedKeys = [KeyColor | Keys];
        UpdatedKeys = Keys).

% BFS for shortest path
bfs([[Path, CurrentRoom, _] | _], Path) :-  % Replaced Keys with _
    treasure(CurrentRoom).

bfs([[Path, CurrentRoom, Keys] | RestQueue], Solution) :-
    findall(
        [NewPath, NextRoom, UpdatedKeys],
        (
            passable(CurrentRoom, NextRoom, Keys),
            \+ member(move(CurrentRoom, NextRoom), Path),
            \+ member(move(NextRoom, CurrentRoom), Path),
            pickup_keys(NextRoom, Keys, UpdatedKeys),
            append(Path, [move(CurrentRoom, NextRoom)], NewPath)
        ),
        NewPaths
    ),
    append(RestQueue, NewPaths, FilteredQueue),
    bfs(FilteredQueue, Solution).


% Filter the queue to avoid revisiting the same room with the same keys
filter_queue([], _, []).
filter_queue([[Path, Room, Keys] | Rest], Visited, FilteredQueue) :-
    (member((Room, Keys), Visited) ->
        filter_queue(Rest, Visited, FilteredQueue);
        filter_queue(Rest, [(Room, Keys) | Visited], [[Path, Room, Keys] | FilteredQueue])
    ).

% Entry point for the search
search(Actions) :-
    initial(StartRoom),
    bfs([[[ ], StartRoom, []]], Actions).
