
using namespace std;
#ifndef tabuleiro_h   
#define tabuleiro_h 

extern int linhas, colunas, bombas;// quantidade de cada uma dessas coisas no jogo
extern int y, x; // posicao da jogada do jogador
extern char m; // tipo de jogada do jogador: R - revelar, F - bandeira, ? - interrogacao
extern bool perdeu; // diz se o jogador perdeu (se ele revelou uma bomba)
extern bool venceu;
extern int quadrados_revelados;
extern int bombas_encontradas;
extern bool primeiro;
extern clock_t tInicio, tFim;
extern double tDecorrido;


void coleta_dados_iniciais();

void inicia_jogo ();



#endif