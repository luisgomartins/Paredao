-- paredao.lua
-- Reimplementação do "Paredão" do Telejogo Philco (1977)

--tabela original:
local LARGURA, ALTURA   = 800, 600
local BOLA_VEL          = 350
local RAQUETE_VEL       = 400
local RAQUETE_H         = 100
local RAQUETE_W         = 15
local BOLA_SIZE         = 15
local PAREDE_W          = 20

local bola, raquete, pontos, gameOver

function love.load()
    love.window.setTitle("Paredão")
    love.window.setMode(LARGURA, ALTURA)
    reiniciar()
end

function reiniciar()
    bola = {
        x  = LARGURA / 2,
        y  = ALTURA  / 2,
        vx = -BOLA_VEL,
        vy = BOLA_VEL * (math.random() > 0.5 and 1 or -1)
    }
    raquete = { x = 30, y = ALTURA / 2 - RAQUETE_H / 2 }
    pontos  = 0
    gameOver = false
end

function love.update(dt)
    if gameOver then return end

    -- Movimento da raquete
    if love.keyboard.isDown("up",   "w") then raquete.y = raquete.y - RAQUETE_VEL * dt end
    if love.keyboard.isDown("down", "s") then raquete.y = raquete.y + RAQUETE_VEL * dt end
    raquete.y = math.max(0, math.min(ALTURA - RAQUETE_H, raquete.y))

    -- Movimento da bola
    bola.x = bola.x + bola.vx * dt
    bola.y = bola.y + bola.vy * dt

    -- Rebate no teto e no chão
    if bola.y <= 0 then
        bola.y  = 0
        bola.vy = -bola.vy
    elseif bola.y + BOLA_SIZE >= ALTURA then
        bola.y  = ALTURA - BOLA_SIZE
        bola.vy = -bola.vy
    end

    -- Rebate no paredão (parede direita)
    if bola.x + BOLA_SIZE >= LARGURA - PAREDE_W then
        bola.x  = LARGURA - PAREDE_W - BOLA_SIZE
        bola.vx = -bola.vx
        pontos  = pontos + 1
    end

    -- Colisão com a raquete
    if bola.x <= raquete.x + RAQUETE_W
    and bola.x + BOLA_SIZE >= raquete.x
    and bola.y + BOLA_SIZE >= raquete.y
    and bola.y <= raquete.y + RAQUETE_H then
        bola.x  = raquete.x + RAQUETE_W
        bola.vx = -bola.vx
    end

    -- Bola saiu pela esquerda: fim de jogo
    if bola.x < 0 then
        gameOver = true
    end
end

function love.draw()
    if gameOver then
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.printf("FIM DE JOGO", 0, 250, LARGURA, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Pontos: " .. pontos, 0, 300, LARGURA, "center")
        love.graphics.printf("Pressione R para jogar novamente", 0, 350, LARGURA, "center")
        return
    end

    -- Paredão (parede direita)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle("fill", LARGURA - PAREDE_W, 0, PAREDE_W, ALTURA)

    -- Raquete
    love.graphics.setColor(0.3, 0.6, 1)
    love.graphics.rectangle("fill", raquete.x, raquete.y, RAQUETE_W, RAQUETE_H)

    -- Bola
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", bola.x, bola.y, BOLA_SIZE, BOLA_SIZE)

    -- Placar
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("Pontos: " .. pontos, 10, 10)
end

function love.keypressed(key)
    if key == "r"      then reiniciar() end
    if key == "escape" then love.event.quit() end
end