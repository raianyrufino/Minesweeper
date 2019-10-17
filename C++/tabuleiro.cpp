#include <string>
#include <string.h>
#include <iostream>
#include "tabuleiro.h"
#include <stdio.h>
#include <stdlib.h>
using namespace std;


// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- Variaveis globais -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- //
int linhas, colunas, bombas; // quantidade de cada uma dessas coisas no jogo
int x, y; // posicao da jogada do jogador
char m; // tipo de jogada do jogador: R - revelar, F - bandeira, ? - interrogacao
bool perdeu = false; // diz se o jogador perdeu (se ele revelou uma bomba)
bool venceu = false;
int quadrados_revelados = 0;
int bombas_encontradas = 0;
bool primeira = true;
clock_t tInicio, tFim;//declarando as variaveis da contagem do tempo
double tDecorrido; //variavel do tipo double para armazenar todo o tempo decorrido



void tempoInicio ();
void tempoFim();


/*
Coleta os dados do tamanho do campo e da quantidade de bombas
*/
void coleta_dados_iniciais () {
	primeira = true;
    while (true) {
		cout << "Informe o tamanho M N da matriz e o numero X de bombas com:" << endl;
		cout << "3 <= M <= 16  ,  3 <= N <= 30  e  2 <= X < (M*N)-1" << endl;
		cout << "Sugerimos: 16 16 20" << endl;
		cout << endl;
		string l, c, b;

		cout << "Sua opcao: ";
		cin >> l >> c >> b;

		cout << endl << endl;
	
		linhas = atoi( l.c_str());
		colunas = atoi( c.c_str());
		bombas = atoi( b.c_str());

		if (linhas < 3 || linhas > 16)
			cout << "Número de linhas fora do esperado." << endl;
		else if (colunas < 3 || colunas > 30)
			cout << "Número de colunas fora do esperado." << endl;
		else if (bombas < 2 ||  bombas >= (linhas*colunas)-1)
			cout << "Número de bombas fora do esperado." << endl;
		else
			break;
	}
}

/* 
Preenche o campo com carateres '+'. Como em C++ o vetor começar com o que tiver na memória, usamos esse método para
"limpar" o vetor.
*/
void preenche_campo(char campo[]) {
	for (int i = 0; i < linhas; i++) {
		for (int j = 0; j < colunas; j++) {
			campo[i*linhas + j] = '+';
		}
	}
}

/*
Imprime o campo com legendas para linhas e colunas.
*/
void imprime_campo (char campo[]) {

	cout << endl << endl;
	// Imprime a legenda de numeros superior
	cout << "       1";
	for (int c = 2; c < colunas+1; c++) {
		if (c < 10)
			cout << "  " <<  c;
		else
			cout << " " << c;
	}
	cout << endl;

	// Imprime a linha superior
	cout << "       -";
	for (int c = 0; c < colunas-1; c++) {
		cout << "  -";
	}
	cout << endl;

	// Imprime a matriz
	for (int i = 0; i < linhas; i++) {
		cout << "  " << (char)(i+65) << " | "; // Imprime as letras da linha e uma linha separadora no lado esquerdo
		for (int j = 0; j < colunas; j++) {
			cout << " " << campo[i*linhas + j] << " ";
		}
		cout <<" | " << (char)(i+65); // Imprime as letras da linha e uma linha separadora no lado direito
		cout << endl;
	}

	// Imprime a linha inferior
	cout << "       -";
	for (int c = 0; c < colunas-1; c++) {
		cout << "  -";
	}
	cout << endl;

	// Imprime a legenda de numeros inferior
	cout << "       1";
	for (int c = 2; c < colunas+1; c++) {
		if (c < 10)
			cout << "  " <<  c;
		else
			cout << " " << c;
	}

	cout << endl << endl;
}

/*
Registra que tipo de jogada e em qual posicao ela será feita.
*/
void pega_jogada () {
	while (true) {
		cout << "Informe sua jogada: ";
		char l;
		string c;
		cin >> m;
		if (m == 'S') break;
		cin >> l >> c;
		cout << endl;
		
		y = atoi(c.c_str());
		
		x = ((int) l) - 65; // l será lido como um char. Vamos converter de char pra um int para trabalhar
							// com indices no array.
		y--; // y será lido do usuario como a posição real no array+1, logo, corrigimos com esse --;

		if (m != 'R' && m != 'F' && m != '?')
			cout << "Jogada invalida." << endl;
		else if (x < 0 || x > linhas-1) 
			cout << "Linha inválida." << endl;
		else if (y < 0 || y > colunas-1)
			cout << "Coluna inválida" << endl;
		else 
			break;
	}
}

/*
Gera bombas em lugares aleatórios do campo interno, com exceção do lugar onde a primeira jogada foi feita.
*/
void gera_bombas (char campo_interno[]) {
	int counter = 0;
	int b;
	while (counter < bombas) {
		b = rand() % (linhas * colunas);
		if (campo_interno[b] == '+') {
			campo_interno[b] = 'B';
			counter++;
		}
	}
}

/*
Preenche todas as posições do campo interno que não são bombas com 0.
*/
void preenche_campo_com_zeros (char campo_interno[]) {
    for (int c = 0; c < linhas*colunas; c++) {
        if (campo_interno[c] == '+')
            campo_interno[c] = '0';
    }
}

/*
"Soma um" ao valor do quadrado passado como parâmetro.
*/
void soma_um (char campo_interno[], int p) {
	if (campo_interno[p] == '0') {
		campo_interno[p] = '1';
	} else if (campo_interno[p] == '1') {
		campo_interno[p] = '2';
	} else if (campo_interno[p] == '2') {
		campo_interno[p] = '3';
	} else if (campo_interno[p] == '3') {
		campo_interno[p] = '4';
	} else if (campo_interno[p] == '4') {
		campo_interno[p] = '5';
	} else if (campo_interno[p] == '5') {
		campo_interno[p] = '6';
	} else if (campo_interno[p] == '6') {
		campo_interno[p] = '7';
	} else if (campo_interno[p] == '7') {
		campo_interno[p] = '8';
	}

}

/*
Diz quantas bombas existem ao redor do quadrado da posição passada como parâmetro
*/
void calcula_arredores (char campo_interno[], int i, int j) {
	// Quando o quadrado a ser revelado está "no meio" do tabuleiro
	if (i-1 >= 0 && i+1 < linhas && j-1 >= 0 && j+1 < colunas) {
		
		soma_um(campo_interno, (i-1)*linhas + (j-1));
		soma_um(campo_interno, (i-1)*linhas + (j));
		soma_um(campo_interno, (i-1)*linhas + (j+1));
		soma_um(campo_interno, (i)*linhas + (j-1));
		//	
		soma_um(campo_interno, (i)*linhas + (j+1));
		soma_um(campo_interno, (i+1)*linhas + (j-1));
		soma_um(campo_interno, (i+1)*linhas + (j));
		soma_um(campo_interno, (i+1)*linhas + (j+1));

	// Quando o quadrado está no canto superior esquerdo
	} else if (i-1 < 0 && j-1 < 0) {
		//	
		soma_um(campo_interno, (i)*linhas + (j+1));
		soma_um(campo_interno, (i+1)*linhas + (j));
		soma_um(campo_interno, (i+1)*linhas + (j+1));
	
	// Quando o quadrado está "no meio" na parte superior
	} else if (i-1 < 0 && j-1 >= 0 && j+1 < colunas) {
		soma_um(campo_interno, (i)*linhas + (j-1));
		//	
		soma_um(campo_interno, (i)*linhas + (j+1));
		soma_um(campo_interno, (i+1)*linhas + (j-1));
		soma_um(campo_interno, (i+1)*linhas + (j));
		soma_um(campo_interno, (i+1)*linhas + (j+1));

	// O quadrado está no canto superior direito
	} else if (i-1 < 0 && j+1 >= colunas) {
		soma_um(campo_interno, (i)*linhas + (j-1));
		//	
		soma_um(campo_interno, (i+1)*linhas + (j-1));
		soma_um(campo_interno, (i+1)*linhas + (j));

	// O quadrado está "no meio" na lateral esquerda
	} else if (i-1 >= 0 && i+1 < linhas && j-1 < 0) {
		soma_um(campo_interno, (i-1)*linhas + (j));
		soma_um(campo_interno, (i-1)*linhas + (j+1));
		//	
		soma_um(campo_interno, (i)*linhas + (j+1));
		soma_um(campo_interno, (i+1)*linhas + (j));
		soma_um(campo_interno, (i+1)*linhas + (j+1));

	// O quadrado está "no meio" na lateral direita
	} else if (i-1 >= 0 && i+1 < linhas && j+1 >= colunas) {
		soma_um(campo_interno, (i-1)*linhas + (j-1));
		soma_um(campo_interno, (i-1)*linhas + (j));
		soma_um(campo_interno, (i)*linhas + (j-1));
		//	
		soma_um(campo_interno, (i+1)*linhas + (j-1));
		soma_um(campo_interno, (i+1)*linhas + (j));

	// O quadrado está na parte inferior esquerda
	} else if (i+1 >= linhas && j-1 < 0) {
		soma_um(campo_interno, (i-1)*linhas + (j));
		soma_um(campo_interno, (i-1)*linhas + (j+1));
		//	
		soma_um(campo_interno, (i)*linhas + (j+1));

	// O quadrado está "no meio" da parte inferior
	} else if (i+1 >= linhas && j-1 >= 0 && j+1 < colunas) {
		soma_um(campo_interno, (i-1)*linhas + (j-1));
		soma_um(campo_interno, (i-1)*linhas + (j));
		soma_um(campo_interno, (i-1)*linhas + (j+1));
		soma_um(campo_interno, (i)*linhas + (j-1));
		//	
		soma_um(campo_interno, (i)*linhas + (j+1));

	// O quadrado está na parte inferior direita
	} else {
		soma_um(campo_interno, (i-1)*linhas + (j-1));
		soma_um(campo_interno, (i-1)*linhas + (j));
		soma_um(campo_interno, (i)*linhas + (j-1));
		//
	}

}

/*
Revela um quadrado no campo do usuário com base no que existe na mesma posição no campo interno.
*/
void revela_quadrado(char campo_interno[], char campo_usuario[], int posicao) {
	if (campo_usuario[posicao] == '+') {
		campo_usuario[posicao] = campo_interno[posicao];
		quadrados_revelados++;
	}
}

/*
Método usado para auxiliar a revelação consecutiva de quadrados sem bombas ao redor. Se o quadrado da posição passada
como parâmetro não tiver bombas ao redor, revela os quadrados amica, abaixo, à esquerda e à direita.
*/
void revela_arredores (char campo_interno[], char campo_usuario[], int i, int j) {
	// Quando o quadrado a ser revelado está "no meio" do tabuleiro
	if (i-1 >= 0 && i+1 < linhas && j-1 >= 0 && j+1 < colunas) {
		
		// revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j-1));
		revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j));
		// revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j+1));
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j-1));
		//	
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j+1));
		// revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j-1));
		revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j));
		// revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j+1));

	// Quando o quadrado está no canto superior esquerdo
	} else if (i-1 < 0 && j-1 < 0) {
		//	
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j+1));
		revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j));
		// revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j+1));
	
	// Quando o quadrado está "no meio" na parte superior
	} else if (i-1 < 0 && j-1 >= 0 && j+1 < colunas) {
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j-1));
		//	
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j+1));
		// revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j-1));
		revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j));
		// revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j+1));

	// O quadrado está no canto superior direito
	} else if (i-1 < 0 && j+1 >= colunas) {
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j-1));
		//	
		// revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j-1));
		revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j));

	// O quadrado está "no meio" na lateral esquerda
	} else if (i-1 >= 0 && i+1 < linhas && j-1 < 0) {
		revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j));
		// revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j+1));
		//	
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j+1));
		revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j));
		// revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j+1));

	// O quadrado está "no meio" na lateral direita
	} else if (i-1 >= 0 && i+1 < linhas && j+1 >= colunas) {
		// revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j-1));
		revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j));
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j-1));
		//	
		// revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j-1));
		revela_quadrado(campo_interno, campo_usuario, (i+1)*linhas + (j));

	// O quadrado está na parte inferior esquerda
	} else if (i+1 >= linhas && j-1 < 0) {
		revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j));
		// revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j+1));
		//	
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j+1));

	// O quadrado está "no meio" da parte inferior
	} else if (i+1 >= linhas && j-1 >= 0 && j+1 < colunas) {
		// revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j-1));
		revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j));
		// revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j+1));
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j-1));
		//	
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j+1));

	// O quadrado está na parte inferior direita
	} else {
		// revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j-1));
		revela_quadrado(campo_interno, campo_usuario, (i-1)*linhas + (j));
		revela_quadrado(campo_interno, campo_usuario, (i)*linhas + (j-1));
		//
	}
}

/*
Diz se os aredores de uma posição já foram revelados. Método usado para evitar uma repetição infinita de revelações.
*/
bool arredores_revelados (char campo_usuario[], int i, int j) {
	// Quando o quadrado a ser checado está "no meio" do tabuleiro
	if (i-1 >= 0 && i+1 < linhas && j-1 >= 0 && j+1 < colunas) {
		if (// campo_usuario[(i-1)*linhas + (j-1)] == '+' || 
			campo_usuario[(i-1)*linhas + (j)] == '+' || 
			// campo_usuario[(i-1)*linhas + (j+1)] == '+' || 
			campo_usuario[(i)*linhas + (j-1)] == '+' || 
			//
			campo_usuario[(i)*linhas + (j+1)] == '+' || 
			// campo_usuario[(i+1)*linhas + (j-1)] == '+' || 
			campo_usuario[(i+1)*linhas + (j)] == '+' // || 
			// campo_usuario[(i+1)*linhas + (j+1)] == '+'
			) {
			return false;
		}

	// Quando o quadrado está no canto superior esquerdo
	} else if (i-1 < 0 && j-1 < 0) {
		if (//
			campo_usuario[(i)*linhas + (j+1)] == '+' || 
			campo_usuario[(i+1)*linhas + (j)] == '+' // || 
			// campo_usuario[(i+1)*linhas + (j+1)] == '+'
			) {
			return false;
		}
	
	// Quando o quadrado está "no meio" na parte superior
	} else if (i-1 < 0 && j-1 >= 0 && j+1 < colunas) {
		if (campo_usuario[(i)*linhas + (j-1)] == '+' || 
			//
			campo_usuario[(i)*linhas + (j+1)] == '+' || 
			// campo_usuario[(i+1)*linhas + (j-1)] == '+' || 
			campo_usuario[(i+1)*linhas + (j)] == '+'//  || 
			// campo_usuario[(i+1)*linhas + (j+1)] == '+'
			) {
				return false;
		}

	// O quadrado está no canto superior direito
	} else if (i-1 < 0 && j+1 >= colunas) {
		if (campo_usuario[(i)*linhas + (j-1)] == '+' || 
			//
			// campo_usuario[(i+1)*linhas + (j-1)] == '+' || 
			campo_usuario[(i+1)*linhas + (j)] == '+') {
				return false;
			}

	// O quadrado está "no meio" na lateral esquerda
	} else if (i-1 >= 0 && i+1 < linhas && j-1 < 0) {
		if (campo_usuario[(i-1)*linhas + (j)] == '+' || 
			// campo_usuario[(i-1)*linhas + (j+1)] == '+' || 
			//
			campo_usuario[(i)*linhas + (j+1)] == '+' || 
			campo_usuario[(i+1)*linhas + (j)] == '+' // || 
			// campo_usuario[(i+1)*linhas + (j+1)] == '+'
			) {
				return false;
		}

	// O quadrado está "no meio" na lateral direita
	} else if (i-1 >= 0 && i+1 < linhas && j+1 >= colunas) {
		if (// campo_usuario[(i-1)*linhas + (j-1)] == '+' || 
			campo_usuario[(i-1)*linhas + (j)] == '+' || 
			campo_usuario[(i)*linhas + (j-1)] == '+' || 
			//
			// campo_usuario[(i+1)*linhas + (j-1)] == '+' || 
			campo_usuario[(i+1)*linhas + (j)] == '+') {
				return false;
		}

	// O quadrado está na parte inferior esquerda
	} else if (i+1 >= linhas && j-1 < 0) {
		if (campo_usuario[(i-1)*linhas + (j)] == '+' || 
			// campo_usuario[(i-1)*linhas + (j+1)] == '+' || 
			//
			campo_usuario[(i)*linhas + (j+1)] == '+') {
				return false;
		}

	// O quadrado está "no meio" da parte inferior
	} else if (i+1 >= linhas && j-1 >= 0 && j+1 < colunas) {
		if (// campo_usuario[(i-1)*linhas + (j-1)] == '+' || 
			campo_usuario[(i-1)*linhas + (j)] == '+' || 
			// campo_usuario[(i-1)*linhas + (j+1)] == '+' || 
			campo_usuario[(i)*linhas + (j-1)] == '+' || 
			//
			campo_usuario[(i)*linhas + (j+1)] == '+') {
				return false;
		}

	// O quadrado está na parte inferior direita
	} else {
		if (// campo_usuario[(i-1)*linhas + (j-1)] == '+' || 
			campo_usuario[(i-1)*linhas + (j)] == '+' || 
			campo_usuario[(i)*linhas + (j-1)] == '+') {
			return false;
		}
	}

	return true;
}

/*
Método geral para revelar a posição da jogada de revelar. Como tal posição é armazenada em variáveis globais, elas
não são passadas como parâmetro.
*/
void revela (char campo_interno[], char campo_usuario[]) {

	if (campo_interno[x*linhas + y] == 'B') {
		perdeu = true;
	} else {
		revela_quadrado(campo_interno, campo_usuario, x*linhas + y);

		// Revela tudo ao redor até achar um número
		bool revelou = true;
		while (revelou) {
			revelou = false;

			for (int i = 0; i < linhas; i++) {
				for (int j = 0; j < colunas; j++) {
					if (!arredores_revelados(campo_usuario, i, j)) {
						if (campo_usuario[i*linhas + j] == '0') {
							revela_arredores (campo_interno, campo_usuario, i, j);
							revelou = true;
						}
					}
				}
			}
		}
	}
}

/*
Analisa a validade de uma jogada de revelar.
*/
void jogada_revelar (char campo_interno[], char campo_usuario[]) {
	if (campo_usuario[x*linhas + y] == 'F') {
		cout << "Não é possível revelar uma bandeira!" << endl;
		cout << endl;
	} else if (campo_usuario[x*linhas + y] != '+') {
		cout << "Quadrado já revelado!" << endl;
		cout << endl;
	} else { 
		revela(campo_interno, campo_usuario);
	}
}

/*
Analisa a validade de uma jogada de bandeira.
*/
void jogada_bandeira(char campo_usuario[]){ // recebo, ex A2 xc
	if(campo_usuario[x*linhas+y] == '+'){
		campo_usuario[x*linhas + y] = 'F';
		bombas_encontradas++;
	} else if(campo_usuario[x*linhas+y] == 'F'){
		campo_usuario[x*linhas + y] = '+';
		bombas_encontradas--;
	}else {
		cout << "Não é possível colocar uma bandeira" << endl;
	}
}

/*
Analisa a validade de uma jogada de interrogação.
*/
void jogada_interrogacao(char campo_usuario[]){
	if(campo_usuario[x*linhas+y] == '+' || campo_usuario[x*linhas+y] == 'F'){
		campo_usuario[x*linhas+y] = '?';
	} else if(campo_usuario[x*linhas+y] = '?'){
		campo_usuario[x*linhas+y] = '+';
	} else {
		cout << "Não é possível colocar um ?" << endl;
	}
}

/*
Como a primeira jogada não pode ser uma bomba, ela é especial, pois as bombas só são geradas após ela ocorrer.
*/
void primeira_jogada (char campo_interno[], char campo_usuario[]) {

	campo_interno[x*linhas + y] = '0';
	quadrados_revelados++;
	
    gera_bombas(campo_interno);
    
    preenche_campo_com_zeros (campo_interno);

    // calcula o valor de cada quadrado baseado em quantas bombas existem ao seu redor
    for (int i = 0; i < linhas; i++) {
        for (int j = 0; j < colunas; j++) {
            if (campo_interno[i*linhas + j] == 'B')
                calcula_arredores (campo_interno, i, j);
        }
    }

    // poe o valor do quadrado do campo interno no campo do usuario (caso a primeira jogada tenha alguma bomba ao redor)
    campo_usuario[x*linhas + y] = campo_interno[x*linhas + y];
	revela(campo_interno, campo_usuario);


}

/*
Analisa que tipo de jogada será realizada.
*/
void jogada (char campo_interno[], char campo_usuario[]) {
	pega_jogada();
	if(m == 'R') {
		if (primeira) {
			if (campo_usuario[x*linhas + y] == 'F')
				cout << endl << "Não é possível revelar uma bandeira!" << endl << endl;
			else {
				primeira_jogada(campo_interno, campo_usuario);
				primeira = false;
			}
		} else 
			jogada_revelar(campo_interno, campo_usuario);
	}
	else if(m == 'F')
		jogada_bandeira(campo_usuario);
	else if(m == '?')
		jogada_interrogacao(campo_usuario);
	else
		cout << "Jogada inválida." << endl;
}

/*
Método que "roda" o jogo em si. Contém todos os outros.
*/
void inicia_jogo () {
	tempoInicio();
    char campo_interno[linhas * colunas];
    char campo_usuario[linhas * colunas];


    preenche_campo (campo_interno);
    preenche_campo (campo_usuario);

    imprime_campo (campo_usuario);

	
	jogada(campo_interno, campo_usuario);

	cout << "Quadrados revelados: " << quadrados_revelados << "/" << linhas*colunas - bombas << endl;
	cout << "Bombas encontradas: " << bombas_encontradas << "/" << bombas << endl;
    tempoFim();

	while (!perdeu && !venceu && m != 'S') {
		cout << endl;
		cout << "-=-=-=-=-=-=- CAMPO MINADO -=-=-=-=-=-=-=-" << endl;
		imprime_campo(campo_usuario);
		jogada(campo_interno, campo_usuario);
		cout << "Quadrados revelados: " << quadrados_revelados << "/" << linhas*colunas - bombas << endl;
		cout << "Bombas encontradas: " << bombas_encontradas << "/" << bombas << endl;
		tempoFim();
		if (quadrados_revelados == (linhas*colunas - bombas)) {
			venceu = true;
			tempoFim();
		}
	}
	imprime_campo(campo_interno);
}


/*
Usado para iniciar um contador de tempo.
*/
void tempoInicio (){

    //iniciando a contagem do tempo
    tInicio = clock();
}

/*
Usado para saber quanto tempo se passou desde o início do contador.
*/
 void tempoFim(){

    //terminando a contagem do tempo
    tFim = clock();

    //calcuulando o tempo decorrido
    tDecorrido= ((double)((tFim-tInicio)/100)); //aqui simplesmente estamos calculando o tempo que inicio e o tempo que terminou e subtraindo o valor

    printf("Tempo gasto: %.2f s\n", tDecorrido);
}
