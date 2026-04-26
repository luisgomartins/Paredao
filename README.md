Projeto da disciplina de Multímidia, Professor Tarcísio.

Por que a velocidade da bola é multiplicada por dt em vez de ser somada 
diretamente? O que aconteceria se não fizéssemos isso? 
• O que representa bola.vx negativo? E positivo? Como o código usa esse sinal para 
saber em qual direção a bola está indo no momento da colisão com a raquete? 
• A função reiniciar é chamada tanto em love.load quanto ao pressionar R. Por 
que essa separação é uma boa prática? 

O Paredão tem um único jogador e uma parede passiva no lugar do adversário. O Tênis 
substitui essa parede por um segundo jogador humano, com sua própria raquete e seus 
próprios controles — tornando o jogo simétrico e competitivo. 
Sua tarefa é modificar o código do Paredão para implementar o Tênis. Não é necessário 
reescrever tudo do zero: a maior parte da estrutura já existe e pode ser reaproveitada. 
Pense nas diferenças entre os dois jogos e deixe que elas guiem as modificações 
necessárias. 
Como orientação geral, considere o que precisa mudar: a parede direita deixa de existir e 
passa a ser uma segunda raquete controlada pelo teclado. A bola agora pode sair tanto 
pela esquerda quanto pela direita, e cada lado perdido deve pontuar para o adversário. O 
jogo precisa de um placar duplo e de uma condição de vitória — por exemplo, o primeiro a 
atingir 7 pontos vence. Quando um ponto é marcado, apenas a bola deve ser reposicionada; 
o placar deve ser preservado.

<img width="709" height="546" alt="image" src="https://github.com/user-attachments/assets/a0bdc95e-92c6-47c9-bb10-bb72c1dbcbfc" />
<img width="680" height="537" alt="image" src="https://github.com/user-attachments/assets/78d4b8f5-a16a-4582-bbb5-6db1a4b7bd2d" />


Dicas 
Pense em como transformar o código de movimento da raquete em uma função que receba 
a raquete e as teclas como parâmetros — isso evitará repetição de código para as duas 
raquetes. 
A condição de colisão com a raquete direita é análoga à da esquerda, mas espelhada. Antes 
de codificar, desenhe no papel a posição da bola e da raquete e determine quais 
coordenadas devem ser comparadas. 
Separe bem a lógica de "marcar ponto" da lógica de "verificar vitória". Isso tornará o código 
mais fácil de entender e modificar. 
Entrega 
Até o final da aula (22h30), cada aluno deve realizar o upload jogo funcionando (ou do código que 
conseguiu desenvolver para o jogo) na respectiva atividade do Classroom. Esta atividade deve ser 
feita individualmente ou em duplas.

