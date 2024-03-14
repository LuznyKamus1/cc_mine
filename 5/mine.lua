local utils = require("algos/algo_utils")
local room  = require("algos/mine_room")
local strip = require("algos/mine_strip")

local progress = 0
local mining   = false

rednet.open("left")

local HANDY_ID = 3

local function splitCmd(cmd)
    args={}
    if cmd=="" then args[1]="a" return args end
    for token in string.gmatch(cmd, "[^%s]+") do
        table.insert(args, token)
    end
    return args
end

local function handleCommand(cmd)
    write(cmd[1])
    write("\n")
    --basic utilities
    if cmd[1]=="echo" then rednet.send(HANDY_ID, "echo")
    elseif cmd[1]=="exit" then
        if cmd[2]==nil or cmd[2]=="client" then rednet.send(HANDY_ID, "exited!")
        elseif cmd[2]=="server" then rednet.send(HANDY_ID, "exited server!") end
    
    --status
    elseif cmd[1]=="status" then
        if cmd[2]==nil then rednet.send(HANDY_ID, string.format("coal: %d, progress: %d, mining: &d", getCoalStatus(), progress, tostring(mining)))
        elseif cmd[2]=="fuel" then rednet.send(HANDY_ID, string.format("coal: %d", utils.getCoalStatus()))
        elseif cmd[2]=="prog" then rednet.send(HANDY_ID, string.format("progress: %d", progress))
        else rednet.send(HANDY_ID, "unknown arg!")
        end
    
    --better utilities
    elseif cmd[1]=="refuel" then turtle.refuel(); rednet.send(HANDY_ID, "refueled")
    elseif cmd[1]=="cancel" then mining=false; rednet.send(HANDY_ID, "canceled!")
    
    --moving utilities
    elseif cmd[1]=="move" then turtle.forward(); rednet.send(HANDY_ID, "moved 1 block")
    elseif cmd[1]=="rotate" then
        if cmd[2] then
            if cmd[2]=="right" then turtle.turnRight(); rednet.send(HANDY_ID, "turned right")
            elseif cmd[2]=="left" then turtle.turnLeft(); rednet.send(HANDY_ID, "turned left") end
        else turtle.turnRight(); rednet.send(HANDY_ID, "turned right") end

    else rednet.send(HANDY_ID, "not a command!!!") end
end

function cmdLine()
    local id, msg, _ = rednet.receive()
    if id~=HANDY_ID then return end

    local cmd=splitCmd(msg)

    if cmd[1]=="mine" then 
        if cmd[2]==nil or cmd[2]=="strip_mine" then
            rednet.send(HANDY_ID, "mining!")
            mining = true
            parallel.waitForAny(function()
                while true do
                    cmdLine()
                    progress=strip.getStatus().progress
                    strip.changeMining(mining)
                end
            end,
            function() strip.b_strip() end)
        elseif cmd[2]=="room" then
            if cmd[3]==nil or cmd[4]==nil then 
                if not room.room_fuel(6,2) then rednet.send(HANDY_ID, "REFUEL!!!"); return end
                rednet.send(HANDY_ID, "printing!")
                parallel.waitForAny(function()
                    while true do
                        cmdLine()
                        progress=room.getStatus().progress
                        room.changeMining(mining)
                    end
                end, function() room.room(6,2) end)
            else
                if not room.room_fuel(cmd[3],cmd[4]) then rednet.send(HANDY_ID, "REFUEL!!!"); return end
                rednet.send(HANDY_ID, "printing!")
                parallel.waitForAny(function()
                    while true do
                        cmdLine()
                        progress=room.getStatus().progress
                        room.changeMining(mining)
                    end
                end, function() room.room(cmd[3], cmd[4]) end)
            end
        else rednet.send(HANDY_ID, "unknown algo!") end
    end

    handleCommand(cmd)
    return msg
end

repeat
    local msg=cmdLine()
until msg == "exit server"

rednet.close("left")