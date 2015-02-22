scriptId = 'game.myame'
scriptTitle = "Game Myame"
scriptDetailsUrl = "" -- We don't have this until it's submitted to the Myo Market

myo.setLockingPolicy("none")

MOVES = {'fist', 'fingersSpread', 'waveIn', 'waveOut'}
COMMANDS = {'Make a fist', 'Spread your fingers',
            'Bend your hand in', 'Bend your hand out'}

REACTION_TIME = 80
MOVE_TIME = 100
NUM_MOVES = 10
GAME_TIME = NUM_MOVES * MOVE_TIME + REACTION_TIME + 1

state = false
tapstate = false
move = ''

function onPoseEdge(pose, edge)
    if pose == move and edge then
        state = true
    elseif pose == "doubleTap" then
        tapstate = true
    end
    --myo.debug("onPoseEdge: " .. pose .. ", " .. edge)--
end

t = NUM_MOVES * MOVE_TIME+REACTION_TIME + 1

function onPeriodic()
    t = t + 1
    if t > GAME_TIME then
        if tapstate then
            myo.vibrate("medium")
            myo.debug("LET'S GO!")
            points = 0
            t = 0
        end
    elseif t == GAME_TIME then
        tapstate = false
        if points > 7 then
            myo.debug("Well done, you got " .. points .." points.")
        elseif points > 3 then
            myo.debug("Not that bad, you got " .. points .. " points.")
        else
            myo.debug("Uh-oh, you got only " .. points .. " points.")
        end
    elseif (t % MOVE_TIME == 0) then
        i = math.floor(4 * math.random())+1
        state = false
        move = MOVES[i]
        myo.debug(COMMANDS[i] .. "!!!!!!!")
    elseif (t > MOVE_TIME and t % MOVE_TIME == REACTION_TIME) then
        if state then
            myo.debug("YAY")
            points = points + 1
        else
            myo.debug("LOSER")
        end
    end
end

function onUnlock()
    myo.debug("Unlocked")
end

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
    return true
end

function activeAppName()
    return "Output Everything"
end

function onActiveChange(isActive)
    myo.debug("onActiveChange")
end
