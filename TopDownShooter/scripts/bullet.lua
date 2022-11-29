local utils = require('scripts.utils')

Bullet = {}

function Bullet:new(x, y, mouseX, mouseY, spriteFilepath)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.x = x
    o.y = y
    o.speed = 500
    o.dead = false
    o.direction = utils.angleTwoPoints(x, y, mouseX, mouseY)
    o.sprite = love.graphics.newImage(spriteFilepath)

    return o
end

function Bullet:getX()
    return self.x
end

function Bullet:getY()
    return self.y
end

function Bullet:isDead()
    return self.dead
end

function Bullet:draw()
    love.graphics.draw(self.sprite,
        self.x,
        self.y,
        0,
        .2,
        nil,
        self.sprite:getWidth()/2,
        self.sprite:getHeight()/2)
end

function Bullet:movement(dt)
    self.x = self.x + math.cos(self.direction) * self.speed * dt
    self.y = self.y + math.sin(self.direction) * self.speed * dt
end
