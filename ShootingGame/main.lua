require('love')
require('score')
require('timer')
require('target')
require('cursor')
require('scenario')
require('gamercontroller')
require('menu')
local utils = require('utils')

local gameFont = nil
local target = nil
local score = nil
local timer = nil
local cursor = nil
local scenario = nil
local gamerController = nil
local menu = nil

math.randomseed(os.time())
WIDTH = love.graphics.getWidth()
HEIGHT = love.graphics.getHeight()

-- Essential callbacks

function love.load()
    gameFont = love.graphics.newFont(40)
    gamerController = GamerController:new(nil)
    target = Target:new(nil, 200, 200, 50, "sprites/target.png")
    score = Score:new(nil, 0)
    timer = Timer:new(nil, 30)
    cursor = Cursor:new(nil, "sprites/crosshairs.png")
    scenario = Scenario:new(nil, "sprites/sky.png")
    menu = Menu:new(nil)
end

function love.update(dt)
    if (gamerController:getGameState() == 2) then
        timer:running(dt)

        -- End of the game
        if timer.actual_time <= 0 then
            timer:reset()
            gamerController:setGameState(1) -- Menu
        end
    end
end

function love.draw()
    love.graphics.setFont(gameFont)
    scenario:drawBackground()
    score:draw()
    timer:draw()
    if gamerController:getGameState() == 1 then
        menu:draw()
    elseif (gamerController:getGameState() == 2) then
        target:draw()
    end
    cursor:draw()
end


-- Other callbacks

function love.mousepressed(x, y, button)
    if (gamerController:getGameState() == 2) then
        if (button == 1 or button == 2) then
            if (utils.distanceBetween(x, y, target.x, target.y) <= target.radius) then
                score:hit(button)
                if button == 2 then
                    timer:decrease(1)
                end
                target:newSpawn()
            else
                score:miss()
            end
        end
    elseif gamerController:getGameState() == 1 then
        if (button == 1) then
            gamerController:setGameState(2)
            score:reset()
        end
    end

end
