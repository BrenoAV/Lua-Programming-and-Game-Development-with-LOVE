Target = {
    x = nil,
    y = nil,
    radius = nil,
    sprite = nil
}

function Target:new(o, x, y, radius, spriteFilename)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.x = x
    self.y = y
    self.radius = radius
    self.sprite = love.graphics.newImage(spriteFilename)

    return o
end

function Target:newSpawn()
    self.x = math.random(100, WIDTH - 100)
    self.y = math.random(100, HEIGHT - 100)
end

function Target:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.sprite, self.x - self.radius, self.y - self.radius)
end
