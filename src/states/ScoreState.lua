ScoreState = Class {__includes = BaseState}

bronze = love.graphics.newImage('/graphics/bronze_medal.png')
silver = love.graphics.newImage('/graphics/silver_medal.png')
gold = love.graphics.newImage('/graphics/gold_medal.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed ('enter') or love.keyboard.wasPressed ('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont (flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont (mediumFont)
    love.graphics.printf ('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf ('Medals:', 0, 130, VIRTUAL_WIDTH, 'center')
    if self.score >= 15 then
        love.graphics.draw (bronze, (VIRTUAL_WIDTH / 2) - (bronze:getWidth() / 2) - 50, (VIRTUAL_HEIGHT / 2) + 15, 0, 0.5, 0.5)
    end
    if self.score >= 30 then
        love.graphics.draw (silver, (VIRTUAL_WIDTH / 2) - (silver:getWidth() - 27), (VIRTUAL_HEIGHT / 2) + 15, 0, 0.5, 0.5)
    end
    if self.score >= 50 then
        love.graphics.draw (gold, (VIRTUAL_WIDTH / 2) - (gold:getWidth() / 2) + 60, (VIRTUAL_HEIGHT / 2) + 15, 0, 0.5, 0.5)
    end

    love.graphics.printf ('Press ENTER to Play Again!', 0, 230, VIRTUAL_WIDTH, 'center')
end