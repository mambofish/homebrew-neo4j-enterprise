# Latest Version: 5.3.0

# Install Enterprise Neo4j using Homebrew on macOS/linux

To install the **enterprise edition** of Neo4j using Homebrew on [macOS](https://brew.sh) or [linux](https://github.com/Linuxbrew/brew), first install this tap (you only need to do this once):

```
brew tap mambofish/neo4j-enterprise
brew unlink neo4j # in case you're linked to the latest community version
```

After the tap is installed, install the latest enterprise edition of Neo4j:

```
brew install mambofish/neo4j-enterprise/neo4j-enterprise
```

All the usual commands such as `neo4j start` will work as expected, including `brew service` (if you want to run the instance as a service)

# Licensing
Neo4j Enterprise Edition is *not* free software. You should purchase a licence from Neo4j if you want to use it.

# Older Versions
 
## 4.4.16 (LTS)
```
brew install mambofish/neo4j-enterprise/neo4j-enterprise@44
```

## 3.5.6
```
brew install mambofish/neo4j-enterprise/neo4j-enterprise@35
```
