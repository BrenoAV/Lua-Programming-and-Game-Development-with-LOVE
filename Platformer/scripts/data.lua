-- I really don't like this way

require('libraries.show')

Data = {}

function Data:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.currentLevel = nil
    return o
end

function Data:save(currentLevel)
    self.currentLevel = currentLevel
    love.filesystem.write("data.lua", table.show(self, "saveData"))
end

function Data:load()
    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
        self.currentLevel = saveData.currentLevel
        return true
    else
        return false
    end
end
