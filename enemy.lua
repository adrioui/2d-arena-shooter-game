-- Create a class
Enemy = Object:extend()

-- Initiate the enemy
function Enemy:new(x, y, width, height) 
    self.x = x
    self.y = y
    
    self.width = width
    self.height = height

    self.speed = 200
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
    table.insert(listOfBulletsFromEnemies, 
            Bullet((self.x + self.width/2), (self.y + self.height/2), player.angle, player.cos, player.sin))
    return true
end

-- Draw the enemy
function Enemy:draw(mode)
    love.graphics.rectangle(mode, self.x, self.y, self.width, self.height)
end
    