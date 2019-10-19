import System.Random
import Data.Typeable
import Auxiliar

type Coordenadas = (Int, Int)
type Valor = Int
type Elem = (Coordenadas,Valor)
type Matriz = [Elem]

main :: IO()
main = do
    
    let m = [((1,1),0), ((1,2),2), ((4,5),10)]
    let x = 1
    let y= 2
    print 




    somaAdjacentes:: Int -> Int -> Int -> Int -> Matriz -> Matriz--campo minado e usuario e retorna a matriz usuario mostrando o elemento da posicao indicada.
    somaAdjacentes linhas colunas x y mtz 
        | (x == 1 && y == 1) = inverte 1 2 (inverte 2 1 (inverte 2 2 mtz []) []) []
        | (x == 1 && y == colunas) = inverte 1 (colunas-1) (inverte 2 colunas (inverte 2 (colunas-1) mtz []) [])[]
        | (x == linhas && y == colunas) = inverte linhas (colunas-1) (inverte (linhas-1) colunas (inverte (linhas-1) (colunas-1) mtz [])[])[]
        | (x == linhas && y == 1) = inverte linhas 2 (inverte (linhas-1) 1 (inverte (linhas-1) 2 mtz [])[])[]
        | (x == 1 && y > 1 && y < colunas) = inverte 1 (y+1)(inverte 1 (y-1) (inverte 2 y (inverte 2 (y+1) (inverte 2 (y-1) mtz [])[])[])[])[]
        | (x > 1 && x < linhas && y == colunas) = inverte x (colunas-1) (inverte (x-1) colunas (inverte (x-1) (colunas-1) (inverte (x+1) colunas (inverte (x+1) (colunas-1) mtz [])[])[])[])[]
        | (x == linhas && y > 1 && y < colunas) = inverte linhas (y-1) (inverte linhas (y+1) (inverte (linhas-1) y (inverte (linhas-1) (y+1) (inverte (linhas-1) (y-1) mtz [])[])[])[])[]
        | (x > 1 && x < linhas && y == 1) = inverte (x-1) 1 (inverte (x-1) 2 (inverte x 2 (inverte (x+1) 2 (inverte (x+1) 1 mtz []) []) []) []) []
        | otherwise = inverte x (y-1) (inverte x (y+1) (inverte (x-1) y (inverte (x-1) (y+1) (inverte (x-1) (y-1) (inverte (x+1) y (inverte (x+1) (y+1) (inverte (x+1) (y-1) mtz [])[])[])[])[])[])[])[]
    