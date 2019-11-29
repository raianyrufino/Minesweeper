:- use_module(library(clpfd)).

% swipl -q -f campo_minado.pl
% jogar(numDeColunas, numDeLinhas).
% R linha coluna = revela essa posição
% F linha coluna = marca
% ? linha coluna = interrogação

jogar(Linhas,Colunas,NBombas) :-
	format('
Bem vindo ao campo minado!
Regras:
: R X Y  Revela, exemplo: R 1 2 - Revela posição 1(linha) 2(coluna).
: ? X Y  Interrogação: ? 1 2 - Insere uma ? na posição 1(linha) 2(coluna).
: F X Y  Flag, exemplo: B 1 2 - Insere uma flag na posicao 1(linha) 2(coluna). 

Qualquer outra coisa para sair do jogo

Obs.: para vencer, você deve revelar todas as posições que não contém uma bomba,
      e indentificar todas as bombas com a marcação.
		
'),
	gera_campo(Colunas, Linhas, NBombas, Campo),
	!,
	jogar(Campo),
	!.

jogar(Campo) :- % jogador venceu
	percorre_campo(venceu, Campo),
	percorre_campo(imprime_campo, Campo),
	writeln('Você venceu!

Créditos:	
			
PLP 2019.2   
Everton L. G. Alves
	
Grupo:   
Diego Ribeiro de Almeida                          
Iago Tito Oliveira                             
Paulo Mateus Alves Moreira                           
Raiany Rufino Costa da Paz
		').

jogar(Campo) :- % jogador perdeu
	\+ percorre_campo(jogando, Campo),
	percorre_campo(imprime_campo, Campo),
	writeln('Você perdeu!

Créditos:	
			
PLP 2019.2   
Everton L. G. Alves
	
Grupo:   
Diego Ribeiro de Almeida                          
Iago Tito Oliveira                             
Paulo Mateus Alves Moreira                           
Raiany Rufino Costa da Paz
		').

jogar(Campo) :- % jogador nem venceu nem perdeu
	percorre_campo(imprime_campo, Campo),
	pega_jogada(Jogada, X, Y),
	realiza_jogada(Jogada, coordenada(X,Y), Campo, CampoAposJogada),
	!,
	jogar(CampoAposJogada).

% Cria um novo Campo
gera_campo(Linhas, Colunas, NBombas, campo(Linhas,Colunas,PosicoesMapeadas)) :-
	% gera uma lista
	Len is Linhas * Colunas,
	length(Posicoes, Len),

	length(ListaBombas, NBombas),
	maplist(=('P'), ListaBombas),

	% concatena a lista de bombas com a lista original
	adiciona_bombas(Posicoes, ListaBombas, NovoCampo),

	% mistura as bombas no tabuleiros em posições aleatórias
	random_permutation(NovoCampo, CampoAleatorio),
	
	% converte a lista inicial para uma matriz
	gera_colunas(CampoAleatorio, Linhas, Colunas, CampoFinal),

	percorre_campo(calcula_bombas_adjacentes(campo(Linhas,Colunas,CampoFinal)), campo(Linhas,Colunas,CampoFinal), campo(Linhas,Colunas,PosicoesMapeadas)).

% função para concatenar as bombas na lista
adiciona_bombas(P, [], P).
adiciona_bombas([_|Pt], [B|Bt], [B|L]) :-
	adiciona_bombas(Pt, Bt, L).

gera_colunas([], _, 0, []).
gera_colunas(P, Linhas, Colunas, [Linha|PosicoesRestantes]) :-
	dif(Colunas, 0), succ(LinhasAux, Colunas),
	gera_linhas(P, Linhas, Linha, Resto),
	gera_colunas(Resto, Linhas, LinhasAux, PosicoesRestantes).

gera_linhas(T, 0, [], T).
gera_linhas([H|T], Linhas, [H|L], Resto) :-
	dif(Linhas, 0), succ(ColunasAux, Linhas),
	gera_linhas(T, ColunasAux, L, Resto).

% calula o valor de cada posição baseado em quantas bombas existem ao redor usando mapgrid
calcula_bombas_adjacentes(_, _, _, P, posicao('+',P)) :- P =@= 'P'.
calcula_bombas_adjacentes(Campo, coordenada(X,Y), D, Posicao, posicao('+',NumBombas)) :-
	dif(Posicao, 'P'),
	findall(coordenada(Ay,Ax), (
		posicoes_adjacentes(coordenada(X,Y), D, coordenada(Ay,Ax)),
		indomain(Ay), indomain(Ax),
		pega_valor_yx(Campo, coordenada(Ay,Ax), Val),
		Val =@= 'P'
	), Bombas),
	length(Bombas, NumBombas).

imprime_campo(coordenada(X,_), dim(X,_), posicao(P,A), posicao(P,A)) :- format("~w~n", P).
imprime_campo(coordenada(X,_), dim(Linhas,_), posicao(P,A), posicao(P,A)) :- dif(X,Linhas), format("~w ", P).

jogando(_,_,posicao(A,_),_) :- A \= 'B'.

venceu(_,_,posicao(N,N),_) :- integer(N).
venceu(_,_,posicao('P','P'),_).

% função auxiliar
percorre_campo(PosicaoFinal, C) :- percorre_campo(PosicaoFinal, C, C).

percorre_campo(PosicaoFinal, campo(Linhas,Colunas,Posicoes), campo(Linhas,Colunas,CampoRetorno)) :-
	percorre_colunas(Posicoes, 1, dim(Linhas,Colunas), PosicaoFinal, CampoRetorno).

percorre_colunas([], _, _, _, []).
percorre_colunas([Colunas|T], Y, D, PosicaoFinal, [NLinha|NColuna]) :-
	percorre_linhas(Colunas, coordenada(1, Y), D, PosicaoFinal, NLinha),
	succ(Y, Y1),
	percorre_colunas(T, Y1, D, PosicaoFinal, NColuna).

percorre_linhas([], _, _, _, []).
percorre_linhas([Colunas|T], coordenada(X, Y), D, PosicaoFinal, [Posicao|L]) :-
	call(PosicaoFinal, coordenada(X, Y), D, Colunas, Posicao),
	succ(X, X1),
	percorre_linhas(T, coordenada(X1, Y), D, PosicaoFinal, L).

% retorna o valor na posição yx
pega_valor_yx(campo(_,_,Posicoes), coordenada(X,Y), Val) :-
	nth1(Y, Posicoes, Linha), % nth1 pega a N-ésima posição da lista,
							  % no caso, a x-ésima posição em Posicoes, que é uma linha
	nth1(X, Linha, Val). % aqui a y-ésima posição é um valor

% define o valor na posicao yx
define_yx(campo(Linhas,Colunas,Posicoes), coordenada(X,Y), Val, campo(Linhas,Colunas,NovaPosicao)) :- define_coluna(Posicoes, X, Y, Val, NovaPosicao).
define_coluna([Colunas|T], X, 1, Val, [Linha|T]) :- define_linha(Colunas, X, Val, Linha).
define_coluna([Colunas|T], X, Y, Val, [Colunas|Nova]) :- dif(Y, 0), succ(Y1, Y), define_coluna(T, X, Y1, Val, Nova).
define_linha([_|T], 1, Val, [Val|T]).
define_linha([Colunas|T], X, Val, [Colunas|Nova]) :- dif(X, 0), succ(X1, X), define_linha(T, X1, Val, Nova).

% retorna as posições adjacentes a uma posição
posicoes_adjacentes(coordenada(X,Y), dim(Linhas,Colunas), coordenada(Ay,Ax)) :-

	dif(coordenada(X,Y),coordenada(Ay,Ax)),

	Ay in 1..Linhas,
	Ymin #= X-1, Ymax #= X+1,
	Ay in Ymin..Ymax,

	Ax in 1..Colunas,
	Xmin #= Y-1, Xmax #= Y+1,
	Ax in Xmin..Xmax.

pega_jogada(Jogada, X, Y) :-
	read_line_to_codes(user_input, In),
	maplist(char_code, InChars, In),
	phrase(tipo_jogada(Jogada, Y, X), InChars, []).

tipo_jogada(interrogacao, X, Y) --> [?], [' '], coords(X, Y).
tipo_jogada(bandeira, X, Y) --> ['F'], [' '], coords(X, Y).
tipo_jogada(revela, X, Y) --> ['R'], [' '], coords(X, Y).
coords(Xi, Yi) --> number_(X), { number_chars(Xi, X) }, [' '], number_(Y), { number_chars(Yi, Y) }.

number_([D|T]) --> digit(D), number_(T).
number_([D]) --> digit(D).
digit(D) --> [D], { char_type(D, digit) }.

% Jogada de interrogacao
realiza_jogada(interrogacao, P, C, NovoC) :-
	pega_valor_yx(C, P, posicao(_,A)),
	define_yx(C, P, posicao('?',A), NovoC).

% Jogada de bandeira
realiza_jogada(bandeira, P, C, NovoC) :-
	pega_valor_yx(C, P, posicao(_,A)),
	define_yx(C, P, posicao('P',A), NovoC).

% Jogada de revelar, quando revela uma bomba
realiza_jogada(revela, P, C, NovoC) :-
	pega_valor_yx(C, P, posicao(_,'P')),
	define_yx(C, P, posicao('B','P'), NovoC).

% Jogada de revelar, quando não revela uma bomba
realiza_jogada(revela, P, C, NovoC) :-
	pega_valor_yx(C, P, posicao(_,A)),
	dif(A, 'P'),
	define_yx(C, P, posicao(A,A), NovoC1),
	revela_recursivo(P, NovoC1, NovoC).

% revela recursivo
revela_recursivo(coordenada(X,Y), campo(Linhas,Colunas,Posicoes), NovoC2) :-
	findall(coordenada(Ay,Ax), (
		    posicoes_adjacentes(coordenada(X,Y), dim(Linhas,Colunas), coordenada(Ay,Ax)),
		    indomain(Ay), indomain(Ax)
		), Coords),
	revela_recursivo_(Coords, campo(Linhas,Colunas,Posicoes), NovoC2).

revela_recursivo_([], C, C).

revela_recursivo_([Colunas|T], C, NovoC) :-  % se a posição já tiver sido revelada
	pega_valor_yx(C, Colunas, posicao(A,B)),
	member(A, [B,'P']),
	revela_recursivo_(T, C, NovoC).

revela_recursivo_([Colunas|T], C, NovoC) :- % se a posição for uma bomba, não revela
	pega_valor_yx(C, Colunas, posicao(_,'P')),
	revela_recursivo_(T, C, NovoC).

revela_recursivo_([Colunas|T], C, NovoC) :- % se a posição tem bombas ao redor
	pega_valor_yx(C, Colunas, posicao(_,N)),
	integer(N),
	N #> 0,
	define_yx(C, Colunas, posicao(N,N), NovoC1),
	revela_recursivo_(T, NovoC1, NovoC).

revela_recursivo_([Colunas|T], C, NovoC) :- % não tem bombas ao redor, revela recursivamente
	pega_valor_yx(C, Colunas, posicao('+',0)),
	define_yx(C, Colunas, posicao(0,0), NovoC1),
	revela_recursivo(Colunas, NovoC1, NovoC2),
	revela_recursivo_(T, NovoC2, NovoC).