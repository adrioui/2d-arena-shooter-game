-- Create a class
Bullet = Object:extend()

-- Initialize the object
function Bullet:new(x, y, distance, cos, sin)
    -- The position
    self.x = x
    self.y = y

    -- The size of the bullet
    self.width = 5
    self.height = 5

    -- Give it velocity
    self.speed = 500

    -- Get the distance from the circle in which the bullet fired from  
    self.distance = distance

    -- Point the bullet to where the mouse cursor at
    self.dx = self.speed * cos
    self.dy = self.speed * sin
end

function Bullet:update(dt)
    -- Move the bullet
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

-- Function to check collision the bullet creates with the window
function Bullet:checkCollision(target_x, target_y)
    -- If collision happens, move the bullet to the opposite direction
    if self.x > target_x - self.width then
        self.x = target_x - self.width
        self.dx = -self.dx
    elseif self.x < self.width then
        self.x = self.width
        self.dx = -self.dx
    elseif self.y > target_y - self.height then
        self.y = target_y - self.height
        self.dy = -self.dy
    elseif self.y < self.height then
        self.y = self.height
        self.dy = -self.dy
    end
end

function Bullet:draw(mode)
    -- Draw the bullet
    love.graphics.rectangle(mode, self.x, self.y, self.width, self.height)
end