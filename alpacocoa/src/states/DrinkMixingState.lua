DrinkMixingState = {
    is_open = false,
    x = TILE_SIZE,
    y = TILE_SIZE,
    width = TILE_SIZE * 14,
    height = TILE_SIZE * 8,

    menu = {
        [1] = 'Unsweetened Hot Cocoa',
        [2] = 'Hot Cocoa',
        [3] = 'Unsweetened Iced Cocoa',
        [4] = 'Iced Cocoa',
        [5] = 'Unsweetened Hot Milk Cocoa',
        [6] = 'Hot Milk Cocoa',
        [7] = 'Unsweetened Iced Milk Cocoa',
        [8] = 'Iced Milk Cocoa',
    },

    ingredient_list = {
        [1] = 'Cocoa + water',
        [2] = 'Cocoa + water + sugar',
        [3] = 'Cocoa + water + ice',
        [4] = 'Cocoa + water + ice + sugar',
        [5] = 'Cocoa + milk',
        [6] = 'Cocoa + milk + sugar',
        [7] = 'Cocoa + milk + ice',
        [8] = 'Cocoa + milk + ice + sugar',
    }

}

local cash_change = 10
local popularity_change = 1

function DrinkMixingState:enter(data)
    self.is_open = true
    self.customer = data

    --[[ For debugging
    self.customer = {}
    self.customer.order_menu = 1
    self.customer.seat_number = 1
    --]]

    -- Ingredient & Mixing stack
    self.mixing_stack = {}
    self.ingredients = Create_ingredients()

    -- Mixing timer
    self.mixing_timer = 5
    self.time_is_up = false

    -- Create buttons
    self.buttons = {}
    DrinkMixingState:create_button()

    -- Feedback timer
    self.drink_is_correct = false
    self.drink_is_wrong = false
    self.feedback_timer = 0
end

function DrinkMixingState:update(dt)

    -- Remove the stack immediately if game is over
    if MainCafeState.game_is_over then
        StateManager:removeStack(DrinkMixingState)
    end


    -- Run timer for mixing stack (time's up in 5)
    if not self.time_is_up then
        
        -- Stop timer when the drink is served
        if not self.drink_is_wrong and not self.drink_is_correct then
            self.mixing_timer = self.mixing_timer - dt
        end

        -- Lose cash and popularity if time's up
        if self.mixing_timer <= 0 then

            MainCafeState.cash = MainCafeState.cash - cash_change
            MainCafeState.popularity = MainCafeState.popularity - popularity_change

            gSounds['times-up']:play()
            
            self.time_is_up = true

        end
    end 


    -- Colorize 'serve' button when there's an ingredient in mixing stack
    if #self.mixing_stack > 0 then
        self.buttons['serve'].is_enabled = true
    end
    

    -- Timer for showing drink serving feedback
    if self.drink_is_correct or self.drink_is_wrong or self.time_is_up then
        self.feedback_timer = self.feedback_timer + dt
        
        -- Closing order and reset timer + flag after 1.2 second
        if self.feedback_timer > 1.2 then

            -- Reset state
            self.is_open = false
            self.feedback_timer = 0

            -- Reset seat and remove state from state stack
            self.customer.is_served = true
            MainCafeState.seats[self.customer.seat_number] = false
            StateManager:removeStack(DrinkMixingState)

        end
    end



end

function DrinkMixingState:mousereleased(x, y, button)
    
    -- For GUI buttons
    if self.buttons['serve']:is_pressed() and #self.mixing_stack > 0 then

       if not self.time_is_up then 

            -- Check for correct drink
            if DrinkMixingState:is_drink_correct(self.customer.order_menu, self.mixing_stack) then
                MainCafeState.cash = MainCafeState.cash + cash_change
                MainCafeState.popularity = MainCafeState.popularity + popularity_change

                gSounds['yay']:play()
                gSounds['coin']:play()

                self.drink_is_correct = true
            
            -- If the served drink is wrong
            else
                MainCafeState.cash = MainCafeState.cash - cash_change
                MainCafeState.popularity = MainCafeState.popularity - popularity_change

                gSounds['yuck']:play()

                self.drink_is_wrong = true
            end
        
        end
        
    end

end    

function DrinkMixingState:mousepressed(x, y, button)

    -- For ingredient icons
    if self.ingredients then
        for i, ingredient in ipairs(self.ingredients) do
            if ingredient:is_pressed() then

                if ingredient.name == "Water" then
                    gSounds['water']:play()
                elseif ingredient.name == "Milk" then
                    gSounds['milk']:play()
                elseif ingredient.name == "Ice" then
                    gSounds['ice']:play()
                elseif ingredient.name == "Cocoa" then
                    gSounds['cocoa']:play()
                elseif ingredient.name == "Sugar" then
                    gSounds['sugar']:play()
                end

                -- change position to avoid simultaneous mouse pressed
                ingredient.y = TILE_SIZE * 5

                table.insert(self.mixing_stack, ingredient)
                table.remove(self.ingredients, i)
            end
        end
    end

    -- For ingredient icons
    if self.mixing_stack then
        for i, mix in ipairs(self.mixing_stack) do
            if mix:is_pressed() then
                
                gSounds['remove']:stop()
                gSounds['remove']:play()

                -- change position to avoid simultaneous mouse pressed
                mix.y = TILE_SIZE * 7
                
                table.insert(self.ingredients, mix)
                table.remove(self.mixing_stack, i)
            end
        end
    end

end

function DrinkMixingState:draw()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['drink-mixing-panel'], 0, 0)

    -- Display order name
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts['drink-name'])
    love.graphics.printf(self.menu[self.customer.order_menu], 0, TILE_SIZE * 2 + 6, VIRTUAL_WIDTH, 'center')
  
    -- Drink icons
    love.graphics.setColor(1, 1, 1, 1) 
    love.graphics.draw(gTextures['drinks'], gFrames['drinks'][self.customer.order_menu], VIRTUAL_WIDTH / 2 - 8, TILE_SIZE * 3 + 3)
    
    -- Ingredient list
    --love.graphics.setColor(171/255, 82/255, 54/255, 1)
    love.graphics.printf(self.ingredient_list[self.customer.order_menu], 0, TILE_SIZE * 4 + 4, VIRTUAL_WIDTH, 'center')

    -- Mixing & Ingredient texts
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('Drink mix:', TILE_SIZE * 4 - 8, TILE_SIZE * 5 + 4, VIRTUAL_WIDTH)
    love.graphics.printf('Ingredients:', TILE_SIZE * 4 - 8 , TILE_SIZE * 7 + 4, VIRTUAL_WIDTH)


    -- Limit timer
    -- Blink the timer when timer is less than or equal to 3
    if self.mixing_timer <= 3 then
        local a = math.abs(math.cos(love.timer.getTime() * 2 % 2 * math.pi))
        -- Stop blinking when time is up
        if self.time_is_up or (self.drink_is_correct or self.drink_is_wrong) then
            a = 1
        end
        love.graphics.setColor(1, 0, 77/255, a)
    end
    love.graphics.printf('Time: ' .. string.format("%.1f", self.mixing_timer), (TILE_SIZE * 7) + (TILE_SIZE * 5 / 2) - TILE_SIZE - 4, TILE_SIZE * 6 + 4, VIRTUAL_WIDTH)


    -- Draw ingredients & mixing stack
    love.graphics.setColor(1, 1, 1, 1)
    -- Mixing
    if self.mixing_stack then
        for i, mix in pairs(self.mixing_stack) do
            
            -- Variables used to dynamically center-align the icons in the mixing stack
            local stack_width = TILE_SIZE * 5
            local stack_x = TILE_SIZE * 7
            local center_offset = (stack_width / 2 - (TILE_SIZE * #self.mixing_stack) / 2)
            local icon_x = (TILE_SIZE * i) - TILE_SIZE

            mix.x = stack_x + center_offset + icon_x

            love.graphics.draw(gTextures['ingredients'], self.mixing_stack[i].frame, mix.x, mix.y)
        end
    end

    -- Ingredient
    if self.ingredients then
        for i, ingredient in pairs(self.ingredients) do
            ingredient.x = TILE_SIZE * (6 + ingredient.index) 
            ingredient.y = TILE_SIZE * 7
            love.graphics.draw(gTextures['ingredients'], self.ingredients[i].frame, ingredient.x, ingredient.y)
        end
    end

    -- Correct drink
    if self.drink_is_correct then
        DrinkMixingState:feedback_label("Yay!", {1, 1, 1, 1}, {0/255, 228/255, 54/255})
    end
    
    -- Wrong drink
    if self.drink_is_wrong then
        DrinkMixingState:feedback_label("Yuck!", {1, 1, 1, 1}, {1, 0, 77/255, 1})
    end

    -- Time's up; display time's up label
    if self.time_is_up then
        DrinkMixingState:feedback_label("Time's up!", {1, 1, 1, 1}, {1, 163/255 , 0, 1})
    end

    -- Buttons
    self.buttons['serve']:draw()

end

function DrinkMixingState:create_button()

    -- Serve button
    local serve_button = Button('Serve!', 'medium')
    serve_button:set_text_color({1, 1, 1, 1}, {0, 0, 0, 1})
    serve_button:set_backgrounnd_color({126/255, 37/255, 83/255, 1}, {1, 0, 77/255, 1})
    serve_button.x = VIRTUAL_WIDTH / 2 - serve_button.width / 2
    serve_button.y = TILE_SIZE * 9 - 6
    serve_button.is_enabled = false

    -- Insert into a table with key-value pairs
    self.buttons['serve'] = serve_button

end

function DrinkMixingState:is_drink_correct(order_number, drink_mix)

    local order_keys = {
        [1] = 'cw',
        [2] = 'csw',
        [3] = 'ciw',
        [4] = 'cisw',
        [5] = 'cm',
        [6] = 'cms',
        [7] = 'cim',
        [8] = 'cims'
    }
    local drink_keys = {}

    -- Sort the key from mixing stack
    for i = 1, #drink_mix do
        table.insert(drink_keys, drink_mix[i].id)
    end
    table.sort(drink_keys)
    local sorted_drink_keys = table.concat(drink_keys)

    -- Compare order_keys to sorted_drink_keys
    if order_keys[order_number] == sorted_drink_keys then
        return true
    else
        return false
    end

end

function DrinkMixingState:feedback_label(text, text_color, background_color)

    local height = gFonts['time-up']:getHeight()        
    local mixing_screen_height = TILE_SIZE + DrinkMixingState.height 

    -- Background
    love.graphics.setColor(background_color)
    love.graphics.rectangle("fill", 0, (mixing_screen_height / 2 - height / 2) + TILE_SIZE * 2 - 7, VIRTUAL_WIDTH, height + (2 * 2))
    
    -- Text
    love.graphics.setFont(gFonts['time-up'])
    gFonts['time-up']:setFilter('nearest', 'nearest')
    love.graphics.setColor(text_color)
    love.graphics.printf(text, 0, (mixing_screen_height / 2 - height / 2) + TILE_SIZE * 2 - 5, VIRTUAL_WIDTH, "center")

end

return DrinkMixingState




