#!/usr/bin/env python3
# coding=utf-8
import sys


def help():
    print(
        '''
         ------------------------POMOC------------------------

         Witaj w pomocy dla programu graph.py
         W pliku zostala zaimplementowana klasa Graph. Jest to macierzowa reprezentacja grafu, zarowno skierowanego
         jak i nieskierowanego o krawedziach wazonych. Plik jest jedynie czescia calego programu 
         w ktorym jest zaimplementowana spojna calosc grafu.
         Aby dowiedziec sie jak skorzystac z programu uruchom 'main.py -h'   
        '''
    )


for arg in sys.argv:
    if arg == '-h':
        help()
        sys.exit()

""" klasa reprezentujaca graf nieskierowany w postaci kwadratowej macierzy sasiedzwa z wagami
 size- wielkosc macierzy
 edges- lista krawedzi tworzaca graf"""
class Graph:

    def __init__(self, size, directed=False):
        if size <= 1:
            raise ValueError('podaj liczbe wieksza od jedynki!')
        self.size = size
        self.directed = directed
        self.matrix = [[0] * size for i in range(size)]
        # for edge in edges:
        #     self.matrix[edge.initialVertex][edge.terminalVertex] = edge.weight
        #     self.matrix[edge.terminalVertex][edge.initialVertex] = edge.weight


    def isDirected(self):
        return self.directed


    def getSizeOfGraph(self):
        return self.size

    def isEdgeInGraph(self, Edge):
        if Edge.initialVertex >-1 and Edge.initialVertex < self.size and Edge.terminalVertex >-1 and Edge.terminalVertex < self.size:
            return self.matrix[Edge.initialVertex][Edge.terminalVertex] != 0
        else:
            raise ValueError('Podana krawedz nie wystepuje w grafie!')


    def isEdgeInGraph(self, initialVertex, terminalVertex):
        if initialVertex >-1 and initialVertex < self.size and terminalVertex >-1 and terminalVertex < self.size:
            return self.matrix[initialVertex][terminalVertex] != 0
        else:
            raise ValueError('Podana krawedz nie wystepuje w grafie!')



    def getWeightOfTheEdge(self, initialVertex, terminalVertex):
        if(self.isEdgeInGraph(initialVertex, terminalVertex)):
            return self.matrix[initialVertex][terminalVertex]


    """ funkcja ktora wypisuje macierz na ekran
     funkcja zwraca strninga"""
    def showMatrix(self):
        string = ""
        for i in range(self.size):
            for j in range(self.size):
                string = string + str(self.matrix[i][j]) + "\t"
                if(j == self.size - 1):
                    string += "\n"
        return string

    def hasEdge(self, edge):
        if (edge.initialVertex < self.size) and (edge.initialVertex >= 0) and \
                (edge.terminalVertex < self.size) and (edge.terminalVertex >= 0):
            return self.matrix[edge.initialVertex][edge.terminalVertex] != 0
        else:
            raise ValueError('podana wierzcholki nie naleza do tego grafu!')


    """" funkcja dodajaca krawedz do grafu"""
    def add_edge(self, initialVertex, terminalVertex, weight):

        if (initialVertex < self.size) and (terminalVertex < self.size) and \
                (initialVertex > -1) and (terminalVertex > -1):
            if self.directed:
                if self.matrix[initialVertex][terminalVertex] == 0:
                    self.matrix[initialVertex][terminalVertex] = weight
                else:
                    raise ValueError("Miedzy podanymi wierzcholkami grafu juz istnieje krawedz")
            else:
                if self.matrix[initialVertex][terminalVertex] == 0:
                    self.matrix[initialVertex][terminalVertex] = weight
                    self.matrix[terminalVertex][initialVertex] = weight
        else:
            raise ValueError("Podane wierzhołki nie należa do grafu")


    """" funkcja usuwajaca krawedz z grafu """
    def del_edge(self, initialVertex, terminalVertex):
        if (initialVertex < self.size) and (terminalVertex < self.size):
            self.matrix[initialVertex][terminalVertex] = 0
            self.matrix[terminalVertex][initialVertex] = 0
        else:
            raise ValueError("Podane wierzcholki nie naleza do grafu")


    def iteradjacent(self, node):
        """ iterator po wierzchołkach sąsiednich"""
        for item in self.matrix[node]:
            if item != 0:
                yield self.matrix[node].index(item)
