-- main.lua
-- Reimplementação do "Tênis" baseada no Paredão

-- Mudança: Agora o jogo possui um marcador de pontos com condiçãod e vitória, entre dois jogadores
local LARGURA, ALTURA   = 800, 600
local BOLA_VEL          = 350
local RAQUETE_VEL       = 400
local RAQUETE_H         = 100
local RAQUETE_W         = 15
local BOLA_SIZE         = 15
local PONTOS_VITORIA    = 7

-- Mudança: Agora são duas raquetes e um placar para cada jogador
local bola, raquete1, raquete2, pontos1, pontos2, gameOver, vencedor

function love.load()
    love.window.setTitle("Tênis")
    love.window.setMode(LARGURA, ALTURA)
    reiniciar()
end

-- Novo: Função para reposicionar a bola no centro com direção aleatória 
function reposicionarBola()
    bola = {
        x = LARGURA / 2,
        y = ALTURA / 2,
        -- A bola agora pode ir para a esquerda ou direita aleatoriamente no saque
        vx = BOLA_VEL * (math.random() > 0.5 and 1 or -1),
        vy = BOLA_VEL * (math.random() > 0.5 and 1 or -1)
    }
end

-- Mudança: A função reiniciar agora inicializa as duas raquetes, os pontos de ambos os jogadores e o estado de game over
function reiniciar()
    pontos1 = 0
    pontos2 = 0
    gameOver = false
    vencedor = 0
    
    raquete1 = { x = 30, y = ALTURA / 2 - RAQUETE_H / 2 }
    raquete2 = { x = LARGURA - 30 - RAQUETE_W, y = ALTURA / 2 - RAQUETE_H / 2 }
    
    reposicionarBola()
end

-- Novo: Função para mover as raquetes, agora com controles separados para cada jogador. Usei uma função nova para evitar repetição de código,
-- já que as duas raquetes têm a mesma lógica de movimento, mas controles diferentes.
function moverRaquete(raquete, teclaCima, teclaBaixo, dt)
    if love.keyboard.isDown(teclaCima) then
        raquete.y = raquete.y - RAQUETE_VEL * dt
    end
    if love.keyboard.isDown(teclaBaixo) then
        raquete.y = raquete.y + RAQUETE_VEL * dt
    end
    -- Trava para não sair da tela
    raquete.y = math.max(0, math.min(ALTURA - RAQUETE_H, raquete.y))
end

function love.update(dt)
    if gameOver then return end

    -- Mudança: Agora pode mover as duas raquetes usando a função moverRaquete, com controles separados para cada jogador
    moverRaquete(raquete1, "w", "s", dt)
    moverRaquete(raquete2, "up", "down", dt)

    bola.x = bola.x + bola.vx * dt
    bola.y = bola.y + bola.vy * dt

    if bola.y <= 0 then
        bola.y = 0
        bola.vy = -bola.vy
    elseif bola.y + BOLA_SIZE >= ALTURA then
        bola.y = ALTURA - BOLA_SIZE
        bola.vy = -bola.vy
    end

    if bola.x <= raquete1.x + RAQUETE_W and
       bola.x + BOLA_SIZE >= raquete1.x and
       bola.y + BOLA_SIZE >= raquete1.y and
       bola.y <= raquete1.y + RAQUETE_H then
        bola.x = raquete1.x + RAQUETE_W
        bola.vx = -bola.vx
    end

    -- Mudança: Adicionei a colisão da bola com a raquete 2, que é o jogador adversário. A lógica é invertida
    if bola.x + BOLA_SIZE >= raquete2.x and
       bola.x <= raquete2.x + RAQUETE_W and
       bola.y + BOLA_SIZE >= raquete2.y and
       bola.y <= raquete2.y + RAQUETE_H then
        -- Reposiciona a bola grudadinha no lado esquerdo da raquete 2
        bola.x = raquete2.x - BOLA_SIZE 
        bola.vx = -bola.vx
    end

    -- Pontuação do Jogador 2 (Bola saiu pela esquerda)
    if bola.x < 0 then
        pontos2 = pontos2 + 1
        if pontos2 >= PONTOS_VITORIA then
            gameOver = true
            vencedor = 2
        else
            reposicionarBola()
        end
    end

    -- Pontuação do Jogador 1 (Bola saiu pela direita)
    if bola.x > LARGURA then
        pontos1 = pontos1 + 1
        if pontos1 >= PONTOS_VITORIA then
            gameOver = true
            vencedor = 1
        else
            reposicionarBola()
        end
    end
end

function love.draw()
    if gameOver then
        love.graphics.setColor(1, 1, 0)
        love.graphics.printf("Jogador " .. vencedor .. " venceu!", 0, 250, LARGURA, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(pontos1 .. " X " .. pontos2, 0, 300, LARGURA, "center")
        love.graphics.printf("Pressione R para jogar novamente", 0, 350, LARGURA, "center")
        return
    end

    -- Desenha a rede no meio (Pra ficar igual o PDF)
    love.graphics.setColor(0.5, 0.5, 0.5)
    for i = 0, ALTURA, 30 do
        love.graphics.rectangle("fill", LARGURA / 2 - 2, i, 4, 15)
    end

    -- Desenha a Raquete 1 (Azul)
    love.graphics.setColor(0.3, 0.6, 1)
    love.graphics.rectangle("fill", raquete1.x, raquete1.y, RAQUETE_W, RAQUETE_H)
    
    -- Desenha a Raquete 2 (Vermelha)
    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.rectangle("fill", raquete2.x, raquete2.y, RAQUETE_W, RAQUETE_H)

    -- Desenha a Bola (Branca)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", bola.x, bola.y, BOLA_SIZE, BOLA_SIZE)

    -- Placar Duplo
    love.graphics.print(pontos1, LARGURA / 2 - 50, 20)
    love.graphics.print(pontos2, LARGURA / 2 + 40, 20)
end

function love.keypressed(key)
    if key == "r" then reiniciar() end
    if key == "escape" then love.event.quit() end
end