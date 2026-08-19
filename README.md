## Etherium <-> Solona bridge 

#### Project set up

initalise the forge project 
```bash 
forge init bridgemesh
```

add OpenZeppelin lib
```bash 
forge install OpenZeppelin/openzeppelin-contracts
```

add remappings 
```bash 
nano remappings.txt
@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/
```