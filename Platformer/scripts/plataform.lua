Plataform = {}

local function createEndPoint(x, y, world)
    local body = love.physics.newBody(world, x, y - 10, "static")
    local shape = love.physics.newRectangleShape(10, 10)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setCategory(4)
    fixture:setUserData("EndPoint")
    return body, shape, fixture
end

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
    o.physics.fixture:setCategory(3)

    -- Creating two rectangles on the left and right of the plataform
    o.endPoints = {}
    o.endPoints.left = {}
    o.endPoints.right = {}

    o.endPoints.left.body, o.endPoints.left.shape, o.endPoints.left.fixture = createEndPoint(x, y, world)

    o.endPoints.right.body, o.endPoints.right.shape, o.endPoints.right.fixture = createEndPoint(x + width, y, world)


    return o
end

function Plataform:destroy()
    self.endPoints.left.fixture:destroy()
    self.endPoints.right.fixture:destroy()
    self.physics.fixture:destroy()
    self = nil
end


function Plataform:draw()
    love.graphics.polygon(
        "fill",
        self.physics.body:getWorldPoints(self.physics.shape:getPoints())
        )
end
