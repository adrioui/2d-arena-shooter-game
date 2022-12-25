-- Create a class
Player = Object:extend()


function Player:new()
    -- Create an object
    -- Give it the properties
    self.x = 200
    self.y = 200

    self.width = 25
    self.height = 25

    self.angle = 0
    self.speed = 300

    -- Load the image
    self.image = love.graphics.newImage("static/player.png")
    self.origin_x = self.image:getWidth() / 2
    self.origin_y = self.image:getHeight() / 2

    -- Health and stamina
    self.health = 100
    self.stamina = 100
    
    -- Has stamina
    self.empty = false
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

        -- Decrease the stamina everytime the bullets are fired from player
        self.stamina = self.stamina - 4

        -- If there is stamina
        if self.stamina > 0 and self.empty == false then
            -- Set position for the three bullets
            bullet_positions = {100, 2.7, 1.5}
            for i,v in ipairs(bullet_positions) do
                -- Create three bullets with different positions
                table.insert(listOfBullets, Bullet((self.x + self.width/v), (self.y + self.height/v), 
                            self.angle, self.cos, self.sin, "static/player_bullet.png"))
            end
            
        -- If there is no stamina
        else
            -- Set the stamina to zero and empty the stamina
            self.stamina = 0
            self.empty = true
        end
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

    -- Move the ship
    self.x = self.x + self.speed * self.cos * (self.distance/150) * dt
    self.y = self.y + self.speed * self.sin * (self.distance/150) * dt

    -- If stamina is zero and empty
    if self.stamina == 0 and self.empty == true then
        -- For every half a second
        timer:every(0.5, function()
            -- If stamina is empty and not full 
            if self.stamina ~= 100 and self.empty == true then 
                -- Increase the stamina until it's full
                self.stamina = self.stamina + 0.5 
            -- If there is stamina
            else
                -- Stamina not empty
                self.empty = false
            end 
        end)             
    end
end

function Player:draw()
    -- Draw the ship
    love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.origin_x, self.origin_y)
end