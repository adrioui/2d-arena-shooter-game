function love.load()
    -- Import the libraries
    Object = require "library.classic"
    Timer = require "library.timer"
    require "library.collision"
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
    timer:every(0.4, function() table.insert(listOfEnemies1, Enemy(math.random(0, window_width), math.random(0, window_height), 35, 35)) end)
    timer:every(0.4, function() table.insert(listOfEnemies2, Enemy(math.random(0, window_width), math.random(0, window_height), 50, 50)) end) 

    -- Count the collisions
    enemyAndPlayerCollisions = 0
    bulletAndPlayerCollisions = 0
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

        -- For every enemy of type 2 in the table
        for j,k in ipairs(listOfEnemies2) do
            -- If enemy exists and the bullet and enemy collide
            if k ~= nil and checkCollision(v, k) then
                -- Make the enemy and bullet dissapear
                table.remove(listOfBullets, i)
                table.remove(listOfEnemies2, j)
            end
        end
    end

    -- For every enemy of type 1 in the table
    for i,v in ipairs(listOfEnemies1) do
        -- Check collision between enemy of type 1 and prevent them from overlapping
        if listOfEnemies1[i + 1] ~= nil then
            for j=1, i do
                if listOfEnemies1[i] ~= nil and listOfEnemies1[j] ~= listOfEnemies1[i] then
                    rectCollision(listOfEnemies1[i], listOfEnemies1[j])
                    if xCollide and yCollide then
                        collisionRespo(listOfEnemies1[i], listOfEnemies1[j])
                    end
                end
            end
        end

        -- Move the enemy toward player
        v:update(dt, (player.y + player.height/2), (player.x + player.width/2))

        -- If the enemy and player collided
        if checkCollision(v, player) then
            -- Add one to the count of collision and make the enemy dissapear 
            enemyAndPlayerCollisions = enemyAndPlayerCollisions + 1
            table.remove(listOfEnemies1, i)
        end

        -- If the player and the enemy collide five times
        if enemyAndPlayerCollisions == 5 then
            -- Reload the game
            love.load()
        end
    end
    
    -- For every enemy of type 2 in the table
    for i,v in ipairs(listOfEnemies2) do
        -- Check collision between enemy of type 2 and prevent them from overlapping
        if listOfEnemies2[i + 1] ~= nil then
            for j=1, i do
                if listOfEnemies2[i] ~= nil and listOfEnemies2[j] ~= listOfEnemies2[i] then
                    rectCollision(listOfEnemies2[i], listOfEnemies2[j])
                    if xCollide and yCollide then
                        collisionRespo(listOfEnemies2[i], listOfEnemies2[j])
                    end
                end
            end
        end

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

    -- For every bullet from enemies
    for i,v in ipairs(listOfBulletsFromEnemies) do
        -- Move the bullets to the player
        v:update(dt)

        -- If the player collides with bullet
        if checkCollision(v, player) then
            -- Add the count
            bulletAndPlayerCollisions = bulletAndPlayerCollisions + 1
        end

        -- If the player hitted 400 times by the bullets
        if bulletAndPlayerCollisions == 400 then
            -- Restart the game
            love.load()
        end
    end
end

function love.draw()
    -- Draw the player
    player:draw()

    -- For every bullet in the table
    for i,v in ipairs(listOfBullets) do
        -- Draw the bullet
        v:draw("fill")
    end

    -- For every bullet from the enemy in the table
    for i,v in ipairs(listOfBulletsFromEnemies) do
        -- Draw the bullet
        v:draw("line")
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

    love.graphics.print(string.format("Enemy collisions: %d", enemyAndPlayerCollisions), 10, 10)    
    love.graphics.print(string.format("Bullet collisions: %d", bulletAndPlayerCollisions), 10, 30)    
end