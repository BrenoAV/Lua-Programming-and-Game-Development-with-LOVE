local anim8 = require "libraries.anim8.anim8"

Enemy = {}

function Enemy:new(x, y, world)
    local o = {}

    setmetatable(o, self)
    self.__index = self

    o.x = x
    o.y = y
    o.world = world
    o.physics = {}
    o.physics.body = love.physics.newBody(world, x, y, "dynamic")
    o.physics.shape = love.physics.newRectangleShape(70, 90)
    o.physics.texture = love.physics.newFixture(o.physics.body,
        o.physics.shape, 1)
    o.physics.texture:setUserData("Enemy")

    o.speed = 100
    o.direction = 1

    o.spriteSheet = love.graphics.newImage("sprites/enemySheet.png")
    o.grid = anim8.newGrid(100, 79,
        o.spriteSheet:getWidth(),
        o.spriteSheet:getHeight())
    o.animation = anim8.newAnimation(o.grid('1-2', 1), 0.03)

    return o
end

function Enemy:move(dt)
    local ex, _ = self.physics.body:getPosition()
    if ex < 200 or ex > 600 then
        self.direction = self.direction * (-1)
    end
    self.physics.body:setX(ex - self.speed * self.direction * dt)
end

function Enemy:draw()
    local ex, ey = self.physics.body:getPosition()

    self.animation:draw(self.spriteSheet, ex, ey, nil, - self.direction*1,
        1, 50, 65)

end
