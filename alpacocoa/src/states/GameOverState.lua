GameOverState = {}

function GameOverState:enter()
   
    -- Create buttons

    -- Start button
    self.restart_button = Button('Click to restart!', 'medium')
    self.restart_button:set_text_color({1, 1, 1 ,1}, {171/255, 82/255, 54/255, 1})
    
    -- Quit button
    self.quit_button = Button("Quit game", 'medium')
    self.quit_button:set_text_color({1, 1, 1, 1}, {171/255, 82/255, 54/255, 1})
    

end

function GameOverState:update(dt)

end

function GameOverState:mousepressed(x, y, button)

    -- Start button pressed
    if self.restart_button:is_pressed() then
        StateManager:setState(MainCafeState)
    end

    -- Quit button pressed
    if self.quit_button:is_pressed() then
        love.event.quit()
    end

end

function GameOverState:draw()
    love.graphics.setColor(0, 0, 0, 0.75)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    -- Title logo    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(171/255, 82/255, 54/255, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 52, VIRTUAL_WIDTH, 'center')
    
    -- Draw select menus
    self.restart_button:draw(VIRTUAL_WIDTH / 2 - self.restart_button.width / 2, VIRTUAL_HEIGHT / 2 + 46)
    self.quit_button:draw(VIRTUAL_WIDTH / 2 - self.quit_button.width / 2, VIRTUAL_HEIGHT / 2 + 62)
end

return GameOverState