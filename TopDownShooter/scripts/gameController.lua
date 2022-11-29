GamerController = {}

function GamerController:new(o, gameState)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.gameState = gameState
    return o
end

function GamerController:getGameState()
    return self.gameState
end

function GamerController:setGameState(x)
    self.gameState = x
end
