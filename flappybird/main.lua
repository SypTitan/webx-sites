print("Started script")

print("window.link: "..window.link)

b64 = require("https://raw.githubusercontent.com/Reselim/Base64/master/Base64.lua")
ppm = require("https://raw.githubusercontent.com/SypTitan/webx-sites/main/flappybird/ppmlib.lua")
--ppm = require(window.link.."/ppmlib.lua")

local screen = get("screen")

local score_board = get("score")
local highscore_board = get("highscore")

local screen_width = 150
local screen_height = 200
local pipe_gap = 35
local pipe_width = 35
local buffered_click = false
local bird_size = 17
local bird_y = screen_height//3
local bird_dy = 0
local bird_grav = 2
local bird_max_grav = 6
local bird_jump = -4
local stop_game = true
local score = 0
local highscore = 0

function pipeCollision(pipe_x: number, pipe_height: number): boolean
    if (pipe_x < 15+bird_size and pipe_x+pipe_width > 15) then
        if (bird_y < pipe_height or bird_y+bird_size > pipe_height+pipe_gap) then
            return true
        end
    end
    return false
end

function tickGame(x: number, height: number)
    -- Setup pipe variables
    local current_pipe_width = math.min(pipe_width, screen_width-x, pipe_width+x)
    local current_x = math.max(1, x)
    
    -- Bird physics
    if buffered_click then
        buffered_click = false
        bird_dy = bird_jump
        else
            bird_dy = math.min(bird_max_grav, bird_dy+bird_grav)
        end
    bird_y = math.max(0, math.floor(bird_y+bird_dy))
    bird_y = math.min(screen_height-bird_size, bird_y)
    
    -- First part of rendering
    local data = ppm.fillTable(screen_width, screen_height, 3, 252, 236)
    ppm.setRectangleTable(data, current_x, 0, current_pipe_width, height, 0, 255, 0, screen_width, screen_height)
    ppm.setRectangleTable(data, current_x, height+pipe_gap, current_pipe_width, screen_height-(height+pipe_gap), 0, 255, 0, screen_width, screen_height)
    ppm.setRectangleTable(data, 15, bird_y, bird_size, bird_size, 255,215,0, screen_width, screen_height)
            
    -- Final rendering
    local final: string = table.concat(data, "\n")
    local to_encode = buffer.fromstring(final)
    local source = "data:image/x-portable-bitmap;base64," .. buffer.tostring(b64.encode(to_encode))
    screen.set_source(source)

    -- Game loop
    if (stop_game) then
        stop_game = false
        return 
    end
    if (bird_y+bird_size >= screen_height) then return end
    if (pipeCollision(x, height)) then return end
    if (x > 5-pipe_width) then
        set_timeout(function() tickGame(x-5, height) end, 50)
    else
        set_timeout(function() tickGame(screen_width-5, math.random(screen_height//25, screen_height-(screen_height//25)-pipe_gap)) end , 50)
        score += 1
        score_board.set_content("Score: "..score)
        if (score > highscore) then
            highscore = score
            highscore_board.set_content("Your highscore: "..highscore)
        end
    end
end

function startGame()
    stop_game = false
    score = 0
    score_board.set_content("Score: 0")
    tickGame(screen_width-3, math.random(screen_height//20, screen_height-(screen_height//20)-pipe_gap))
end

screen.set_source("data:image/x-portable-bitmap;base64," .. buffer.tostring(b64.encode(buffer.fromstring(ppm.fillFile(screen_width, screen_height, 3, 252, 236)))))

get("stop").on_click(function()
    stop_game = true
end)

get("start").on_click(function()
    if (stop_game) then
        startGame()
    else
        stop_game = true
        set_timeout(function() 
            startGame()
        end, 200)
    end
end)

get("jump").on_click(function() 
    buffered_click = true
end)

print("Ended scripted")