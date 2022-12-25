-- Create a class
Enemy = Object:extend()

-- Initiate the enemy
function Enemy:new(x, y, image) 
    self.x = x
    self.y = y
    
    self.speed = 200

    self.image = love.graphics.newImage(image)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.origin_x = self.width / 2
    self.origin_y = self.height / 2
end

-- Credit to someone in stackoverflow
-- Make the enemy moves toward its target
function Enemy:update(dt, target_y, target_x)
    self.angle = math.atan2(target_y - self.y, target_x - self.x)
    
    self.cos = math.cos(self.angle)
    self.sin = math.sin(self.angle)

    self.x = self.x + self.speed * self.cos * dt
    self.y = self.y + self.speed * self.sin * dt
end

-- Enemy shoot bullet
function Enemy:shoot()
    table.insert(listOfBulletsFromEnemies, Bullet((self.x + self.width/2), (self.y + self.height/2), 
    self.angle, self.cos, self.sin, "static/enemy_bullet.png"))
end

-- Draw the enemy
function Enemy:draw(mode)
    love.graphics.draw(self.image, self.x, self.y, self.angle, 2, 2, self.origin_x, self.origin_y)
end
    