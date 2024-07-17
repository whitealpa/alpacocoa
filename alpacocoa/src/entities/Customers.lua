
--[[ Customer Generator ]]--

local function walk_in(self, dt)

    -- Disable the functin when customer is served
    if not self.is_served then

        -- Walk up to the turning point
        if self.y > self.customer_turning_point then
            self.y = self.y - CUSTOMER_WALK_SPEED * dt
        end

        if self.seat_number <= 4 then

            -- Walk to the seat
            if self.y <= self.customer_turning_point and self.x > TILE_SIZE * 3 + (self.seat_number * TILE_SIZE) then
                self.direction = 'left'
                self.x = self.x - CUSTOMER_WALK_SPEED * dt
            end

            
            -- Get into the seat
            if self.y <= self.customer_turning_point and self.x <= self.seat.x + (self.seat_number * TILE_SIZE) then
                self.direction = 'up'
                if self.y > self.seat.y then   
                    self.y = self.y - CUSTOMER_WALK_SPEED * dt
                end
            end

        -- Else if seat is on the right side
        elseif self.seat_number >= 5 then

            -- Walk to the seat
            if self.y <= self.customer_turning_point and self.x < TILE_SIZE * 3 + (self.seat_number * TILE_SIZE) then
                self.direction = 'right'
                self.x = self.x + CUSTOMER_WALK_SPEED * dt
            end

            -- Get into the seat
            if self.y <= self.customer_turning_point and self.x >= self.seat.x + (self.seat_number * TILE_SIZE) then
                if self.y > self.seat.y then
                    self.direction = 'up'
                    self.y = self.y - CUSTOMER_WALK_SPEED * dt
                end
            end
        end
        

        -- Trigger flag for order bubble after the customer is already seat
        if self.y <= self.seat.y then

            self.direction = 'idle'

            local delay = 0.5

            -- Run the timer
            if self.bubble_timer < delay then
                self.bubble_timer = self.bubble_timer + dt
                
                -- Delay 
                if self.bubble_timer >= delay then
                    gSounds['bubble']:play()
                    self.is_seat = true
                end

            end
        end
    end
end

local function walk_out(self, dt)

    -- Enable function when customer is served
    if self.is_served then

        self.direction = 'down'

        -- Walk down from seat
        if self.y <= self.customer_turning_point then
            self.y = self.y + CUSTOMER_WALK_SPEED * dt
        end

        -- Walk to the center
        -- If seat is on the left side
        if self.seat_number <= 4 then

            if self.y >= self.customer_turning_point and self.x <= TILE_SIZE * 8 - 8 then
                self.direction = 'right'
                self.x = self.x + CUSTOMER_WALK_SPEED * dt
            end

            -- Walk down off-screen
            if self.x >= TILE_SIZE * 8 - 8 and self.y < VIRTUAL_HEIGHT then
                self.direction = 'down'
                self.y = self.y + CUSTOMER_WALK_SPEED * dt
            end

        -- Else if seat is on the right side
        elseif self.seat_number >= 5 then
            if self.y >= self.customer_turning_point and self.x >= TILE_SIZE * 8 - 8 then
                self.direction = 'left'
                self.x = self.x - CUSTOMER_WALK_SPEED * dt
            end
        
            -- Walk down off-screen
            if self.x <= TILE_SIZE * 8 - 8 and self.y < VIRTUAL_HEIGHT then
                self.direction = 'down'
                self.y = self.y + CUSTOMER_WALK_SPEED * dt
            end
        end


        -- Flag customer has walked out after off-screen
        if self.y >= VIRTUAL_HEIGHT then
            self.is_walked_out = true
        end

    end
end

local function show_order(self)

    -- Only show order when customer is not yet served
    if self.is_seat and not self.is_served then
        love.graphics.setColor(1, 1, 1, 1)

        local color = 1
        if self.order_menu >= 4 then
            color = 2
        end

        love.graphics.draw(gTextures['order-bubble'], gFrames['order-bubble'][color], self.x + 6, self.y - 12)
    end
    
    -- Rectangle to debug bubble position
    --love.graphics.setColor(0, 0, 0, 1)
    --love.graphics.rectangle("line", self.x + 6, self.y - 12, 12, 12)

end

-- function to draw animation
local function animation(self, dt)

    local frame_rates = 5
    local frame_cycle = 4

    -- Only idle animation has lower frame_rates
    if self.direction == 'idle' then
        frame_rates = 2.5
    end

    -- Use timer to update frame according to frame_rates
    self.elasped_time = self.elasped_time + dt

    if self.elasped_time >= 1 / frame_rates then

        -- increase frame by 1 but loop the number between the frame_cycle
        self.frame = (self.frame  % frame_cycle) + 1
        
        -- Set invertal of 20 frame for each sprite color set
        self.frame = self.frame + (self.color * 20)
        
        if self.direction == 'down' then
            self.frame = self.frame + 4
        elseif self.direction == 'up' then
            self.frame = self.frame + 8
        elseif self.direction == 'left' then
            self.frame = self.frame + 12
        elseif self.direction == 'right' then
            self.frame = self.frame + 16
        end

        self.elasped_time = 0

    end
   


end

local function draw(self)

    -- Draw sprite
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures[self.sprite], gFrames[self.sprite][self.frame], self.x, self.y)

    -- Draw order when customer is seat.
    if self.is_seat and not self.is_served then
        self:show_order()
    end
    


end


-- Main function for customer generation
function Customer_generator()

    local customer = {
        sprite = 'alpa',
        color = math.random(1, 8),

        -- Positions
        x = TILE_SIZE * 8 - 8, 
        y = TILE_SIZE * 13,
        customer_turning_point = TILE_SIZE * 10 - 6,
        seat = {x = TILE_SIZE * 3, y = TILE_SIZE * 8 - 4},

        -- Random variables
        seat_number = nil, 
        order_menu = nil, 

        -- Flags
        is_seat = false,
        is_served = false,
        is_walked_out = false,

        -- Functions
        draw = draw,
        walk_in = walk_in,
        walk_out = walk_out,
        show_order = show_order,
        animation = animation,

        -- Update functions
        update = function(self, dt)
            self:walk_in(dt)
            self:walk_out(dt)
            self:animation(dt)
        end,

        -- Animation variables
        direction = 'up',
        frame = 1,
        elasped_time = 0,

        -- Various
        bubble_timer = 0,
    }

    -- Randomize the color

    -- Assign order menu from 8 total menus
    local order_menu = math.random(8)

    -- Assign seat
    local empty_seats = {}
    local seat_number = nil

    -- Look for all empty seats (false)
    for i = 1, #MainCafeState.seats do
        if not MainCafeState.seats[i] then
            table.insert(empty_seats, i)
        end
    end

    if #empty_seats > 0 then
        local i = math.random(#empty_seats)
        seat_number = empty_seats[i]
        MainCafeState.seats[seat_number] = true
    end

    if order_menu and seat_number then
        customer.order_menu = order_menu
        customer.seat_number = seat_number
        return customer
    else
        -- print("Tried to generate customer but no available seat.")
    end

end