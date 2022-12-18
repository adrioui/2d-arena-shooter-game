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

function rectCollision(r1, r2)
    xCollide,yCollide = false
	prev_x_col,prev_y_col = false

    if not xCollide or not yCollide then
        prev_x_col = xCollide
        prev_y_col = yCollide
    end
    
    if r1.x < r2.x + r2.width and r1.x + r1.width > r2.x then 
        xCollide = true
    else 
        xCollide = false
    end
    
    if r1.y < r2.y + r2.height and r1.y + r1.height > r2.y then 
        yCollide = true
    else 
        yCollide = false
    end
end

function collisionRespo(r1, r2)
    r1_center_x = r1.x + r1.width * 0.5
    r1_center_y = r1.y + r1.height * 0.5
    r2_center_x = r2.x + r2.width * 0.5
    r2_center_y = r2.y + r2.height * 0.5
    
    if not prev_x_col and not prev_y_col then
        avgWidth = (r1.width + r2.width) * 0.5
        avgHeight = (r1.height + r2.height) * 0.5
        dst_x = math.abs(r1_center_x - r2_center_x)
        dst_y = math.abs(r1_center_y - r2_center_y)
        overlap_x = avgWidth - dst_x
        overlap_y = avgHeight - dst_y

        if overlap_x > overlap_y then
            prev_x_col = true
        else 
            prev_y_col = true
        end
    end
    
    if prev_x_col then
        if r1_center_y < r2_center_y then
          r1.y = r2.y - r1.height + 3
        else
          r1.y = r2.y + r2.height + 3 
        end

    elseif prev_y_col then
        if r1_center_x < r2_center_x then
            r1.x = r2.x - r1.width
        else
            r1.x = r2.x + r2.width
        end
    end
end