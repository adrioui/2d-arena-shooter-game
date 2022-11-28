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
    Object = require "library.classic"
    Timer = require "library.timer"
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
    listOfBulletsFromEnemies = {}

    -- Table for storing the enemies
    listOfEnemies1 = {}
    listOfEnemies2 = {}

    -- Create enemy of type 1 and type 2
    timer:every(1, function() table.insert(listOfEnemies1, Enemy(math.random(0, window_width), math.random(0, window_height), 35, 35)) end)
    timer:every(2, function() table.insert(listOfEnemies2, Enemy(math.random(player.x, window_width), math.random(player.y, window_height), 50, 50)) end) 
end

function love.keypressed(key)
    --Player pressed "space" key
    --Insert bullet to the table
    player:keyPressed(key)
end

function love.update(dt)
    -- Update the timer
    timer:update(dt)
    -- Update the player
    player:update(dt)

    -- For every bullet in the table
    for i,v in ipairs(listOfBullets) do
        -- Update the bullet
        v:update(dt)
        -- Check its collision with the window
        v:checkCollision(window_width, window_height) 
        
        -- For every enemy of type 1 in the table
        for j,k in ipairs(listOfEnemies1) do
            -- If enemy exists and the bullet and enemy collide
            if k ~= nil and checkCollision(v, k) then
                -- Make the enemy and bullet dissapear
                table.remove(listOfBullets, i)
                table.remove(listOfEnemies1, j)
            end
        end
    end

    -- For every enemy of type 1 in the table
    for i,v in ipairs(listOfEnemies1) do
        -- Move the enemy toward player
        v:update(dt, (player.y + player.height/2), (player.x + player.width/2))

        -- If the enemy and player collided
        if checkCollision(v, player) then
            -- Make the enemy dissapear
            table.remove(listOfEnemies1, i)
        end
    end
    
    -- For every enemy of type 2 in the table
    for i,v in ipairs(listOfEnemies2) do
        -- Move the enemy toward player
        v:update(dt, (player.y + player.height/2), (player.x + player.width/2))

        -- Shoot bullets
        v:shoot()

        -- Check collision
        if checkCollision(v, player) then
            -- Delete the enemy and the bullets
            table.remove(listOfEnemies2, i)
        end
    end  

    for i,v in ipairs(listOfBulletsFromEnemies) do
        v:update(dt)
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

    -- For every bullet from the enemy in the table
    for i,v in ipairs(listOfBulletsFromEnemies) do
        -- Draw the bullet
        v:draw()
    end

    -- For every bullet of type 1 in the table
    for i,v in ipairs(listOfEnemies1) do
        -- Draw the enemy
        v:draw("fill")
    end

    -- For every enemy of type 2 in the table
    for i,v in ipairs(listOfEnemies2) do
        -- Draw the enemy
        v:draw("line")
    end  
end
