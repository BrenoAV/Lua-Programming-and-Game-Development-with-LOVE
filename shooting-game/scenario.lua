Scenario = {
    sprite = nil
}

function Scenario:new(o, spriteFilename)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.sprite = love.graphics.newImage(spriteFilename)

    return o
end


function Scenario:drawBackground()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.sprite, 0, 0)
end
