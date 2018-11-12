C++ streams have been criticized for not being optimal. All implementations do it as good as it possibly can be but it's the specification that limits performance (the presence of certain functions and their expected behaviour). Each system does file reading/writing differently which makes it hard to provide a very efficient interface for all systems.

The standard library in this area is more designed around compatibility, type safety and convenience rather than performance.

The truth is that no programming language has perfect implementation and if one wants absolutely highest performance they need to dig into system's interface and write code specifically for the choosen system. Fortunately while C++ may be criticized for the standard library API it has an extraordinary power to write everything from scrach since the entire language has no underlying layer - practically any task has already multiple libraries for it.

Part of C++ is also inventing and critical thinking so if you know the language well and like to experiment don't hesistate. A lot of projects use standard library in a very limited fashion.

Of course, since you are still in the beginner's tutorial I will use standard library for examples.
