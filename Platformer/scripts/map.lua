local sti  = require('libraries/Simple-Tiled-Implementation/sti/')
require('scripts.plataform')
require('scripts.enemy')
require('scripts.flag')

Map = {}

function Map:new(o, world)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.gameMap = nil
    self.world = world
    self.plataforms = {}
    self.enemies = {}
    self.flag = nil
    self.destroyLevel = false
    self.currentLevel = "level1"
    self.background = love.graphics.newImage("sprites/background.png")
    self.startPosX = nil
    self.startPoxY = nil

    return o
end

function Map:loadMap(mapName)
    self:destroyAll()
    self.destroyLevel = false
    self.currentLevel = mapName
    self.gameMap = sti("maps/" .. mapName .. ".lua")
    for i, obj in pairs(self.gameMap.layers["Plataforms"].objects) do
        local p = Plataform:new(obj.x, obj.y, obj.width, obj.height, self.world)
        table.insert(self.plataforms, p)
    end
    for i, obj in pairs(self.gameMap.layers["Enemies"].objects) do
        local e = Enemy:new(obj.x, obj.y, self.world)
        table.insert(self.enemies, e)
    end
    for i, obj in pairs(self.gameMap.layers["Flag"].objects) do
        self.flag = Flag:new(obj.x, obj.y, obj.width, obj.height, self.world)
    end
    for i, obj in pairs(self.gameMap.layers["Start"].objects) do
        self.startPosX = obj.x
        self.startPosY = obj.y
    end
end

function Map:update(dt)
    self.gameMap:update(dt)
    for _,e in pairs(self.enemies) do
        e:update(dt)
    end
end

function Map:drawLayer(layer)
    layer = layer or "Tile Layer 1"
    self.gameMap:drawLayer(self.gameMap.layers[layer])
end

function Map:drawEnemies()
    for _,e in pairs(self.enemies) do
        e:draw()
    end
end

function Map:drawBackground()
    love.graphics.draw(self.background)
end

function Map:destroyAll()
    local i = #self.plataforms
    while i > -1 do
        if self.plataforms[i] ~= nil then
            self.plataforms[i]:destroy()
            self.plataforms[i] = nil
        end
        table.remove(self.plataforms, i)
        i = i - 1
    end
    i = #self.enemies
    while i > -1 do
        if self.enemies[i] ~= nil then
            self.enemies[i]:destroy()
            self.enemies[i] = nil
        end
        table.remove(self.enemies, i)
        i = i - 1
    end
end

function Map:getDestroyLevel()
    return self.destroyLevel
end
