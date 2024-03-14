rednet.open("back")

local args = ...

local function check_type(v, t)
    if type(v)~=t then do return end
    else return v end
end

local BOT_ID = 1

function _split_cmd(cmd)
    local a={}
    if cmd=="" then a[1]="a" return a end
    for token in string.gmatch(cmd, "[^%s]+") do
        table.insert(a, token)
    end
    return a
end


local function ask(q) write(q); return read() end

local function handleCommand(cmd)
    rednet.send(BOT_ID, cmd)
    local id, msg, _ = rednet.receive()
    if id ~= BOT_ID then return end
    write(msg)
    write("\n")
end

repeat
    local cmd = ask(string.format("%d ~> ", BOT_ID))
    if _split_cmd(cmd)[1]=="id" then
        BOT_ID = check_type(tonumber(_split_cmd(cmd)[2]), "number")
    else handleCommand(cmd) end
until cmd == "exit" or cmd == "exit server" or cmd == "exit client"

rednet.close("back")