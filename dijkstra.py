#!/usr/bin/env python3
# coding=utf-8
import sys


def help():
    print(
        '''
         ------------------------POMOC------------------------
         
         Witaj w pomocy dla programu dijkstra.py
         W pliku został zaimplementowany algorytm dijkstra. Algorytm zaimplementowany jest dla
         macierzowej reprezentacji grafu. Wywolanie metody dijkstraAlgorithm zwraca dwie tablice: 
         self.distance- wartosci najkrotszych sciezek,
         predecessor- wartosci poprzedniego wierzcholka od ktorego doszlismy do danego wierzcholka.
         Z tego pliku korzystają rowniez inne pliki tworzac spojna calosc impelentacji grafu,
         aby dowiedzieć się jak z niego skorzystać
         uruchom 'main.py -h' 
        '''
    )


for arg in sys.argv:
   if arg == '-h':
      help()
      sys.exit()


""""" funkcja ktora oblicza najmniejsze mozliwe odleglosci
     do wszystkich wierzcholkow w grafie od zadanego poczatkowego wierzcholka
     startingVertex- poczatkowy wierzcholek
     funkcja zwraca dwie tablice: self.distance- wartosci najkrotszych sciezek,
     predecessor- wartosci poprzedniego wierzcholka od ktorego doszlismy do danego wierzcholka """

class Dijkstra:
    def __init__(self, graph):
        self.graph = graph
        self.size = graph.size
        self.distance = [sys.maxsize] * self.size
        self.predecessor = [-1] * self.size
        self.qs = [False] * self.size

    def dijkstraAlgorithm(self, startingVertex):
        self.distance[startingVertex] = 0

        for i in range(self.size):
            minValue = sys.maxsize
            minIndex = 0

        for j in range(self.size):
            if self.qs[j] is True:
                continue
            if self.distance[j] < minValue:
                minValue = self.distance[j]
                minIndex = j

        self.qs[minIndex] = True

        for k in range(self.size):

            if self.qs[k] is True or self.graph.matrix[minIndex][k] == 0:
                continue

            if self.distance[k] > self.distance[minIndex] + self.graph.matrix[minIndex][k]:
                self.distance[k] = self.distance[minIndex] + self.graph.matrix[minIndex][k]
                self.predecessor[k] = minIndex

        return self.distance, self.predecessor