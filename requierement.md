# Linked dependencies in a distributed build

dependencies that cross from one side of the graph to the other are handled
properly if the dependency is properly available in the other process, this
means that, when cross graph dependencies exist, all code must be available; in
the opposite case only part of the source needs to be available.

nodes that are dependencies to multiple dependent must be build just once,
having the graph in one place guaranties that the node will be build once

```
                          .------.
              .-----------| root |---------.
              |           '------'         |       other process
              |               .------------|-------------.
              v               |            v             |
            .--.              |          .--.            |
        .---'--'              |      .---'--'---.        |
        |     |               |      |          |        |
        v     |               |      v          v        |
      .--.    |      link     |    .--.       .--.       |
   .--'--'    .--------------------'--'       '--'       |
   |          |               |      |                   |
   v          |               |      v                   |
 .--.         v               |    .--.                  |
 '--'       .--.              |    '--'                  |
            '--'              |                          |
                              '--------------------------'
```

## Problem

there is no way to know if a node is linked  or local; a guess could be
possible if the path to the node didn't match the current process' top node
path but it's a guess

### Current implementation

this is different from the parallel PBS implementation where the top node has a
full graph and starts builds, it distributes the link checking and also lets
subpbses start builds which is better but also means that resource to build
must be queried from the building subpbs; a resource manager must exist for
each build-node

## Solution

sub processes could return the node names with the trigger information, parent
processes can detect the link and see that the build sequence is correct

## Access to nodes produces in another build node

nodes that are dependencies to multiple dependent must be build just once,
having the graph in one place guaranties that the node will be build once

linked nodes that are produced in a different build-node must be transferred,
or a duplicate build locally which itself may need many dependencies to be
build with the risk that the local node is not the same as the one on other
build-nodes


