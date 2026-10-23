-- local camera = require "factory:camera"

function set_top_view_camera()
    local cam = cameras.get("factory:top-view")
    x, y, z = player.get_pos(0)
    cam:set_pos({ x, y + 20, z })
    local yaw = mat4.rotate({ 0, 1, 0 }, -90);
    cam:set_rot(mat4.rotate(yaw, { 1, 0, 0 }, -90))
    player.set_rot(0, -90, 0, 0)
    player.set_camera(0, cam:get_index())
end

function on_world_open()
   set_top_view_camera()
end
