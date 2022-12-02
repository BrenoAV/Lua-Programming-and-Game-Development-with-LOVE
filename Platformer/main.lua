require("scripts.player")
require("scripts.spike")
require("scripts.map")
Camera = require("libraries.hump.camera")

local world = nil
local player = nil
local spike = nil
local map = nil
local cam = nil

WIDTH = love.graphics.getWidth()
HEIGHT = love.graphics.getHeight()

function love.load()
    world = love.physics.newWorld(0, 2000, false)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    player = Player:new(nil, 200, 100, 40, 100, world)
    -- spike = Spike:new(nil, 0, HEIGHT - 20, WIDTH, 20, world)
    map = Map:new(nil, world)
    map:loadMap()
    cam = Camera()
end

function love.update(dt)
    world:update(dt)
    player:move(dt)
    player:animationUpdate(dt)
    map:update()
    map:enemiesUpdate(dt)

    local px, _ = player.physics.body:getPosition()
    cam:lookAt(px, HEIGHT / 2)
end

function love.draw()

    cam:attach()
        map:drawLayer()
        if not player:isDead() then
            player:draw()
        end
        map:enemiesDraw()
        debug()
    cam:detach()

    -- spike:draw()

end

function love.keypressed(key)
    if key == "w" then
        player:jump()
    end
end

function beginContact(a, b, coll)
    if a:getUserData() > b:getUserData() then a, b = b, a end
    if (a:getUserData() == "Player" and b:getUserData() == "Spike") then
        -- player:destroy()
    end
    if (a:getUserData() == "Plataform" and b:getUserData() == "Player") then
        player.isJumping = false
        player.isGrounded = true
    end
end

function endContact(a, b, coll)
    if a:getUserData() > b:getUserData() then a, b = b, a end
    if (a:getUserData() == "Plataform" and b:getUserData() == "Player") then
        player.isJumping = true
        player.isGrounded = false
    end
end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end

function debug()
    -- Debug
    -- love.graphics.line(360, 0, 360, HEIGHT)
    -- love.graphics.line(0, 100, WIDTH, 100)
    if love.keyboard.isDown("c") then
        for _, body in pairs(world:getBodies()) do
          for _, fixture in pairs(body:getFixtures()) do
              local shape = fixture:getShape()
              if shape:typeOf("CircleShape") then
                  local cx, cy = body:getWorldPoints(shape:getPoint())
                  love.graphics.circle("fill", cx, cy, shape:getRadius())
              elseif shape:typeOf("PolygonShape") then
                  love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
              else
                  love.graphics.line(body:getWorldPoints(shape:getPoints()))
              end
          end
        end
    end
end
