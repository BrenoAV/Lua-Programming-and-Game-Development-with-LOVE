Plataform = {}

function Plataform:new(x, y, width, height, world)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.x = x + width / 2
    o.y = y + height / 2
    o.width = width
    o.height = height
    o.world = world

    o.physics = {}
    o.physics.body = love.physics.newBody(world, o.x, o.y, "static")
    o.physics.shape = love.physics.newRectangleShape(o.width, o.height)
    o.physics.fixture = love.physics.newFixture(o.physics.body,
        o.physics.shape,
        1)
    o.physics.fixture:setUserData("Plataform")

    return o
end

function Plataform:draw()
    love.graphics.polygon(
        "fill",
        self.physics.body:getWorldPoints(self.physics.shape:getPoints())
        )
end
