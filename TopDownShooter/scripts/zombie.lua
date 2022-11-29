local utils = require('scripts.utils')

Zombie = {}

function Zombie:new(spriteFilepath)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    local side = math.random(1, 4)

    if side == 1 then
        o.x = -30
        o.y = math.random(0, HEIGHT)
    elseif side == 2 then
        o.x = WIDTH + 30
        o.y = math.random(0, HEIGHT)
    elseif side == 3 then
        o.x = math.random(0, WIDTH)
        o.y = -30
    elseif side == 4 then
        o.x = math.random(0, WIDTH)
        o.y = HEIGHT + 30
    else
        o.x = 0
        o.y = 0
    end

    o.speed = 200
    o.dead = false
    o.sprite = love.graphics.newImage(spriteFilepath)

    return o
end

function Zombie:setX(x)
    self.x = x
end

function Zombie:setY(y)
    self.y = y
end

function Zombie:getX()
    return self.x
end

function Zombie:getY()
    return self.y
end

function Zombie:isDead()
    return self.dead
end

function Zombie:draw(playerX, playerY)
    local rot = utils.angleTwoPoints(self.x, self.y, playerX, playerY)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.sprite,
        self.x,
        self.y,
        rot,
        nil,
        nil,
        self.sprite:getWidth()/2,
        self.sprite:getHeight()/2)
end

function Zombie:movement(playerX, playerY, dt)
    local vectorMod = math.sqrt((playerX - self.x)^2 + (playerY - self.y)^2)
    local angle = math.pi / 2 - utils.angleTwoPoints(self.x, self.y, playerX, playerY)
    local vectorX = vectorMod * math.sin(angle) / vectorMod
    local vectorY = vectorMod * math.cos(angle) / vectorMod

    self.x = self.x + self.speed*vectorX*dt
    self.y = self.y + self.speed*vectorY*dt

end
