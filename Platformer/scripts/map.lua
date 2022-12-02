local sti  = require('libraries/Simple-Tiled-Implementation/sti/')
require('scripts.plataform')
require('scripts.enemy')

Map = {}

function Map:new(o, world)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.gameMap = nil
    self.world = world
    self.plataforms = {}
    self.enemy = Enemy:new(560, 100, world)

    return o
end

function Map:loadMap()
    self.gameMap = sti("maps/level1.lua")
    for i, obj in pairs(self.gameMap.layers["Plataforms"].objects) do
        local p = Plataform:new(obj.x, obj.y, obj.width, obj.height, self.world)
        table.insert(self.plataforms, p)
    end
end

function Map:update()
    self.gameMap:update()
end

function Map:drawLayer(layer)
    layer = layer or "Tile Layer 1"
    self.gameMap:drawLayer(self.gameMap.layers[layer])
end

function Map:enemiesDraw()
    self.enemy:draw()
end

function Map:enemiesUpdate(dt)
    self.enemy:move(dt)
    self.enemy.animation:update(dt)
end
