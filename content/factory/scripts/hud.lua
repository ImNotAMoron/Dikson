local pid

local function mouse_ray()
    local mouse = input.get_mouse_pos()
    local vp = gui.get_viewport()
    local nx = mouse[1] / vp[1] * 2 - 1
    local ny = 1 - mouse[2] / vp[2] * 2

    local tan_half = math.tan(math.rad(cam:get_fov() * cam:get_zoom()) / 2)
    local aspect = vp[1] / vp[2]

    local dir = vec3.add(cam:get_front(),
        vec3.add(vec3.mul(cam:get_right(), nx * tan_half * aspect),
                 vec3.mul(cam:get_up(), ny * tan_half)))
    return cam:get_pos(), vec3.normalize(dir)
end
local function pick_block()
    local start, dir = mouse_ray()
    return block.raycast(start, dir, 64)
end

function mouse(playerid)
    local cam = cameras.get("factory:top-view")

    local hit = pick_block()
     if hit then
         local p = hit.iendpoint
         -- block.destruct(p[1], p[2], p[3], pid)
     end
end

function on_hud_open(playerid)
    pid = playerid
    cam = cameras.get("factory:top-view")
    player.set_camera(pid, cam:get_index())
    gui.set_active_frame("core:main")

    input.add_callback("mouse:left", function()
        local hit = pick_block()
        if hit then
            local p = hit.iendpoint
            p[2] = p[2] + 1
            -- local opx, opy, opz = block.seek_origin(p[1], p[2], p[3])
            -- block.destruct(opx, opy, opz)
            local entity = entities.spawn("factory:blueprint", p)
            local rig = entity.skeleton
            rig:set_model(0, "drill")
        end
    end, nil, true)

    input.add_callback("mouse:right", function()
        local invid, slot = player.get_inventory(pid)
        local itemid, count = inventory.get(invid, slot)
        local blockid = item.placing_block(itemid)
        print(blockid)

        local hit = pick_block()
        if hit and blockid > 0 then
            local p = vec3.add(hit.iendpoint, hit.normal)
            block.place(p[1], p[2], p[3], blockid, 0, pid)
        end
    end, nil, true)
end

local cam = cameras.get("factory:top-view")

function on_hud_render()
    if gui.get_active_frame() == nil then
        gui.set_active_frame("core:main")
    end

    local x, y, z = player.get_pos(hud.get_player())
    cam:set_pos({ x, y + 20, z })
    mouse()
end
