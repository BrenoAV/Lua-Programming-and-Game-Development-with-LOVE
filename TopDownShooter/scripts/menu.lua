Menu = {}

function Menu:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

function Menu:draw()
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(100, 0, 100)
    love.graphics.printf("Please click with the left button to start the game...",
        0, HEIGHT/2 - 100, WIDTH, "center")
end
