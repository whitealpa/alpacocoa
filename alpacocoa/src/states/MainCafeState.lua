MainCafeState = {}

function MainCafeState:enter()

    -- Create seat numbers
    self.seats = {}
    for i = 1, 8 do
        self.seats[i] = false
    end

    -- Customers
    self.customers = {}

    -- For customer interval generation
    self.customer_timer = 0
    self.customer_generate_interval = 1

    -- Various
    self.popularity = 5
    self.cash = 30

    self.game_is_over = false
    
end

function MainCafeState:update(dt)

    if not self.game_is_over then
        -- Capped self.popularity to 10
        self.popularity = math.min(self.popularity, 10)

        -- Generate customer every set interval
        self.customer_timer = self.customer_timer + dt

        if self.customer_timer >= self.customer_generate_interval then
            local customer = Customer_generator()
            table.insert(self.customers, customer)

            -- Customer generation rate depends on popularity
            local customer_generation_rate = {3, 7}

            if self.popularity == 10 then
                customer_generation_rate = {2, 4}
            elseif self.popularity >= 8 then
                customer_generation_rate = {3, 6}
            elseif self.popularity >= 6 and self.popularity < 8  then
                customer_generation_rate = {4, 8}
            elseif self.popularity >= 4 and self.popularity < 6 then
                customer_generation_rate = {5, 10}
            elseif self.popularity >= 2 and self.popularity < 4 then
                customer_generation_rate = {6, 10}
            else
                customer_generation_rate = {7, 10}
            end

            -- Reset timer and interval
            self.customer_timer = 0
            self.customer_generate_interval = math.random(customer_generation_rate[1], customer_generation_rate[2])
        end

        -- Update every customer in the table
        if #self.customers > 0 then
            for i = 1, #self.customers do
                self.customers[i]:update(dt)
            end
        end

        -- Check if game is over
        if self.popularity <= 0 or self.cash <= 0 then
            StateManager:addStack(GameOverState)
            self.game_is_over = true
        end
    end

end

function MainCafeState:mousepressed(x, y, button)

    if not self.game_is_over then

        -- Check for all customers
        if #self.customers > 0 then
            for i = 1, #self.customers do

                -- Run only when the customer is seat and drink mixning menu is not opened
                if self.customers[i].is_seat and not DrinkMixingState.is_open then

                    -- Activate when order bubble is clicked
                    if (MX >= self.customers[i].x + 6 and MX <= self.customers[i].x + 6 + 12 
                        and MY >= self.customers[i].y - 12 and MY <= self.customers[i].y)

                        -- or customer sprite is clicked
                        or (MX >= self.customers[i].x and MX <= self.customers[i].x + TILE_SIZE
                        and MY >= self.customers[i].y and MY <= self.customers[i].y + TILE_SIZE) then
                           
                            gSounds['mix-menu']:play()
                            gSounds['button']:play()
                            StateManager:addStack(DrinkMixingState, self.customers[i])
                    end

                end
            end
        end
    end

end

function MainCafeState:draw()

    -- Cafe background art
    love.graphics.draw(gTextures['cafe-background'], 0, 0)

    -- Draw alpa
    MainCafeState:draw_alpa_idle_animation(VIRTUAL_WIDTH / 2 - TILE_SIZE / 2, VIRTUAL_HEIGHT / 2 - TILE_SIZE / 2 - 9)

    -- Draw customers
    if #self.customers >= 0 then
        for i = 1, #self.customers do
            self.customers[i]:draw()
        end
    end 

    -- Shade to hide customer entering the shop
    love.graphics.draw(gTextures['black-mask'], 0, 0)

    -- Display money and popularity
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['small'])
    
    love.graphics.printf("Cash: " .. self.cash, TILE_SIZE * 3 + 2, TILE_SIZE + 2, VIRTUAL_WIDTH, 'left')
    
    love.graphics.printf("Popularity:", 0, TILE_SIZE + 2, VIRTUAL_WIDTH - (TILE_SIZE * 5.5) - 1, 'right')
    MainCafeState:draw_popularity_heart(VIRTUAL_WIDTH - 49 - (TILE_SIZE * 3), TILE_SIZE + 1)
  
end

function MainCafeState:draw_popularity_heart(x, y)

    -- The logic is to keep substracing the value by 2 (A full heart = 2 points)

    local pop_value = self.popularity

    for i = 1, 5 do

        if pop_value > 0 then

            -- If the value is still higher than 1 (more than a half heart), draw a full heart
            if pop_value > 1 then
                love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], x + (i * 8), y)
                pop_value = pop_value - 2
                pop_value = math.max(0, pop_value)

            -- If the value is equal to 1, draw a half heart, and change the value to 0
            -- Because it's not substractable by 2 anymore (no more heart left to draw)
            elseif pop_value == 1 then
                love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], x + (i * 8), y)
                pop_value = 0
            end
        
        -- If no more value is left to substract, draw an empty heart
        elseif pop_value == 0 then
            love.graphics.draw(gTextures['hearts'], gFrames['hearts'][3], x + (i * 8), y)
        end

    end
end

local elasped_time = 0
local frame = 1

function MainCafeState:draw_alpa_idle_animation(x, y)

    local number_of_frames = 2
    local frame_rates = 2.5

    local dt = love.timer.getDelta()
    elasped_time = elasped_time + dt
    
    if elasped_time >= 1 / frame_rates then
        frame = (frame % number_of_frames) + 1
        elasped_time = 0
    end

    love.graphics.draw(gTextures['alpa'], gFrames['alpa'][frame], x, y)

end
