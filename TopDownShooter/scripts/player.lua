local utils = require('scripts.utils')

Player = {}

function Player:new(o, x, y, speed, spriteFilepath)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.sprite = love.graphics.newImage(spriteFilepath)
    self.x = x
    self.y = y
    self.speed = speed
    self.rotation = 0
    self.injured = false

    return o
end

function Player:draw(cursorX, cursorY)
    self:setRotation(utils.angleTwoPoints(self.x, self.y,
        cursorX, cursorY))
    if self:isInjured() then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.draw(self.sprite,
        self.x,
        self.y,
        self.rotation,
        nil, nil,
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2)
end

function Player:getX()
    return self.x
end

function Player:getY()
    return self.y
end

function Player:setX(x)
    self.x = x
end

function Player:setY(y)
    self.y = y
end

function Player:move(dt)
    if love.keyboard.isDown("a") and self.x > 0 then
        self:setX(self:getX() - self.speed * dt)
    end
    if love.keyboard.isDown("d") and self.x < WIDTH then
        self:setX(self:getX() + self.speed * dt)
    end
    if love.keyboard.isDown("w") and self.y > 0 then
        self:setY(self:getY() - self.speed * dt)
    end
    if love.keyboard.isDown("s") and self.y < HEIGHT then
        self:setY(self:getY() + self.speed * dt)
    end
end

function Player:setRotation(rot)
    self.rotation = rot
end

function Player:reset()
    self.x = WIDTH / 2
    self.y = HEIGHT / 2
    if self:isInjured() then
        self.speed = self.speed - 300
        self.injured = false
    end
end

function Player:activateInjured()
    self.injured = true
    self.speed = self.speed + 300
end

function Player:isInjured()
    return self.injured
end
