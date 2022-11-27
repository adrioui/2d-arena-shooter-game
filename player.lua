-- Create a class
Player = Object:extend()


function Player:new()
    -- Create an object
    -- Give it the properties x, y, radius and speed
    self.x = 100
    self.y = 500

    self.width = 25
    self.height = 25

    self.speed = 200
end

-- Get the distance from the circle to the mouse cursor using pythagorean theorem
-- Use hypotenuse as the distance
function Player:getDistance(x1, y1, x2, y2)
    -- Get the horizontal and vertical distance
    local horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2

    -- Calculate the legs of the triangle to get the hypotenuse squared
    local a = horizontal_distance^2
    local b = vertical_distance^2
    local c = a + b

    -- Hypotenuse
    local distance = math.sqrt(c)
    
    -- Return the distance
    return distance
end

function Player:keyPressed(key)
    -- If the spacebar is pressed
    if key == "space" then
        -- Put a new instance of Bullet inside listOfBullets
        -- Fire the bullets from the center of the character
        table.insert(listOfBullets, Bullet((self.x + self.width/2), (self.y + self.height/2), self.angle, self.cos, self.sin))
    end
end

function Player:update(dt)
    -- love.mouse.getPosition returns the x and y position of the cursor
    mouse_x, mouse_y = love.mouse.getPosition()

    -- Get the angle
    self.angle = math.atan2(mouse_y - self.y, mouse_x - self.x)
    
    -- Calculate the sin and cos from the angle to be able to move the circle towards the mouse  
    self.sin = math.sin(self.angle)
    self.cos = math.cos(self.angle)
    
    -- Get the distance between the circle and the mouse
    self.distance = Player:getDistance(self.x, self.y, mouse_x, mouse_y)

    -- Move the circle
    self.x = self.x + self.speed * self.cos * (self.distance/150) * dt
    self.y = self.y + self.speed * self.sin * (self.distance/150) * dt
end

function Player:draw()
    -- Draw a rectangle
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- Draw a right triangle
    love.graphics.line((self.x + self.width/2), (self.y + self.height/2), mouse_x, (self.y + self.height/2))
    love.graphics.line((self.x + self.width/2), (self.y + self.height/2), mouse_x, mouse_y)
    love.graphics.line(mouse_x, (self.y + self.height/2), mouse_x, mouse_y)

    -- -- Draw the outside circle with the distance as its radius
    love.graphics.circle("line", (self.x + self.width/2), (self.y + self.height/2), self.distance)
end