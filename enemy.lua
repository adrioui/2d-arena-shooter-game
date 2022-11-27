-- Create a class
Enemy = Object:extend()

function Enemy:new(x, y) 
    self.x = x
    self.y = y
    
    self.width = 50
    self.height = 50

    self.speed = 200
end

function Enemy:update(dt, target_y, target_x)
    self.angle = math.atan2(target_y - self.y, target_x - self.x)
    
    self.cos = math.cos(self.angle)
    self.sin = math.sin(self.angle)

    self.x = self.x + self.speed * self.cos * dt
    self.y = self.y + self.speed * self.sin * dt
end

function Enemy:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
    