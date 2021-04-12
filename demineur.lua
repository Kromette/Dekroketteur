local Demineur = {}
local Case = require("case")

function Demineur:draw()
    for x, colonne in ipairs(self.tableau) do
        love.graphics.setColor(0.1, math.cos(0.5), math.cos(0.5), 1)
        love.graphics.print(string.char(64+x), 50 + 60*x, 100)
        for y, v in ipairs(colonne) do
            v:draw(x,y)
            if x == 1 then
            love.graphics.setColor(0.1, math.cos(0.5), math.cos(0.5), 1)
            love.graphics.print(y, 50, 100 + y*30)
            end
        end
    end
end

function Demineur:new(x, y, nb_mines)
    local new_demineur = {}
    self.krokette = love.graphics.newImage("krokette.png")
    self.chat = love.graphics.newImage("flag.png")
    if nb_mines > x*y then
        nb_mines = (x*y)-1
        print("Trop de krokettes")
    end
    setmetatable(new_demineur, self)
    self.__index = self
    self.nb_mines = nb_mines
    new_demineur.x = x
    new_demineur.y = y
    new_demineur:fill()
    new_demineur:placer_mines()
    return new_demineur
end

function Demineur:fill()
    self.tableau = {}
    for i = 1, self.x, 1 do
        self.tableau[i] = {}
        for j = 1, self.y, 1 do
            self.tableau[i][j] = Case:new(self.krokette, self.chat)
        end
    end
end

function Demineur:placer_mines()
    local mines_placed = 0
    while mines_placed<self.nb_mines do
        local c = love.math.random(self.x)
        local l = love.math.random(self.y)
        if not self.tableau[c][l].has_olivier then
            self.tableau[c][l].has_olivier = true
            for x = c-1, c+1, 1 do
                for y = l-1, l+1, 1 do
                    if x ~= 0
                        and x ~= self.x+1
                        and y ~= 0
                        and y ~= self.y+1
                        and not self.tableau[x][y].has_olivier
                    then
                        self.tableau[x][y].minotaure = self.tableau[x][y].minotaure +1
                    end
                end
            end
            mines_placed = mines_placed + 1
        end
    end
end

function Demineur:drapeau(x, y)
    if x <= self.x and x >= 1 and y <= self.y and y >= 1 and self.tableau[x][y].down == false then
        if self.tableau[x][y].has_drapeau == false then
            self.tableau[x][y].has_drapeau = true
        else
            self.tableau[x][y].has_drapeau = false
        end
    end
end

function Demineur:play(x, y)
    pile = {}
    pile[1] = {x = x, y = y}
    while #pile ~= 0 do
        local x = pile[1].x
        local y = pile[1].y
            --vérifier que la case est dans le tableau
            if x <= self.x and x >= 1 and y <= self.y and y >= 1 and self.tableau[x][y].has_drapeau == false then
                if not self.tableau[x][y].down then
                    self.tableau[x][y].down = true
                    if self.tableau[x][y].has_olivier then
                        self:terminatour()
                    elseif self.tableau[x][y].minotaure == 0 then
                        self:discover(x, y, pile)
                    end
                end
            end
        table.remove(pile, 1)
    end
end



--Découverte de la case d'à côté
function Demineur:discover(x, y, pile)
    table.insert(pile, {x = x-1, y = y-1})
    table.insert(pile, {x = x-1, y = y})
    table.insert(pile, {x = x-1, y = y+1})
    table.insert(pile, {x = x, y = y-1})
    table.insert(pile, {x = x, y = y+1})
    table.insert(pile, {x = x+1, y = y-1})
    table.insert(pile, {x = x+1, y = y})
    table.insert(pile, {x = x+1, y = y+1})
    return(pile)
end

function Demineur:terminatour()
    print("perdu")
end

return Demineur