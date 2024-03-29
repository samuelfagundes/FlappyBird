push = require 'lib/push'
Class = require 'lib/class'

require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/CountdownState'
require 'src/states/PlayState'
require 'src/states/ScoreState'
require 'src/states/TitleScreenState'

require 'src/Bird'
require 'src/Pipe'
require 'src/PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage ('graphics/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage ('graphics/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

function love.load ()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed (os.time ())

    love.window.setTitle ('Fifty Bird')

    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }

    sounds['music']:setVolume(0.1)
    sounds['explosion']:setVolume(0.1)
    sounds['score']:setVolume(0.1)
    sounds['jump']:setVolume(0.1)
    sounds['hurt']:setVolume(0.1)

    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen (VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = false,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}

    love.mouse.buttonsPressed = {}
end

function love.resize (w, h)
    push:resize (w, h)
end

function love.keypressed (key)
    love.keyboard.keysPressed [key] = true

    if key == 'escape' then
        love.event.quit ()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed (key)
    return love.keyboard.keysPressed [key]
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed [button]
end

function love.update (dt)
    if pause == false then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    else
        backgroundScroll = (backgroundScroll + 0 * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + 0 * dt) % VIRTUAL_WIDTH
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw (background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw (ground, -groundScroll, VIRTUAL_HEIGHT - 16 )

    push:finish()
end