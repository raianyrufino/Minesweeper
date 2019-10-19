import Textos
import System.Random
import System.Exit
import Auxiliar

type Coordenadas = (Int, Int)
type Valor = Int
type Elem = (Coordenadas,Valor)
type Matriz = [Elem]


-- Cria uma matriz de valores igual ao terceiro parametro
criaMatriz:: Int -> Int -> Int -> Matriz
criaMatriz a b c = [((x,y), c) | x <-[1,2..a], y <-[1,2..b]]

-- Função que encontra as bombas e chama a função soma adjacentes
-- para adicionar 1 aos quadrados adjacentes das bombas
minasAdjacentes:: Matriz -> Matriz -> Matriz
minasAdjacentes [] matriz = matriz
minasAdjacentes (((x, y), z): mtz) matriz = if (z == -1) then minasAdjacentes mtz (somaAdjacentes x y matriz) else (minasAdjacentes mtz matriz)

-- Funcao auxiliar
inverte:: Int -> Int -> Matriz -> Matriz-> Matriz
inverte a b mtz anterior = reverse (verificaSoma a b mtz anterior)

-- Função que Verifica se a posição da matriz não e uma bomba e soma + 1
verificaSoma:: Int -> Int -> Matriz -> Matriz-> Matriz
verificaSoma a b [] anterior = [ ]
verificaSoma a b (((x, y), z): mtz) anterior = if(a == x && b == y && z /= -1) then anterior++(reverse ([((x,y), z+1)]++ mtz)) else verificaSoma a b mtz  anterior++[((x,y), z)]

-- Função que soma os adjacentes a uma bomba
somaAdjacentes:: Int -> Int -> Matriz -> Matriz--campo minado e usuario e retorna a matriz usuario mostrando o elemento da posicao indicada.
somaAdjacentes x y mtz = inverte x (y-1) (inverte x (y+1) (inverte (x-1) y (inverte (x-1) (y+1) (inverte (x-1) (y-1) (inverte (x+1) y (inverte (x+1) (y+1) (inverte (x+1) (y-1) mtz [])[])[])[])[])[])[])[]

-- Se a posicao for uma bomba, retorna true, caso contrario, retorna false
verificaPosicao :: (Int, Int) -> Matriz -> Bool
verificaPosicao tupla [] = False
verificaPosicao (x, y) (((a, b), c):mtzTail) = 
    if (x == a && y == b && c == -1) then 
        True 
    else 
        verificaPosicao (x, y) mtzTail

-- Função que modifica a matriz que é mostrada ao usuário usando a matriz interna
revelaMatriz:: Matriz -> Matriz -> Matriz -> Matriz
revelaMatriz [] mtzInterna mtzUsuario = mtzUsuario
revelaMatriz (((a,b), c):mtzInternaTail) mtzInterna mtzUsuario = revelaMatriz mtzInternaTail mtzInterna (modificaMatriz a b mtzInterna mtzUsuario)

-- Função que recebe o valor das coordenadas x e y e passa para a função modifica 
modificaMatriz:: Int -> Int -> Matriz -> Matriz -> Matriz
modificaMatriz x y (((a,b), c):mtz) mtz_usuario = if (x == a && y == b) then ((modificaPosicao x y c mtz_usuario [])) else modificaMatriz x y mtz mtz_usuario

-- Função que modifica a matriz do usuário de acordo com as coordenadas recebidas
modificaPosicao:: Int -> Int -> Int -> Matriz -> Matriz -> Matriz 
modificaPosicao x y z (((a,b), c):mtzUsuario) mtzFinal = if (x == a && y == b) then mtzFinal ++ (([((x, y), z)] ++ mtzUsuario)) else modificaPosicao x y z mtzUsuario (mtzFinal ++ [((a,b), c)])
        
-- Retorna uma lista de inteiros com os valores da linha passada como parametro
pegaValoresDaLinha :: Int -> Int -> Matriz -> [Int]
pegaValoresDaLinha linha 0 matriz = []
pegaValoresDaLinha linha coluna (((x, y), v):mtz)
    | linha == x = v:pegaValoresDaLinha linha (coluna-1) mtz
    | otherwise = pegaValoresDaLinha linha coluna mtz

-- O nome diz a que veio
converteListaIntParaString :: [Int] -> String
converteListaIntParaString [] = ""
converteListaIntParaString (h:t) 
    | h == -2 = "+ " ++ converteListaIntParaString t
    | h == -1 = "B " ++ converteListaIntParaString t
    | otherwise = show h ++ " " ++ converteListaIntParaString t

-- Cria uma representacao em String da matriz passada como parametro.
-- Requer tambem as dimensoes da matriz
pegaValoresDaMatriz :: Int -> Int -> Int -> Matriz -> String
pegaValoresDaMatriz linha linhas colunas matriz
    | linha == (linhas+1) = ""
    | otherwise = converteListaIntParaString (pegaValoresDaLinha linha colunas matriz) ++ "\n" ++ pegaValoresDaMatriz (linha+1) linhas colunas matriz

-- Imprime a matriz, mas precisa saber as dimensoes dela
-- TODO: precisa fazer as conversoes de numeros para os simbolos usados (-1 = bomba, -2 = nao revelado...)
imprimeMatriz :: Int -> Int -> Matriz -> IO()
imprimeMatriz linhas colunas matriz = putStrLn (pegaValoresDaMatriz 1 linhas colunas matriz)

-- Funcao que insere uma bomba na posicao passada como parametro
insereBomba:: Int -> Int -> Matriz -> Matriz -> Matriz
insereBomba a b [] mtzFinal = mtzFinal
insereBomba a b (((x, y), z): mtz) mtzFinal = 
    if(a == x && b == y) then
        mtzFinal++[((x, y), -1)]++mtz 
    else
        insereBomba a b mtz (mtzFinal++[((x, y), z)])

insereBombas :: [(Int, Int)] -> Matriz -> Matriz
insereBombas [] mtz = mtz
insereBombas ((x, y): mtzTail) mtz =  insereBombas mtzTail (insereBomba x y mtz [])         

contaNaoRevelados :: Int -> Matriz -> Int
contaNaoRevelados num [] = num
contaNaoRevelados num (((x, y), v) : mtz) = if (v == -2) then (contaNaoRevelados (num+1) mtz) else (contaNaoRevelados (num) mtz)

foiRevelado :: Int -> Int -> Matriz -> Bool
foiRevelado x y (((a,b),v):mtzTail) = if (a==x && b==y) then (v/=(-2)) else (foiRevelado x y mtzTail)

arredoresRevelados :: Int -> Int -> Int -> Int -> Matriz -> Bool
arredoresRevelados x y linhas colunas mtzUsuario
    | (x == 1 && y == 1) = (foiRevelado (x) (y+1) mtzUsuario) && (foiRevelado (x+1) (y) mtzUsuario)
    | (x == 1 && y == colunas) = (foiRevelado (x) (y-1) mtzUsuario) && (foiRevelado (x+1) (y) mtzUsuario)
    | (x == linhas && y == colunas) = (foiRevelado (x) (y-1) mtzUsuario) && (foiRevelado (x-1) (y) mtzUsuario)
    | (x == linhas && y == 1) = (foiRevelado (x) (y+1) mtzUsuario) && (foiRevelado (x-1) (y) mtzUsuario)
    | (x == 1 && y > 1 && y < colunas) = (foiRevelado (x) (y+1) mtzUsuario) && (foiRevelado (x) (y-1) mtzUsuario) && (foiRevelado (x+1) (y) mtzUsuario)
    | (x > 1 && x < linhas && y == colunas) = (foiRevelado (x-1) (y) mtzUsuario) && (foiRevelado (x+1) (y) mtzUsuario) && (foiRevelado (x) (y-1) mtzUsuario)
    | (x == linhas && y > 1 && y < colunas) = (foiRevelado (x-1) (y) mtzUsuario) && (foiRevelado (x) (y-1) mtzUsuario) && (foiRevelado (x) (y+1) mtzUsuario)
    | (x > 1 && x < linhas && y == 1) = (foiRevelado (x) (y+1) mtzUsuario) && (foiRevelado (x-1) (y) mtzUsuario) && (foiRevelado (x+1) (y) mtzUsuario)
    | otherwise = (foiRevelado (x-1) (y) mtzUsuario) && (foiRevelado (x) (y+1) mtzUsuario) && (foiRevelado (x+1) (y) mtzUsuario) && (foiRevelado (x) (y-1) mtzUsuario)

revelaEmCruz :: Int -> Int -> Int -> Int -> Matriz -> Matriz -> Matriz
revelaEmCruz x y linhas colunas mtzUsuario mtzInterna
    | (x == 1 &&  y == 1) = modificaMatriz (x+1) y mtzInterna (modificaMatriz x (y+1) mtzInterna mtzUsuario)
    | (x == 1 && y == colunas) = modificaMatriz (x+1) y mtzInterna (modificaMatriz x (y-1) mtzInterna mtzUsuario)
    | (x == linhas && y == colunas) = modificaMatriz (x-1) y mtzInterna (modificaMatriz x (y-1) mtzInterna mtzUsuario)
    | (x == linhas && y==1) = modificaMatriz (x-1) y mtzInterna (modificaMatriz x (y+1) mtzInterna mtzUsuario)
    | (x==1 && y > 1 && y < colunas) = modificaMatriz (x+1) y mtzInterna (modificaMatriz x (y-1) mtzInterna (modificaMatriz x (y+1) mtzInterna mtzUsuario))
    | (x>1 && x < linhas && y==colunas) = modificaMatriz (x-1) y mtzInterna (modificaMatriz (x+1) (y) mtzInterna (modificaMatriz x (y-1) mtzInterna mtzUsuario))
    | (x== linhas && y > 1 && y < colunas) = modificaMatriz (x-1) y mtzInterna (modificaMatriz x (y-1) mtzInterna (modificaMatriz x (y+1) mtzInterna mtzUsuario))
    | (x>1 && x<linhas && y==1) = modificaMatriz x (y+1) mtzInterna (modificaMatriz (x-1) y mtzInterna (modificaMatriz (x+1) y mtzInterna mtzUsuario))
    | otherwise = modificaMatriz (x-1) y mtzInterna (modificaMatriz (x) (y+1) mtzInterna (modificaMatriz (x+1) (y) mtzInterna (modificaMatriz x (y-1) mtzInterna mtzUsuario)))

saiRevelando :: Int -> Int -> Matriz -> Matriz -> Matriz -> Matriz
saiRevelando linhas colunas [] mtzUsuario mtzInterna = mtzUsuario
saiRevelando linhas colunas (((x, y), z):mtzUsuarioTail) mtzUsuario mtzInterna = 
    if (z /= 0) then
        saiRevelando linhas colunas mtzUsuarioTail mtzUsuario mtzInterna
    else 
        if (arredoresRevelados x y linhas colunas mtzUsuario) then
            saiRevelando linhas colunas mtzUsuarioTail mtzUsuario mtzInterna
        else
            saiRevelando linhas colunas (revelaEmCruz x y linhas colunas mtzUsuario mtzInterna) (revelaEmCruz x y linhas colunas mtzUsuario mtzInterna) mtzInterna

entradas :: Int -> Int -> Int -> Matriz -> Matriz -> IO()
entradas linhas colunas bombas mtzInterna mtzUsuario = do
    putStr "Informe sua jogada:"
    
    entrada <- getLine
    putStrLn"\n"
    let info = words entrada
    let j = info !! 0
    let x = read (info !! 1) :: Int
    let y = read (info !! 2) :: Int

    if(j == "R") then do
        let matrizUsuario = if(verificaPosicao (x, y) mtzInterna) then revelaMatriz mtzInterna mtzInterna mtzUsuario else modificaMatriz x y mtzInterna mtzUsuario
        
        let matrizUsuarioReveladaRecursivamente = saiRevelando linhas colunas matrizUsuario matrizUsuario mtzInterna

        imprimeMatriz linhas colunas (matrizUsuarioReveladaRecursivamente)
        if(verificaPosicao (x, y) mtzInterna) then
            Textos.mensagemPerdeu
        else
            if (contaNaoRevelados 0 matrizUsuarioReveladaRecursivamente == bombas) then Textos.mensagemVenceu else entradas linhas colunas bombas mtzInterna matrizUsuario 
    else do
        putStrLn "Opcao invalida"
        entradas linhas colunas bombas mtzInterna mtzUsuario

inicia_jogo :: IO()
inicia_jogo = do
    putStrLn"Informe o tamanho M N da matriz e o numero B de bombas com:" 
    putStrLn "2 <= M <= 9  ,  2 <= N <= 9  e  1 <= B <= 9" 
    putStr "Sua opção:"
    entrada <- getLine
    putStrLn "\n"
    let info = words entrada
    let linhas = read (info !! 0) :: Int
    let colunas = read (info !! 1) :: Int
    let bombas = read (info !! 2) :: Int

    g <- newStdGen
    let (a,b) = randomR (1,999999 :: Int) g
    let semente1 = a

    h <- newStdGen
    let (c,d) = randomR (1,999999 :: Int) h
    let semente2 = c

    let campo_minado = criaMatriz linhas colunas 0
    
    let posicoes_aleatorias = Auxiliar.geraPosicoesAleatorias linhas colunas bombas semente1 semente2 []
    
    let campo_bombado = (insereBombas posicoes_aleatorias campo_minado)
    
    let prepara_campo_bombado = minasAdjacentes campo_bombado campo_bombado

    let matriz_impressa = (criaMatriz linhas colunas (-2))
    
    imprimeMatriz linhas colunas matriz_impressa

    entradas linhas colunas bombas prepara_campo_bombado matriz_impressa

main :: IO()
main = do
    Textos.mensagemBemVindo
    menu

menu :: IO()
menu = do
    Textos.mainMenu
    escolha <- getLine
    
    if(escolha == "1") then do
        inicia_jogo
    else if(escolha == "2") then do
        Textos.menuCreditos
        menu
    else if(escolha == "3") then do
        Textos.menuInstrucoes
        menu
    else if(escolha == "4") then do 
        exitSuccess
    else do
        putStrLn "Opção inválida"
        menu
