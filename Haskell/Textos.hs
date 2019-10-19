module Textos
(mensagemBemVindo
,mensagemPerdeu
,mensagemVenceu
,mainMenu
,menuCreditos
,menuInstrucoes
)where





mensagemBemVindo :: IO()
mensagemBemVindo = do
    putStrLn "██████╗ ███████╗███╗   ███╗    ██╗   ██╗██╗███╗   ██╗██████╗  ██████╗ "    
    putStrLn "██╔══██╗██╔════╝████╗ ████║    ██║   ██║██║████╗  ██║██╔══██╗██╔═══██╗" 
    putStrLn "██████╔╝█████╗  ██╔████╔██║    ██║   ██║██║██╔██╗ ██║██║  ██║██║   ██║" 
    putStrLn "██╔══██╗██╔══╝  ██║╚██╔╝██║    ╚██╗ ██╔╝██║██║╚██╗██║██║  ██║██║   ██║" 
    putStrLn "██████╔╝███████╗██║ ╚═╝ ██║     ╚████╔╝ ██║██║ ╚████║██████╔╝╚██████╔╝" 
    putStrLn "╚═════╝ ╚══════╝╚═╝     ╚═╝      ╚═══╝  ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝ " 

mensagemPerdeu :: IO() 
mensagemPerdeu = do
    putStrLn "██╗   ██╗ ██████╗  ██████╗███████╗    ██████╗ ███████╗██████╗ ██████╗ ███████╗██╗   ██╗██╗ " 
    putStrLn "██║   ██║██╔═══██╗██╔════╝██╔════╝    ██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██║   ██║██║ "  
    putStrLn "██║   ██║██║   ██║██║     █████╗      ██████╔╝█████╗  ██████╔╝██║  ██║█████╗  ██║   ██║██║ " 
    putStrLn "╚██╗ ██╔╝██║   ██║██║     ██╔══╝      ██╔═══╝ ██╔══╝  ██╔══██╗██║  ██║██╔══╝  ██║   ██║╚═╝ " 
    putStrLn " ╚████╔╝ ╚██████╔╝╚██████╗███████╗    ██║     ███████╗██║  ██║██████╔╝███████╗╚██████╔╝██╗ " 
    putStrLn "  ╚═══╝   ╚═════╝  ╚═════╝╚══════╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝ ╚═════╝ ╚═╝ "

mensagemVenceu :: IO()
mensagemVenceu = do
    putStrLn "██╗   ██╗ ██████╗  ██████╗███████╗    ██╗   ██╗███████╗███╗   ██╗ ██████╗███████╗██╗   ██╗██╗" 
    putStrLn "██║   ██║██╔═══██╗██╔════╝██╔════╝    ██║   ██║██╔════╝████╗  ██║██╔════╝██╔════╝██║   ██║██║" 
    putStrLn "██║   ██║██║   ██║██║     █████╗      ██║   ██║█████╗  ██╔██╗ ██║██║     █████╗  ██║   ██║██║" 
    putStrLn "╚██╗ ██╔╝██║   ██║██║     ██╔══╝      ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║██║     ██╔══╝  ██║   ██║╚═╝" 
    putStrLn " ╚████╔╝ ╚██████╔╝╚██████╗███████╗     ╚████╔╝ ███████╗██║ ╚████║╚██████╗███████╗╚██████╔╝██╗" 
    putStrLn "  ╚═══╝   ╚═════╝  ╚═════╝╚══════╝      ╚═══╝  ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝ ╚═════╝ ╚═╝" 
    

mainMenu :: IO()
mainMenu = do
    putStrLn "" 
    putStrLn "|-----------------------------------------------------------------------------|" 
    putStrLn "|                                 Menu                                        |" 
    putStrLn "|                           (1) Iniciar Jogo                                  |" 
    putStrLn "|                           (2) Créditos                                      |" 
    putStrLn "|                           (3) Instruções do Jogo                            |" 
    putStrLn "|                           (4) Sair do Jogo                                  |" 
    putStrLn "|-----------------------------------------------------------------------------|" 

menuCreditos :: IO()
menuCreditos = do
    putStrLn "" 
    putStrLn "|-----------------------------------------------------------------------------|" 
    putStrLn "|                                 PLP 2019.2                                  |" 
    putStrLn "|                            Everton L. G. Alves                              |" 
    putStrLn "|                                                                             |" 
    putStrLn "|                                  Grupo:                                     |" 
    putStrLn "|                          Diego Ribeiro de Almeida                           |" 
    putStrLn "|                             Iago Tito Oliveira                              |" 
    putStrLn "|                        Paulo Mateus Alves Moreira                           |" 
    putStrLn "|                        Raiany Rufino Costa da Paz                           |" 
    putStrLn "|-----------------------------------------------------------------------------|" 


menuInstrucoes :: IO()
menuInstrucoes = do
    putStrLn "" 
    putStrLn "|-----------------------------------------------------------------------------|" 
    putStrLn "|                          Instruçoes do Jogo                                 |" 
    putStrLn "|                                                                             |" 
    putStrLn "|             Revela, exemplo: R 1 2 - Revela posição (1,2).                  |" 
    putStrLn "|-----------------------------------------------------------------------------|" 