# six-degrees-imdb-visualisation
Visualising six degrees of separation with imdb data

## Goal

Have a website interface to pick two actors, and then visualise the degrees of separation with d3 graph type visualisation.

## Steps

1. Create ES database
2. Download IMDb dataset
3. Injest data into ES
4. Write code to find paths between ActorA and ActorB
5. Visualise paths in d3 graph type visualisation.
6. Implement web interface *(the great unknown...)*

## Inspiration

* [The Oracle of Bacon](https://oracleofbacon.org/)
* [Breadth-First Search - Kevin Bacon](https://thecodingtrain.com/CodingChallenges/068.1-bfs-kevin-bacon.html)

## Reference Notes

### ES

* https://github.com/elastic/elasticsearch-ruby

### IMDb

* https://www.imdb.com/interfaces/

### D3

* https://observablehq.com/@d3/force-directed-graph
* https://observablehq.com/@d3/disjoint-force-directed-graph
* https://observablehq.com/@d3/mobile-patent-suits

## ToDo

Well, all the above. Certain components have been tested, but need to go through step by step and do it properly.
Step 6 is the main one that illudes me at the moment.

## Notes

The project will use the IMDb dataset. This dataset is available for personal and non-commercial use.

## Contributions

Pull requests welcome :)

## Contact

jw [@] jaxenwood.com
