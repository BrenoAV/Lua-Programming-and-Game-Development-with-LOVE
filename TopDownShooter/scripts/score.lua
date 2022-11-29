Score = {
    value = nil
}

function Score:new(o, start_value)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.value = start_value
    return o
end

function Score:hit(points)
    self.value = self.value + points
end

function Score:reset()
    self.value = 0
end

function Score:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. self.value, 0, 0)
end
