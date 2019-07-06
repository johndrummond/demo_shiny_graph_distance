# Demo Shiny Graph Distance
A simple shiny app calculating a distance measure on a graph, including docker file

## Overview

This is a demonstration package, illustrating Shiny, running in Docker as an R process.

## Issue Solved

Consider a graph of two  types of nodes, U and P. 

Each node is only connected to nodes of the other type. All connections are of equal weight.

Starting with two U nodes, what is the shortest distance between the nodes, where:

If the nodes are the same the distance is defined as -1

If the nodes are not connected, the distance is defined as 0

Otherwise the distance is defined as the number P nodes on the shortest path between the U nodes

