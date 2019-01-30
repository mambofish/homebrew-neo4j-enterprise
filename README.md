# Install Enterprise Neo4j using Homebrew on macOS/linux

To install the **enterprise edition** of Neo4j using Homebrew on [macOS](https://brew.sh) or [linux](https://github.com/Linuxbrew/brew), first install this tap (you only need to do this once):

```
brew tap graphaware/neo4j-enterprise
brew unlink neo4j # in case you're linked to the latest community version
```

After the tap is installed, install the latest enterprise edition of Neo4j:

```
brew install neo4j-enterprise
```

All the usual commands such as `neo4j start` will work as expected, including `brew service` (if you want to run the instance as a service)
