strip = {}
utils = require("algos/algo_utils")

mining = false
progress = 0
fuel_back = 0
local moves = {}

-- REMEMBER to add `= {}` to the end
local usefull = {}
usefull["minecraft:diamond_ore"] = {}
usefull["minecraft:deepslate_diamond_ore"] = {}
usefull["minecraft:redstone_ore"] = {}
usefull["minecraft:deepslate_redstone_ore"] = {}
usefull["minecraft:gold_ore"] = {}
usefull["minecraft:deepslate_gold_ore"] = {}
usefull["minecraft:iron_ore"] = {}
usefull["minecraft:deepslate_iron_ore"] = {}
usefull["minecraft:coal_ore"] = {}
usefull["minecraft:deepslate_coal_ore"] = {}
usefull["minecraft:emerald_ore"] = {}
usefull["minecraft:deepslate_emerald_ore"] = {}

local function check_block(a)
    if a==nil then success, data = turtle.inspect()
    elseif a=="up" then success, data = turtle.inspectUp()
    elseif a=="down" then success, data = turtle.inspectDown()
    else return nil end
    if success then
        return data.name
    else
        return nil
    end
end
local function check_block_usefull(name)
    if name==nil then return false end
    if usefull[name] then 
        return true
    else
        return false
    end
end

local function reverse(move)
    if move=="forward" then turtle.back(); fuel_back=fuel_back+1
    elseif move=="up" then turtle.down(); fuel_back=fuel_back+1
    elseif move=="down" then turtle.up(); fuel_back=fuel_back+1
    elseif move=="right" then
        turtle.back()
        fuel_back=fuel_back+1
        turtle.turnLeft()
    elseif move=="left" then
        turtle.back()
        fuel_back=fuel_back+1
        turtle.turnRight()
    else printError("wrong directrion (or no vein) !!!! (see line 40)") end
end

--check and mine vein
local function mine_vein()
    local moves = {}
    while true do
        fuel = turtle.getFuelLevel()
        if fuel==fuel_back then break end

        local front = check_block_usefull(check_block())
        local up    = check_block_usefull(check_block("up"))
        local down  = check_block_usefull(check_block("down"))

        turtle.turnRight()
        local right = check_block_usefull(check_block())
        turtle.turnLeft()
        turtle.turnLeft()
        local left  = check_block_usefull(check_block())
        turtle.turnRight()

        if front then
            turtle.dig()
            turtle.forward()
            fuel_back=fuel_back+1
            table.insert(mmoves, "forward")
        elseif up then
            turtle.digUp()
            turtle.up()
            fuel_back=fuel_back+1
            table.insert(mmoves, "up")
        elseif down then
            turtle.digDown()
            turtle.down()
            fuel_back=fuel_back+1
            table.insert(mmoves, "down")
        elseif right then
            turtle.turnRight()
            turtle.dig()
            turtle.forward()
            fuel_back=fuel_back+1
            table.insert(mmoves, "right")
        elseif left then
            turtle.turnLeft()
            turtle.dig()
            turtle.forward()
            fuel_back=fuel_back+1
            table.insert(mmoves, "left")
        else
            if mmoves[#mmoves]==nil then break end
            reverse(mmoves[#mmoves])
            mmoves[#mmoves]=nil
        end
    end
end

-- BETTER STRIP MINE algo
function strip.b_strip()
    mining=true
    progress = 0
    fuel_back = 0
    while mining do
        fuel = turtle.getFuelLevel()
        if fuel==fuel_back then break end
        turtle.dig()
        utils.checkItems()
        table.insert(moves, "forward")
        turtle.forward()
        fuel_back = fuel_back+1
        progress = progress+1
        if fuel_back == fuel then break end
        if check_block_usefull(check_block()) then mine_vein() end
        --print(fuel_back)
    end
    for i=1, i==#moves do reverse(move[i]) end
end

function strip.getStatus()
    result = {}
    result.mining = mining
    result.progress = progress

    return result
end

function strip.changeMining(x) mining = x end

return strip