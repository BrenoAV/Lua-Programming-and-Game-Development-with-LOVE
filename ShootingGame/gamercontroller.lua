GamerController = {
    gameState = 1 -- 1 -> menu | 2 -> game
}

function GamerController:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.gameState = 1
    return o
end

function GamerController:getGameState()
    return self.gameState
end

function GamerController:setGameState(gameState)
    self.gameState = gameState
end
