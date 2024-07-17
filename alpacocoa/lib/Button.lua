
--[[ My own button framework

    Use Botton() to create by returning a button object table

    button:draw(x, y) to draw button on screen
    
    button:set_text_color(color, hover_color) to set text and text hover colors
    button:set_backgrounnd_color(color, hover_color) to set background and background hover colors

    button:is_pressed() to check for mouse pressed

--]]

--Function to draw button
local function draw_button_function(self, x, y)
    
    if x then
        self.x = x
    end
    
    if y then
        self.y = y
    end

    -- Use rectangle to debug button position
    --love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- If button is enabled
    if self.is_enabled then

    -- Draw background
        if MX >= self.x and MX <= self.x + self.width and MY >= self.y and MY <= self.y + self.height then
            love.graphics.setColor(self.hover_bg_color)
        else
            love.graphics.setColor(self.bg_color) 
        end
        
        local padding = 2
        love.graphics.rectangle("fill", self.x - padding, self.y - padding, self.width, self.height + (padding * 2))
        
        -- Draw text
        if MX >= self.x and MX <= self.x + self.width and MY >= self.y and MY <= self.y + self.height then
            love.graphics.setColor(self.hover_text_color)
        else
            love.graphics.setColor(self.text_color) 
        end

    -- if button is not enabled (grayed out)
    else
    -- Draw background
        if MX >= self.x and MX <= self.x + self.width and MY >= self.y and MY <= self.y + self.height then
            love.graphics.setColor({0.5, 0.5, 0.5, 0.5})
        else
            love.graphics.setColor({0.5, 0.5, 0.5, 0.5}) 
        end
        
        local padding = 2
        love.graphics.rectangle("fill", self.x - padding, self.y - padding, self.width, self.height + (padding * 2))
        
        -- Draw text
        if MX >= self.x and MX <= self.x + self.width and MY >= self.y and MY <= self.y + self.height then
            love.graphics.setColor({1, 1, 1, 0.7})
        else
            love.graphics.setColor({1, 1, 1, 0.7}) 
        end
    end

    love.graphics.setFont(gFonts[self.font_size])
    love.graphics.printf(self.text, self.x, self.y, VIRTUAL_WIDTH)

end

-- Function to set text color
local function set_text_color_function(self, color, hover_color)
    if color then
        self.text_color = color
    end
    
    if hover_color then
        self.hover_text_color = hover_color
    end
end

-- Function to set background color
local function set_backgrounnd_color_function(self, color, hover_color)
    if color then
        self.bg_color = color
    end

    if hover_color then
        self.hover_bg_color = hover_color
    end
    
end

-- Function to check for mouse pressed
local function is_pressed_function(self)
    if self.x and self.y then
        if MX >= self.x and MX <= self.x + self.width 
        and MY >= self.y and MY <= self.y + self.height then
            return true
        end
        return false    
    end   
end

-- Main function to create button
function Button(text, font_size, text_color, hover_text_color, bg_color, hover_bg_color)

    -- Return a table with calculated width and height
    local button = {
        name = nil,
        text = text,
        font_size = font_size,

        -- Calculating button size
        width = gFonts[font_size]:getWidth(text), 
        height = gFonts[font_size]:getHeight(),

        -- Text color data (default to white and half transparent)
        text_color = text_color or {1, 1, 1, 1},
        hover_text_color = hover_text_color or {1, 1, 1, 0.5},

        set_text_color = set_text_color_function,

        -- Background color data (default to transparent)
        bg_color = bg_color or {1, 1, 1, 0},
        hover_bg_color = hover_bg_color or {1, 1, 1, 0},

        set_backgrounnd_color = set_backgrounnd_color_function,
        
        -- X, Y position
        x = nil,
        y = nil,

        -- Detect mouse pressed
        is_pressed = is_pressed_function,
        
        -- Draw the button
        draw = draw_button_function,
        is_enabled = true   -- if false, the button grayed out
     }

    return button
end