Spike = {}

function Spike:new(o, x, y, width, height, world)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.x = x + width / 2
    self.y = y + height / 2
    self.width = width
    self.height = height
    self.world = world

    self.physics = {}
    self.physics.body = love.physics.newBody(world, self.x, self.y, "static")
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body,
        self.physics.shape,
        1)
    self.physics.fixture:setCategory(3)
    self.physics.fixture:setUserData("Spike")

    return o
end

function Spike:draw()
    love.graphics.polygon(
        "fill",
        self.physics.body:getWorldPoints(self.physics.shape:getPoints())
        )
end
