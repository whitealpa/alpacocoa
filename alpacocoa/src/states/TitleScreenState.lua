TitleScreenState = {}

function TitleScreenState:enter()
   
    -- Create buttons

    -- Start button
    self.start_button = Button('Click here to start!', 'medium')
    self.start_button:set_text_color({1, 1 , 1, 1}, {171/255, 82/255, 54/255, 1})
    
    -- Quit button
    self.quit_button = Button("Quit game", 'medium')
    self.quit_button:set_text_color({1, 1, 1, 1}, {171/255, 82/255, 54/255, 1})
    

end

function TitleScreenState:update(dt)

end

function TitleScreenState:mousepressed(x, y, button)

    -- Start button pressed
    if self.start_button:is_pressed() then
        gSounds['button']:play()
        StateManager:setState(MainCafeState)
    end

    -- Quit button pressed
    if self.quit_button:is_pressed() then
        gSounds['button']:play()
        love.event.quit()
    end

end

function TitleScreenState:draw()
    -- Cafe background art
    love.graphics.draw(gTextures['cafe-background'], 0, 0)
    love.graphics.setColor(0, 0, 0, 0.75)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    -- Title logo    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('AlpaCocoa', 0, VIRTUAL_HEIGHT / 2 - (TILE_SIZE * 5) + 1, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(171/255, 82/255, 54/255, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('AlpaCocoa', 0, VIRTUAL_HEIGHT / 2 - (TILE_SIZE * 5), VIRTUAL_WIDTH, 'center')
    
    -- Draw select menus
    self.start_button:draw((VIRTUAL_WIDTH / 2 - self.start_button.width / 2) + 2, VIRTUAL_HEIGHT / 2 + (TILE_SIZE * 2) + 8)
    self.quit_button:draw((VIRTUAL_WIDTH / 2 - self.quit_button.width / 2) + 2, VIRTUAL_HEIGHT / 2 + (TILE_SIZE * 3) + 8)
end

return TitleScreenState