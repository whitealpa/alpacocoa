--[[ Use for ingredient icons ]] --

-- Function to checck for mouse pressed
local function is_pressed_function(self)

    if self.x and self.y then
        if MX >= self.x and MX <= self.x + TILE_SIZE 
        and MY >= self.y and MY <= self.y + TILE_SIZE then
            return true
        end
        return false    
    end   
end

function Create_ingredients()

    -- Create ingredient objects and insert into a table
    local cocoa = {
        index = 1,
        name = 'Cocoa',
        id = 'c',
        frame = gFrames['ingredients'][1],
        x = 0,
        y = 0,
        is_pressed = is_pressed_function
    }

    local water = {
        index = 2,
        name = 'Water',
        id = 'w',
        frame = gFrames['ingredients'][2],
        x = 0,
        y = 0,
        is_pressed = is_pressed_function
    }

    local ice = {
        index = 3,
        name = 'Ice',
        id = 'i',
        frame = gFrames['ingredients'][3],
        x = 0,
        y = 0,
        is_pressed = is_pressed_function
    }

    local sugar = {
        index = 4,
        name = 'Sugar',
        id = 's',
        frame = gFrames['ingredients'][4],
        x = 0,
        y = 0,
        is_pressed = is_pressed_function
    }
    
    local milk = {
        index = 5,
        name = 'Milk',
        id = 'm',
        frame = gFrames['ingredients'][5],
        x = 0,
        y = 0,
        is_pressed = is_pressed_function
    }

    return {cocoa, water, ice, sugar, milk}

end