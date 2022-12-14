local anim8 = require "libraries.anim8.anim8"
Player = {}

function Player:new(o, x, y, width, height, world)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.x = x + width / 2 -- Centralized
    self.y = y + height / 2 -- Centralized
    self.startPosX = self.x
    self.startPosY = self.y
    self.width = width
    self.height = height
    self.speed = 240
    self.world = world
    self.dead = false
    self.isGrounded = false
    self.isJumping = false
    self.isMoving = false
    self.direction = 1
    self.spriteSheet = love.graphics.newImage("sprites/playerSheet.png")
    self.grid = anim8.newGrid(614, 564,
        self.spriteSheet:getWidth(),
        self.spriteSheet:getHeight())
    self.animations = {}
    self.animations.idle = anim8.newAnimation(self.grid('1-15', 1), 0.05)
    self.animations.jump = anim8.newAnimation(self.grid('1-7', 2), 0.05)
    self.animations.run = anim8.newAnimation(self.grid('1-15', 3), 0.05)
    self.actualAnimation = self.animations.idle

    self.physics = {}
    self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body,
        self.physics.shape,
        1)

    self.physics.body:setFixedRotation(true)

    self.physics.fixture:setCategory(2)
    self.physics.fixture:setUserData("Player")
    self.physics.fixture:setMask(4) -- Platform's end points

    return o
end

function Player:update(dt)
    self:move(dt)
    self:animationUpdate(dt)
    if self.dead then
        self:setPosition(self.startPosX, self.startPosY, false)
        self.dead = false
    end
end

function Player:draw()
    local px, py = self.physics.body:getPosition()

    if self.isGrounded then
        if self.isMoving then
            self.actualAnimation = self.animations.run
        else
            self.actualAnimation = self.animations.idle
        end
    else
        if self.isJumping then
            self.actualAnimation = self.animations.jump
        end

    end

    self.actualAnimation:draw(self.spriteSheet, px, py, nil, self.direction*0.25,
        0.25, 130, 282)

end

function Player:animationUpdate(dt)
    self.actualAnimation:update(dt)
end

function Player:setPosition(x, y, startPos)
    self.physics.body:setPosition(x, y)
    if startPos then
        self.startPosX = x
        self.startPosY = y
    end
end

function Player:move(dt)
    local px, _ = self.physics.body:getPosition()
    self.isMoving = false
    if love.keyboard.isDown("a") then
        self.physics.body:setX(px - self.speed*dt)
        self.isMoving = true
        self.direction = -1
    end
    if love.keyboard.isDown("d") then
        self.physics.body:setX(px + self.speed*dt)
        self.isMoving = true
        self.direction = 1
    end
end

function Player:jump()
    if self.isGrounded and not self.isJumping then
        self.isJumping = true
        self.physics.body:applyLinearImpulse(0, -4000)
    end
end

function Player:gameOver()
    self.dead = true
end
