-- Originally by the author and I modified it to be able to add state stack

local GameStateManager = {
    currentState = nil,
    previousState = nil,
    stackState = {}
}

function GameStateManager:getPreviousState()
    return self.previousState
end

function GameStateManager:getState()
    return self.currentState
end

function GameStateManager:getStack()
    return self.stackState
end

function GameStateManager:setState(newState)
    assert(newState ~= nil, "newState does not exist.")
    assert(type(newState) == "table", "newState must be a table.")
    
    self.previousState = self.currentState
    self.currentState = newState

    if self.currentState and self.currentState.enter then
        -- Reset the state stack before entering new state
        self.stackState = {}
        self.currentState:enter()
    end
end

function GameStateManager:mousemoved(x, y, ...)
    if self.currentState and self.currentState.mousemoved then
        self.currentState:mousemoved(x, y)
    end

    -- Mousemoved every state in the stack
    if #self.stackState > 0 then
        for _, stackState in ipairs(self.stackState) do
            if stackState and stackState.mousemoved then
                stackState:mousemoved(x, y)
            end
        end
    end
end

function GameStateManager:wheelmoved(x, y, ...)
    if self.currentState and self.currentState.wheelmoved then
        self.currentState:wheelmoved(x, y)
    end

    -- Wheelmoved every state in the stack
    if #self.stackState > 0 then
        for _, stackState in ipairs(self.stackState) do
            if stackState and stackState.wheelmoved then
                stackState:wheelmoved(x, y)
            end
        end
    end
end

function GameStateManager:mousepressed(x, y, button)
    if self.currentState and self.currentState.mousepressed then
        self.currentState:mousepressed(x, y, button)
    end

    -- Mousepressed for every state in the stack
    for _, stackState in ipairs(self.stackState) do
        if stackState and stackState.mousepressed then
            stackState:mousepressed(x, y, button)
        end
    end
end

function GameStateManager:mousereleased(x, y, button)
    if self.currentState and self.currentState.mousereleased then
        self.currentState:mousereleased(x, y, button)
    end

    -- Mousereleased state in the stack
    if #self.stackState > 0 then
        for _, stackState in ipairs(self.stackState) do
            if stackState and stackState.mousereleased then
                stackState:mousereleased(x, y, button)
            end
        end
    end
end

function GameStateManager:keypressed(key, scancode, isrepeat)
    if self.currentState and self.currentState.keypressed then
        self.currentState:keypressed(key, scancode, isrepeat)
    end
   
    -- Keypressed for every state in the stack
    if #self.stackState > 0 then
        for _, stackState in ipairs(self.stackState) do
            if stackState and stackState.keypressed then
                stackState:keypressed(key, scancode, isrepeat)
            end
        end
    end
end

function GameStateManager:keyreleased(key, scancode)
    if self.currentState and self.currentState.keyreleased then
        self.currentState:keyreleased(key, scancode)
    end

    -- Keyreleased every state in the stack
    if #self.stackState > 0 then
        for _, stackState in ipairs(self.stackState) do
            if stackState and stackState.keyreleasea then
                stackState:keyreleased(key, scancode)
            end
        end
    end
end

function GameStateManager:wheelmoved(x, y)
    if self.currentState and self.currentState.wheelmoved then
        self.currentState:wheelmoved(x, y)
    end

    -- Wheelmoved for every state in the stack
    if #self.stackState > 0 then
        for _, stackState in ipairs(self.stackState) do
            if stackState and stackState.wheelmoved then
                stackState:wheelmoved(x, y)
            end
        end
    end
end

function GameStateManager:textinput(dt)
    if self.currentState and self.currentState.textinput then
        self.currentState:textinput(dt)
    end

    -- Textinput for every state in the stack
    if #self.stackState > 0 then
        for _, stackState in ipairs(self.stackState) do
            if stackState and stackState.textinput then
                stackState:textinput(dt)
            end
        end
    end
end

function GameStateManager:update(dt)
    if type(self.currentState) == "table" and self.currentState.update then
        self.currentState:update(dt)
    end

    -- Update every state in the stack
    if #self.stackState > 0 then
        for _, stackState in ipairs(self.stackState) do
            if type(stackState) == "table" and stackState.update then
                stackState:update(dt)
            end
        end
    end

end

function GameStateManager:quit()
    if self.currentState and self.currentState.quit then
        self.currentState:quit()
    end
end

function GameStateManager:draw()
    if self.currentState and self.currentState.draw then
        self.currentState:draw()
    end

    -- Draw every state in the stack
    if #self.stackState > 0 then
        for _, stackState in ipairs(self.stackState) do
            if stackState and stackState.draw then
                stackState:draw()
            end
        end
    end

end

-- Funcions for adding and removing state stack

function GameStateManager:addStack(newState, data)
    assert(newState ~= nil, "newState does not exist.")
    assert(type(newState) == "table", "newState must be a table.")

    -- Check if newStack already exists in self.stackState
    for _, stack in ipairs(self.stackState) do
        if stack == newState then
            -- For debugging
            print("The state is already on the stack.")
            return
        end
    end

    -- Insert new state into the stack and run enter()
    table.insert(self.stackState, newState)
    if newState.enter then
        newState:enter(data)
    end
end

function GameStateManager:removeStack(State)
    
    -- Check for empty stack
    if #self.stackState == 0 then
        print("The stack is empty.")
        return
    end

    -- Check to remove the same stack exists in self.stackState
    local state_existed = false

    for state, stack in ipairs(self.stackState) do
        if stack == State then
            
            if stack.quit then
                stack:quit()
            end

            table.remove(self.stackState, state)
            state_existed = true

        end
    end

    -- For debugging
    if not state_existed then
        print("The state is not on the stack.")
    end
end

return GameStateManager