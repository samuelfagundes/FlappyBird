push = require 'libraries/push'

Class = require 'libraries/class'

require 'classes/Bird'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage ('sprites/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage ('sprites/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

function love.load ()
    love.graphics.setDefaultFilter ('nearest', 'nearest')

    math.randomseed (os.time ())

    love.window.setTitle ('Pássaro Flapolhas')

    push:setupScreen (VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = false,
        fullscreen = false,
        resizable = true
    })

end

function love.resize (w, h)
    push:resize (w, h)
end

function love.keypressed (key)
    if key == 'escape' then
        love.event.quit ()
    end
end

function love.update (dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end

function love.draw()
    push:start()

    love.graphics.draw (background, -backgroundScroll, 0)
    love.graphics.draw (ground, -groundScroll, VIRTUAL_HEIGHT - 16 )

    bird:render()

    push:finish()
end