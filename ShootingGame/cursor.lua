Cursor = {
    sprite = nil
}

function Cursor:new(o, spriteFilename)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   love.mouse.setVisible(false)
   self.sprite = love.graphics.newImage(spriteFilename)
   return o
end

function Cursor:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.sprite,
                       love.mouse:getX() - self.sprite:getWidth() / 2,
                       love.mouse:getY() - self.sprite:getHeight() / 2)
end
