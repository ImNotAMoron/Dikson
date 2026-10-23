local camera = {}

function camera.init()
    local players = player.get_all()
    for key,value in pairs(players) do
       	print(key,value)
    end
end

return camera
