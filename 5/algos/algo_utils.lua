function getCoalStatus()
    return turtle.getFuelLevel()
end

function checkItems()
    for slot=1,16 do
        turtle.select(slot)
        item=turtle.getItemDetail()
        if item and item.name=="minecraft:cobbled_deepslate" and slot~=1 then turtle.drop() end
    end
    turtle.select(1)
end

result = {}
result.getCoalStatus = getCoalStatus
result.checkItems    = checkItems

return result