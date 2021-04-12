local Demineur = require("Demineur")
local socket = require "socket"
local udp = socket.udp()
time = 0

function love.load(arg)
-- arg[1] correspond au nombre de colonnes
-- arg[2] correspond au nombre de lignes
-- arg[3] correspond au nombre de krokettes
    demineur = Demineur:new(tonumber(arg[1]), tonumber(arg[2]), tonumber(arg[3]))
    udp:settimeout(0)
    udp:setsockname('0.0.0.0', 12345)
end

function love.draw()
    demineur:draw()
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        Index_casex = math.floor((x-28)/60)
        Index_casey = math.floor((y-95)/30)
        print(Index_casex, Index_casey)
        demineur:play(Index_casex, Index_casey)
        -- table.insert(Case, ""..Index_casex.."-"..Index_casey)
        -- print(Case[1], Case[2])
    end
end

function love.update(dt)
    time = time + dt
    data, msg_or_ip, port_or_nil = udp:receivefrom()
	if data then
        print(data)
		-- more of these funky match paterns!
		local p_f, x, y = data:match("^(....) (%d*) (%d*)")
        print(p_f, x, y)
        if p_f == "flag" then
            print(p_f, x, y)
            demineur:drapeau(tonumber(x), tonumber(y))
        else
            print(p_f, x, y)
            demineur:play(tonumber(x), tonumber(y))
        end
    end
end