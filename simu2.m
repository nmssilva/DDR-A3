function [ bs, bh ] = simu2( lambda, p, invmiu, S, W, Ms, Mh, R, N)
% Event driven simulator for the service architecture based on one server
% farm with S servers, providing movies in 2 video formats and with a
% resource reservation of W for high-defenition movies

% Input:
% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% lambda - movies request rate (in requests/hour)
% p - percentage of requests for high-definition movies (in %)
% invmiu - average duration of movies (in minutes)
% S - number of servers (each server with a capacity of 100 Mbps)
% W - resource reservation for high-definition movies (in Mbps)
% Ms – throughput of movies in standard definition (2 Mbps)
% Mh – throughput of movies in high definition (5 Mbps)
% R – number of movie requests to stop simulation
% N – movie request number to start updating the statistical counters

% Output:
% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% bs – blocking probability of standard movie requests
% bh – blocking probability of high-definition movie requests

lambdas = lambda*(1-p);
lambdah = lambda*p;

invlambda_s=60/lambdas;
invlambda_h=60/lambdah;

% Event definition:
% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Time instant of a standard movie request
ARRIVAL_S = 0;
% Time instant of a high-definition movie request
ARRIVAL_H = 1;
% Time instant of a standard movie termination on server i (i = 1,…,S)
DEPARTURE_S = 2;
% Time instant of a high-definition movie termination on server i (i = 1,…,S)
DEPARTURE_H = 3;

% State Variables:
% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Total throughput of the movies in transmission by server i (i = 1,…,S)
STATE = zeros(1,S);
% Total throughput of standard movies in transmission
STATE_S = 0;

% Statistical Counters:
% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
% Total Number of movie requests
NARRIVALS = 0;
% Number of standard movie requests
NARRIVALS_S = 0;
% Number of high-definition movie requests
NARRIVALS_H = 0;
% Number of blocked standard movie requests
BLOCKED_S = 0;
% Number of blocked high-definition movie requests
BLOCKED_H = 0;

C=S * 100;
% Clock and initial List of Events:
% ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
Clock = 0;
EventList = [ARRIVAL_S exprnd( invlambda_s ) 0; ARRIVAL_H exprnd(invlambda_h) 0];

EventList = sortrows( EventList, 2 );

while NARRIVALS < N   
    event= EventList(1,1);
    %Previous_Clock= Clock;
    Clock= EventList(1,2);
    server = EventList (1,3);
    EventList(1,:)= [];
    %LOAD= LOAD + STATE*(Clock-Previous_Clock);
    
    if event == ARRIVAL_S
		EventList = [ EventList; ARRIVAL_S Clock + exprnd(invlambda_s) 0];
		NARRIVALS = NARRIVALS + 1;
        %NARRIVALS_S = NARRIVALS_S + 1;
        aux=find(STATE==min(STATE));
        aux=aux(1);
		if STATE_S + Ms <= C-W && STATE(aux)+ Ms <= 100
			STATE_S = STATE_S + Ms;
            STATE(aux) = STATE(aux) + Ms;
			EventList = [EventList; DEPARTURE_S Clock + exprnd(invmiu) aux];
		else
			%BLOCKED_S = BLOCKED_S + 1;
		end
    elseif event == ARRIVAL_H
        EventList = [ EventList; ARRIVAL_H Clock + exprnd(invlambda_h) 0];
		NARRIVALS = NARRIVALS + 1;
        %NARRIVALS_H = NARRIVALS_H + 1;
        aux=find(STATE==min(STATE));
        aux=aux(1);
		if STATE(aux)+ Mh <= 100;
            STATE(aux) = STATE(aux) + Mh;
			EventList = [EventList; DEPARTURE_H Clock + exprnd(invmiu) aux];
		else
			%BLOCKED_H = BLOCKED_H + 1;
		end
    elseif event == DEPARTURE_S
        STATE_S= STATE_S-Ms;
        STATE(server) = STATE(server) - Ms;
    else        
        STATE(server) = STATE(server) - Mh;
    end
    EventList= sortrows(EventList,2);
end

while NARRIVALS < R    
    event= EventList(1,1);
    %Previous_Clock= Clock;
    Clock= EventList(1,2);
    server = EventList (1,3);
    EventList(1,:)= [];
    %LOAD= LOAD + STATE*(Clock-Previous_Clock);
    
    if event == ARRIVAL_S
		EventList = [ EventList; ARRIVAL_S Clock + exprnd(invlambda_s) 0];
		NARRIVALS = NARRIVALS + 1;
        NARRIVALS_S = NARRIVALS_S + 1;
        aux=find(STATE==min(STATE));
        aux=aux(1);
		if STATE_S + Ms <= C-W && STATE(aux)+ Ms <= 100
			STATE_S = STATE_S + Ms;
            STATE(aux) = STATE(aux) + Ms;
			EventList = [EventList; DEPARTURE_S Clock + exprnd(invmiu) aux];
		else
			BLOCKED_S = BLOCKED_S + 1;
		end
    elseif event == ARRIVAL_H
        EventList = [ EventList; ARRIVAL_H Clock + exprnd(invlambda_h) 0];
		NARRIVALS = NARRIVALS + 1;
        NARRIVALS_H = NARRIVALS_H + 1;
        aux=find(STATE==min(STATE));
        aux=aux(1);
		if STATE(aux)+ Mh <= 100;
            STATE(aux) = STATE(aux) + Mh;
			EventList = [EventList; DEPARTURE_H Clock + exprnd(invmiu) aux];
		else
			BLOCKED_H = BLOCKED_H + 1;
		end
    elseif event == DEPARTURE_S
        STATE_S= STATE_S-Ms;
        STATE(server) = STATE(server) - Ms;
    else        
        STATE(server) = STATE(server) - Mh;
    end
    EventList= sortrows(EventList,2);
end

bs = BLOCKED_S/NARRIVALS_S;
bh = BLOCKED_H/NARRIVALS_H;
    
end
