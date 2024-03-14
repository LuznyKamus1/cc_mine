room={}

mining   = false
progress = 0

function room.room(size, z)
    local blocks_mined=0
    local max_blocks_mined = size^2*z
    local y_p=1
    for h=1,z do
        for y=1,size do
            for x=1,size do 
                turtle.dig()
                checkItems()
                blocks_mined=blocks_mined+1
                turtle.forward()
                progress=(blocks_mined/max_blocks_mined)*100
            end
            if y%2 == 0 then turtle.turnLeft() else turtle.turnRight() end
            turtle.dig()
            checkItems()
            turtle.forward()
            if y%2 == 0 then turtle.turnLeft() else turtle.turnRight() end
            y_p=y
        end
        if y_p%2 == 0 then turtle.turnLeft() else turtle.turnRight() end
        for _=1,size do
            turtle.forward()
        end
        turtle.turnLeft()
        if y_p%2 ~= 0 then
            for _=1,size do
                turtle.forward()
            end
            for _=1,2 do turtle.turnLeft() end
        else turtle.turnLeft() end
        turtle.digUp()
        turtle.up()
    end
end
function room.fuel(size, z)
    if (size^2*z)+(size*z)+500 > turtle.getFuelLevel() then return false else return true end
end

function room.getStatus()
    result = {}
    result.mining = mining
    result.progress = progress

    return result
end

function room.changeMining(x) mining = x end

return room