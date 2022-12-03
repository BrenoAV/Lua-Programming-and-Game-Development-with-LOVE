require("scripts.player")
require("scripts.spike")
require("scripts.map")
require("scripts.data")
require("scripts.audio")
Camera = require("libraries.hump.camera")

local world = nil
local player = nil
local spike = nil
local map = nil
local cam = nil
local data = nil
local audio = nil

WIDTH = love.graphics.getWidth()
HEIGHT = love.graphics.getHeight()

function love.load()
    world = love.physics.newWorld(0, 2000, false)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    spike = Spike:new(nil, -500, 800, 5000, 50, world)
    map = Map:new(nil, world)
    data = Data:new()
    if data:load() then
        map:loadMap(data.currentLevel)
    else
        map:loadMap("level1")
    end
    player = Player:new(nil, map.startPosX, map.startPosY, 40, 100, world)
    audio = Audio:new("audio/music.mp3", "audio/jump.wav")
    audio:start()
    cam = Camera()

end

function love.update(dt)
    world:update(dt)
    player:update(dt)
    map:update(dt)

    local px, _ = player.physics.body:getPosition()
    cam:lookAt(px, HEIGHT / 2)

    if map:getDestroyLevel() then
        if map.currentLevel == "level1" then
            map:loadMap("level2")
            -- true to change the start position using the level
            player:setPosition(map.startPosX, map.startPosY, true)
            data:save(map.currentLevel)
        elseif map.currentLevel == "level2" then
            map:loadMap("level1")
            player:setPosition(map.startPosX, map.startPosY, true)
            data:save(map.currentLevel)
        end
    end

end

function love.draw()
    map:drawBackground()
    cam:attach()
        map:drawLayer()
        map:drawEnemies()
        player:draw()
        debug()
    cam:detach()

    local mx, my = love.mouse.getPosition()
    love.graphics.print("x = " .. mx .. " | y = " .. my)

    -- spike:draw()

end

function love.keypressed(key)
    if key == "w" then
        player:jump()
        audio.sounds.jump:play()
    end
end

function beginContact(a, b, coll)
    if a:getUserData() > b:getUserData() then a, b = b, a end
    if (a:getUserData() == "Player" and b:getUserData() == "Spike") then
        player:gameOver()
    end
    if (a:getUserData() == "Plataform" and b:getUserData() == "Player") then
        player.isJumping = false
        player.isGrounded = true
    end
    if (a:getUserData() == "Enemy" and b:getUserData() == "Player") then
        player:gameOver()
    end
    if (a:getUserData() == "EndPoint" and b:getUserData() == "Enemy") then
        for i,e in ipairs(map.enemies) do
            if e.physics.fixture == b then
                e:changeDirection()
            end
        end
    end
    if (a:getUserData() == "Flag" and b:getUserData() == "Player") then
        map.destroyLevel = true
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
    local x, y = 199.66, 388
    -- love.graphics.line(x, 0, x, HEIGHT) -- Vertical
    -- love.graphics.line(0, y, WIDTH, y) -- Horizontal
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
