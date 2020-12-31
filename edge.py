#!/usr/bin/env python3
# coding=utf-8
import sys

def help():
    print(
        '''
         ------------------------POMOC------------------------

         Witaj w pomocy dla programu edge.py
         W pliku została zaimplementowana klasa edge, reprezentujaca krawedz o nieujemnej wadze.
         Krawedz tworzona jest pomiedzy dwoma wierzcholkami- wierzcholkiem 
         poczatkowym od ktorego odchodzi krawedz, a  wierzcholkiem koncowym do ktorego dochodzi krawedz.
         Plik jest jedynie czescia calego programu w ktorym jest zaimplementowana
         spojna calosc grafu. Aby dowiedziec sie jak skorzystac z programu uruchom 'main.py -h' 
        '''
    )

for arg in sys.argv:
    if arg == '-h':
        help()
        sys.exit()

""" klasa reprezentujaca krawedz
 initialVertex- poczatkowy wierzcholek
 terminalVertex- koncowy wierzcholek
 weight- waga krawedzi pomiedzy poczatkowym wierzcholiek a wierzcholkiem poczatkowym """
class Edge:

    def __init__(self, initialVertex, terminalVertex, weight=1):
        self.initialVertex = initialVertex
        self.terminalVertex = terminalVertex
        self.weight = weight
        if weight < 1:
            raise ValueError('waga krawedzi nie moze byc mniejsza niz 1')



    """ reprezentacja napisowa klasy Edge
    wypisuje wyierzcholki oraz wage krawedzi miedzy nimi """
    def __repr__(self):
        if self.weight != 0:
            return "Edge(%s, %s, %s)" % (
                repr(self.initialVertex), repr(self.terminalVertex), repr(self.weight))