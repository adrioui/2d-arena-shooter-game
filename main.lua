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
    timer:every(0.3, function() table.insert(listOfEnemies1, Enemy(math.random(0, window_width), 0, "static/enemy1.png")) end)
    timer:every(3, function() table.insert(listOfEnemies2, Enemy(math.random(0, window_width), 0, "static/enemy2.png")) end) 

    -- Load images
    background = love.graphics.newImage("static/background.png")
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
            player.health = player.health - 5
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
            -- Decrease the player's health
            player.health = player.health - 0.09
        end        --  
    end

    -- If the ship dies
    if player.health <= 0 then
        -- Restart the game
        love.load()
    end
end

function love.draw()
    -- Draw the background
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end

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

	-- Stamina bar
    love.graphics.print("Stamina: ", 10, 40)
    love.graphics.rectangle("line", 70, 43, 100, 10)
    love.graphics.rectangle("fill", 70, 43, player.stamina, 10)

    -- Health bar
    love.graphics.print("Health: ", 10, 70)
    love.graphics.rectangle("line", 70, 73, 100, 10)
    love.graphics.rectangle("fill", 70, 73, player.health, 10)
end