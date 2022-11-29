require("scripts.player")
require("scripts.zombie")
require("scripts.bullet")
require("scripts.scenario")
require("scripts.gameController")
require("scripts.timer")
require("scripts.menu")
require("scripts.score")
local utils = require("scripts.utils")

local scenario = nil
local player = nil
local zombies = nil
local bullets = nil
local gameController = nil
local timer = nil
local menu = nil
local score = nil

math.randomseed(os.time())

WIDTH = love.graphics.getWidth()
HEIGHT = love.graphics.getHeight()

function love.load()
    menu = Menu:new(nil)
    gameController = GamerController:new(nil, 1)
    timer = Timer:new(nil, 2)
    score = Score:new(nil, 0)
    zombies = {}
    bullets = {}
    player = Player:new(nil, WIDTH / 2, HEIGHT / 2, 256, "sprites/player.png")
    scenario = Scenario:new(nil, "sprites/background.png")
end

function love.update(dt)
    if gameController:getGameState() == 2 then
        player:move(dt)
    end

    if gameController:getGameState() == 1 then
        for i,z in ipairs(zombies) do
            z.dead = true
        end
    end


    --[[
    ########################## ZOMBIE ##########################
    --]]
    for i,zombie in ipairs(zombies) do
        zombie:movement(player:getX(), player:getY(), dt)

        -- Collision Player
        if utils.distanceBetween(zombie:getX(),
                zombie:getY(),
                player:getX(),
                player:getY()) < 30 then
            for j,_ in ipairs(zombies) do
                table.remove(zombies, j)
                if player:isInjured() then
                    gameController:setGameState(1)
                else
                    player:activateInjured()
                end
            end
        end

        -- Collision Bullet
        for j,bullet in ipairs(bullets) do
            if utils.distanceBetween(zombie:getX(), zombie:getY(),
                    bullet:getX(),
                    bullet:getY()) < 20 then
                        zombie.dead = true
                        bullet.dead = true
                        score:hit(1)
            end
        end
    end



    --[[
    ########################## BULLET ##########################
    --]]
    for _, bullet in ipairs(bullets) do
        bullet:movement(dt)
    end

    -- remove bullets
    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b:getX() < 0 or b:getY() < 0 or b:getX() > WIDTH or b:getY() > HEIGHT then
            table.remove(bullets, i)
        end
    end


    -- Removing deaded objects
    for i=#zombies, 1, -1 do
        local zombie = zombies[i]
        if zombie:isDead() then
            table.remove(zombies, i)
        end
    end

    for i=#bullets, 1, -1 do
        local bullet = bullets[i]
        if bullet:isDead() then
            table.remove(bullets, i)
        end
    end

    if gameController:getGameState() == 2 then
        timer:runSpawnZombie(dt)
        if timer:getSpawnZombie() < 0 then
            local zombie = Zombie:new("sprites/zombie.png")
            table.insert(zombies, zombie)
            timer:resetSpawnZombie()
        end

    end


end

function love.draw()
    scenario:drawBackground()
    if gameController:getGameState() == 1 then
        menu:draw()
    end
    love.graphics.setColor(1, 1, 1)
    player:draw(love.mouse.getX(), love.mouse.getY())

    for _,zombie in ipairs(zombies) do
        zombie:draw(player:getX(), player:getY())
    end

    for _,bullet in ipairs(bullets) do
        bullet:draw()
    end

    score:draw()

end


function love.mousepressed(x, y, button)
    if (button == 1 and gameController:getGameState() == 2) then
        local bullet = Bullet:new(player:getX(), player:getY(), x, y,
            "sprites/bullet.png")
        table.insert(bullets, bullet)
    elseif (button == 1 and gameController:getGameState() == 1) then
        gameController:setGameState(2)
        timer:resetAll()
        player:reset()
        score:reset()
    end
end
