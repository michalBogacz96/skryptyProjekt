#!/usr/bin/env python3
# coding=utf-8

import sys
import random



def help_main():

    print(
        '''
        ------------------------POMOC---------------------
        Witaj w pomocy dla pliku main.py. Plik prezentuje mozliwosci zaimplementowanego na macierzy siasiedztwa
         grafu skierowanego oraz nieskierowanego. w sklad calego programu wchodza
         
        - plik główny main.py to jego należy wywołać, aby uruchomić cały program,
        - plik graph.py implementacja grafu na macierzy sąsiedztwa 'graph.py', 
        - plik edge.py implementacja reprezentacji krawędzi więcej 'edge.py -h'
        - plik dijkstra.py implementacja algorytmu dijkstra więcej 'dijkstra.py -h',
        
        Zadaniem programu jest wygenerowanie losowego grafu o zadanym przez użytkownika rozmiarze,
         który jest przekazywany w parametrze wywołania programu. 
        Uruchomienie programu: 'pyton3 main.py /parametr/'
        Należy pamiętać, aby graf był przynajmniej wielkości 4. W innym przypadku zostanie wyswietlony komunikat,
        ze podany argument jest bledny i zostanie wyswietlona pomoc.
        Następnie na tak wygenerowanym grafie zostanie wywołany szereg zaimplementowanych
        funkcji od prostych operacji na grafach,aż po algorytm dijkstra dla grafu nieskierowanego.
        Algorytm Dijkstry- algorytm znajdowania najkrótszej ścieżki z pojedyńczego źródła
        w grafie nieskierowanym o nieujemnych wagach krawdzi.
        Zaimplementowany algorytm zwraca dwie tablice:
        -distance- służy do zapisywania najkrótszych ścieżek do danych wierzchołków. Indeksy
                tablicy odpowiadaja wierzchołkom grafu. Na początku tablica jest inicjowana maksymalna
                wartością za pomoca maxsize z modułu sys co oznacza brak znalezionej ścieżki do
                wierzchołka. W tablicy distance dla wierzchołka startowego przypisuje wartość 0.
        -predecessor- służy do zapisania poprzednika z którego się dotarło do danego wierzchołka
                określonego indeksem tablicy. Np predecessor[3] = 5- oznacza to że idąc do wierzchołka 3,
                ostatnim poprzedzonym wierzchołkiem był wierzchołek 5.
        '''
    )

if len(sys.argv) < 2:
    print("Za mala ilosc argumentow. Wyswietlam pomoc.\n")
    help_main()
    sys.exit()

for arg in sys.argv:

    if 'main.py' in arg:
        continue

    if arg == '-h':
        help_main()
        sys.exit()
    elif arg.isdigit():
        arg = int(arg)
        if arg > 3:
            sizeOfGraph = arg
        else:
            print("Wilkosc grafu musi byc wieksza od 3!\n")
            sys.exit()
    else:
        print("Nieobslugiwany klawisz. Wyswietlam pomoc.\n")
        help_main()
        sys.exit()



from graph import Graph
from edge import Edge
from dijkstra import Dijkstra

directedGraph = Graph(sizeOfGraph, True)
undirectedGraph = Graph(sizeOfGraph)



edges=[0]

for i in range(sizeOfGraph):
    for j in range(sizeOfGraph):
        if i != j:
            directedGraph.add_edge(i, j, random.randint(1,15))
            undirectedGraph.add_edge(i, j, random.randint(1,15))


print("Macierz jako reprezentacja grafu skierowanego: ")
print(directedGraph.showMatrix())


print("Macierz jako reprezentacja grafu nieskierowanego: ")
print(undirectedGraph.showMatrix())

print("\nCzy graf jest skierowany? " +str(directedGraph.isDirected()))
print("Czy graf jest skierowany? " +str(undirectedGraph.isDirected()))


print("\nCzy graf skierowany posiada krawedz 1->2? " +str(directedGraph.hasEdge(Edge(1,2))))
print("Czy graf nieskierowany posiada krawedz 1->2? " +str(undirectedGraph.hasEdge(Edge(1,2))))


print("\nUsuniecie krawedzi 1->2 jesli istnieje dla grafu skierowanego")
directedGraph.del_edge(1,2)
print("Macierz jako reprezentacja grafu skierowanego po usunieciu krawedzi 1->2: ")
print(directedGraph.showMatrix())


print("\nUsuniecie krawedzi 1->2 jesli istnieje dla grafu nieskierowanego")
undirectedGraph.del_edge(1,2)
print("Macierz jako reprezentacja grafu nieskierowanego po usunieciu krawedzi 1->2: ")
print(undirectedGraph.showMatrix())

print("\nWaga krawedzi 2->3? dla grafu skierowanego: " +str(directedGraph.getWeightOfTheEdge(2,3)))
print("Waga krawedzi 2->3? dla grafu nieskierowanego: " +str(undirectedGraph.getWeightOfTheEdge(2,3)))


print("\nIterator po wierzcholkach sasiednich w grafie skierowanym")
for i in directedGraph.iteradjacent(2):
    print(i)



dijkstra = Dijkstra(undirectedGraph)
result = dijkstra.dijkstraAlgorithm(3)

print("\nTablica najkrotszych sciezek do kolejnych wierzcholkow idac od wierzcholka 3")
print(result[0])

print("\nTablica poprzedników z ktorego sie dotarło do danego wierzcholka okreslonego indeksem"
      "tablicy. rozpoczynajac od wierzcholka 3 ")

print(result[1])
