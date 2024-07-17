require 'src/dependencies'

-- For pasuing the game
local isPaused = false

function love.load()
    love.window.setTitle('AlpaCocoa')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    -- Go to Title Screen when opened
    StateManager:setState(TitleScreenState)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)

    if not isPaused then
        StateManager:update(dt)

        -- Play theme music
        gSounds['music']:play()
    
        -- Track global mouse position and convert to push scale because the game uses mouse to play
        local mouse_x, mouse_y = love.mouse.getPosition()
        MX, MY = push:toGame(mouse_x, mouse_y)
    end

end

function love.mousepressed(x, y, button)
    if not isPaused then
     StateManager:mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if not isPaused then
     StateManager:mousereleased(x, y, button)
    end
end

function love.keypressed(key)

    -- Space bar pauses the game
    if key == "space" then
        if not isPaused then
            isPaused = true
        else
            isPaused = false
        end
    end
end

function love.draw()
    push:start()
    
    StateManager:draw()

    -- Show pause screen
    if isPaused then
        gSounds['music']:stop()

        love.graphics.setColor(0, 0, 0, 0.75)
        love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

        local text_height = gFonts['medium']:getHeight()

        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(1, 1, 1 ,1)
        love.graphics.printf("Game paused", 0, VIRTUAL_HEIGHT / 2 - text_height / 2, VIRTUAL_WIDTH, "center")
    end

    push:finish()
end