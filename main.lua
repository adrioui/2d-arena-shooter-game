function checkCollision(a, b)
    --With locals it's common usage to use underscores instead of camelCasing
    local a_left = a.x
    local a_right = a.x + a.width
    local a_top = a.y
    local a_bottom = a.y + a.height

    local b_left = b.x
    local b_right = b.x + b.width
    local b_top = b.y
    local b_bottom = b.y + b.height

    --Directly return this boolean value without using if-statement
    return  a_right > b_left
        and a_left < b_right
        and a_bottom > b_top
        and a_top < b_bottom
end

function love.load()
    -- Import the libraries
    Object = require "classic"
    Timer = require "timer"
    require "player"
    require "bullet"
    require"enemy"
    
    -- Create objects
    timer = Timer()
    player = Player()

    -- Get the size of the window
    window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

    -- Table for storing the bullets
    listOfBullets = {}

    -- Table for storing the enemies
    listOfEnemies = {}

    timer:every(0.2, function() table.insert(listOfEnemies, Enemy(math.random(0, window_width), math.random(0, window_height))) end)
end

function love.keypressed(key)
    --Player pressed "space" key
    --Insert bullet to the table
    player:keyPressed(key)    
end

function love.update(dt)
    -- Update the timer so the bullets can disappear
    timer:update(dt)
    -- Update the player
    player:update(dt)

    -- For every bullet in the table
    for i,v in ipairs(listOfBullets) do
        -- Update the bullet
        v:update(dt)
        -- Check its collision
        v:checkCollision(window_width, window_height) 
        
        for j,k in ipairs(listOfEnemies) do
            if k ~= nil and checkCollision(v, k) then
                table.remove(listOfBullets, i)
                table.remove(listOfEnemies, j)
            end
        end
    end

    -- For every enemy in the table
    for i,v in ipairs(listOfEnemies) do
        -- Update the enemy
        v:update(dt, (player.y + player.height/2), (player.x + player.width/2))

        if checkCollision(v, player) then
            table.remove(listOfEnemies, i)
        end
    end    
end

function love.draw()
    -- Draw the player
    player:draw()

    -- For every bullet in the table
    for i,v in ipairs(listOfBullets) do
        -- Draw the bullet
        v:draw()
    end

    -- For every bullet in the table
    for i,v in ipairs(listOfEnemies) do
        -- Draw the enemy
        v:draw()
    end
end
