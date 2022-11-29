Timer = {
    start_time = nil,
    actual_time = nil
}

function Timer:new(o, start_time)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.start_time = start_time
    self.actual_time = start_time
    return o
end

function Timer:running(dt)
    self.actual_time = self.actual_time - dt
end

function Timer:decrease(value)
    self.actual_time = self.actual_time - value
end

function Timer:reset()
    self.actual_time = self.start_time
    self.start_time = self.start_time
end

function Timer:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(math.ceil(self.actual_time), WIDTH-60, 0)
end
