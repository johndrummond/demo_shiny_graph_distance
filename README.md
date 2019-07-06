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

Otherwise the distance is defined as the number P nodes on the shortest path between the U nodes?

## Algorithm

This is a breadth first search, starting at both endpoints.

Consider the nodes all marked gray, save for the two nodes U1 and U2 for which the distance is due to be calculated from and to. Consider these the start of two subnetworks and coloured red. 

If the nodes are the same just return a distance of -1

While the distance is not found and it's not noted that either of the subnetworks has no unlooked at connections, alternatively step out the frontiers of each subnetwork to the next set of U nodes: 

* for all U nodes on the frontier create one list of all connected P nodes that are not already coloured Red. This creates the next P node frontier. 

* If there are no such P nodes then stop as the distance is 0, else colour them red. 
* For all P node on this new P node frontier create one list of all connected U nodes that are not already coloured Red. 
* If one of this nodes is on the frontier of the other subnetwork, the shortest path has been found and is the number of Steps
* If no new U nodes are found, then stop as the distance is 0, else colour them red. 

The two subnetworks will grow, the areas of red increasing,  until they join giving the distance, or there is no join, giving the result of 0



## Other considerations and extensions

### Assumptions

If the connections change on the graph storage change during the time they are queried, it's possible that the above algorithm may return a false distance or one that was never true. Ways around this either having some for of snapshot to query, or being able to query for the state at a certain time.

### Threading

Depending on the cost of context switching and data storage, there could be significant benefits on many threads checking for each of the nodes, and on expanding both networks at the same time

### Timeout

Further consideration could be given to allowing a timeout in the calculation, or a limit in the path interested in, or what happens if the graph storage isn't available to query.

### Caching

If the store of the graph data that is queried is external to the main application, caching the external calls could make a lot of difference to querying for a second distance, at the expense of using more resources locally.

### Vectorisation

Although this is written in R, it's not currently vectorised, i.e the calculation is only between a single pair of nodes





