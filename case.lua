local Case = {}


function Case:new(img, chat)
    local new_case = {
        -- Est-ce qu'il y a une mine dans la case ?
        has_olivier = false,
        -- Est-ce que la case a déjà été découverte ?
        down = false,
        -- Combien de mines autour de cette case ?
        minotaure = 0,
        has_drapeau = false
    }
    setmetatable(new_case, self)
    self.__index = self
    -- Image de la krokette
    self.img = img
    self.chat = chat
    return new_case
end

function Case:draw(x, y)
    love.graphics.setColor(0.1, math.cos(0.5), math.cos(0.5), 1)
    love.graphics.print(self.minotaure, 50 + x*60, 100 + y*30)
    if self.has_olivier then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.img, 34 + x*60, 90 + y*30, 0, 0.05, 0.05)
    end
    love.graphics.setColor(0.1,
        math.cos(math.sqrt((x-1)^2+(y-1)^2) + time)/3 + 0.5,
        math.cos(math.sqrt((x-1)^2+(y-1)^2))/4 + 0.5,
        1)
    if self.down then
        love.graphics.rectangle("line", 28 + x*60, 95 + y*30, 50, 25, 5, 5, 0)
    else
        love.graphics.rectangle("fill", 28 + x*60, 95 + y*30, 50, 25, 5, 5, 0)
    end
    if self.has_drapeau then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.chat, 38 + x*60, 90 + y*30, 0, 0.05, 0.05)
    end
end

-- function Case:Ondiscover(x, y)
--     if self.tableau[x][y].minotaure == 0 then
--         Demineur:play(x-1, y)
--     end
-- end

return Case