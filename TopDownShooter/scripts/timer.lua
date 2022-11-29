Timer = {
    start_time = nil,
    actual_time = nil
}

function Timer:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.timerSpawnZombie = 2
    self.spawnZombie = self.timerSpawnZombie
    return o
end

function Timer:runSpawnZombie(dt)
    self.spawnZombie = self.spawnZombie - dt
end

function Timer:getSpawnZombie()
    return self.spawnZombie
end

function Timer:resetSpawnZombie()
    self.timerSpawnZombie = self.timerSpawnZombie * 0.95
    self.spawnZombie = self.timerSpawnZombie
end

function Timer:resetAll()
    self.timerSpawnZombie = 2
    self.spawnZombie = self.timerSpawnZombie
end
