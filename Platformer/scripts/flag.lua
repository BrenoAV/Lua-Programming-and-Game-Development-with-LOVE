Flag = {}

function Flag:new(x, y, width, height, world)
    local o = {}

    setmetatable(o, self)
    self.__index = self

    o.x = x + width/2
    o.y = y + height/2
    o.world = world

    o.physics = {}
    o.physics.body = love.physics.newBody(world, o.x, o.y, "static")
    o.physics.shape = love.physics.newCircleShape(10)
    o.physics.fixture = love.physics.newFixture(o.physics.body,
        o.physics.shape, 1)
    o.physics.fixture:setUserData("Flag")

    return o
end
