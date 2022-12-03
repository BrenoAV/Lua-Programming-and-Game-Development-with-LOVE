Audio = {}

function Audio:new(backgroundMusic, jumpMusic)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.sounds = {}
    o.sounds.music = love.audio.newSource(backgroundMusic, "stream")
    o.sounds.jump = love.audio.newSource(jumpMusic, "static")

    return o
end

function Audio:start()
    self.sounds.music:setLooping(true)
    self.sounds.music:setVolume(0.3)
    self.sounds.music:play()
end
