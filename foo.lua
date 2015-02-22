scriptId = 'com.thalmic.examples.outputeverything'
scriptTitle = "Output Everything"
scriptDetailsUrl = "" -- We don't have this until it's submitted to the Myo Market

myo.setLockingPolicy("none")

state = false
tapstate = false
move = ''
moves = {'fist', 'fingersSpread', 'waveIn', 'waveOut'}
commands = {'Make a fist', 'Spread your fingers',
            'Bend your hand in', 'Bend your hand out'}

function onPoseEdge(pose, edge)
	if pose == move and edge then
		state = true
	elseif pose == "doubleTap" then
		tapstate = true
	end
    --myo.debug("onPoseEdge: " .. pose .. ", " .. edge)--
end


reaction_time = 80
move_time = 100
num_moves = 10
t = num_moves*move_time+reaction_time+1

function onPeriodic()
	t = t + 1
	if t > num_moves*move_time+reaction_time+1 then
		if tapstate then
			myo.debug("Let's try again!")
			points = 0
			t = 0
		end
	elseif t == num_moves*move_time+reaction_time+1 then
		tapstate = false
		if points > 7 then
			myo.debug("Well done, you got " .. points .." points.")
		elseif points > 3 then
			myo.debug("Not that bad, you got " .. points .. " points.")
		else
			myo.debug("Uh-oh, you got only " .. points .. " points.")
		end
	elseif (t % move_time == 0) then
		i = math.floor(4 * math.random())+1
		state = false
		move = moves[i]
		myo.debug(commands[i] .. "!!!!!!!")
	elseif (t > move_time and t % move_time == reaction_time) then
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
