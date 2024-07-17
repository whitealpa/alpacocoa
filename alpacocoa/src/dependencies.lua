
-- Libraries
push = require 'lib/push'
StateManager = require 'lib/gamestateManager'
require 'lib/Button'

-- Global constant variables
require 'src/constants'

-- Utilities
require 'src/Util'

-- Game States
require 'src/states/TitleScreenState'
require 'src/states/MainCafeState'
require 'src/states/DrinkMixingState'
require 'src/states/GameOverState'

-- Entities
require 'src/entities/Customers'

-- Ingredient
require 'src/ingredients'

-- Fonts
gFonts = {
    ['small'] = love.graphics.newFont('fonts/pico-8.ttf', 4),
    ['medium'] = love.graphics.newFont('fonts/pico-8.ttf', 8),
    ['large'] = love.graphics.newFont('fonts/pico-8.ttf', 20),
    ['drink-name'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['time-up'] = love.graphics.newFont('fonts/font.ttf', 24)
}
-- Set font filter
for font, _ in pairs(gFonts) do
    gFonts[font]:setFilter('nearest', 'nearest')
end

-- Arts
gTextures = {

    -- Background
    ['cafe-background'] = love.graphics.newImage('graphics/cafe_background.png'),
    ['black-mask'] = love.graphics.newImage('graphics/black_mask.png'),
    ['drink-mixing-panel'] = love.graphics.newImage('graphics/drink_mixing_panel.png'),
    ['ingredients'] = love.graphics.newImage('graphics/ingredients.png'),
    ['drinks'] = love.graphics.newImage('graphics/drinkicons.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['order-bubble'] = love.graphics.newImage('graphics/order_bubble.png'),

    -- character animation sprites
    ['alpa'] = love.graphics.newImage('graphics/alpa_sprite.png'),
}

gFrames = {
    ['ingredients'] = GenerateQuads(gTextures['ingredients'], 16, 16),
    ['drinks'] = GenerateQuads(gTextures['drinks'], 16, 16),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 8, 8),
    ['alpa'] = GenerateQuads(gTextures['alpa'], 16, 16),
    ['order-bubble'] = GenerateQuads(gTextures['order-bubble'], 16, 16)
}

-- Set image filter mode to avoid blurring effect
gTextures['alpa']:setFilter('nearest', 'nearest')
gTextures['drinks']:setFilter('nearest', 'nearest')
gTextures['hearts']:setFilter('nearest', 'nearest')
gTextures['order-bubble']:setFilter('nearest', 'nearest')

-- sound
gSounds = {
    ['water'] = love.audio.newSource('sounds/water.mp3', 'static'),
    ['milk'] = love.audio.newSource('sounds/milk.mp3', 'static'),
    ['ice'] = love.audio.newSource('sounds/ice.mp3', 'static'),
    ['sugar'] = love.audio.newSource('sounds/sugar.mp3', 'static'),
    ['cocoa'] = love.audio.newSource('sounds/cocoa.mp3', 'static'),

    ['yay'] = love.audio.newSource('sounds/yay.mp3', 'static'),
    ['yuck'] = love.audio.newSource('sounds/yuck.mp3', 'static'),

    ['button'] = love.audio.newSource('sounds/button.mp3', 'static'),
    ['bubble'] = love.audio.newSource('sounds/bubble.mp3', 'static'),
    ['mix-menu'] = love.audio.newSource('sounds/mixmenu.mp3', 'static'),
    ['remove'] = love.audio.newSource('sounds/remove.mp3', 'static'),
    ['coin'] = love.audio.newSource('sounds/coin.mp3', 'static'),
    ['times-up'] = love.audio.newSource('sounds/timesup.mp3', 'static'),

    --theme
    ['music'] = love.audio.newSource('sounds/alpacocoatheme.mp3', 'static')
}

-- loop theme music
gSounds['music']:setLooping(true)
gSounds['music']:setVolume(0.5)