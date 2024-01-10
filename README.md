# Herodotus Tasks

This consists of the solutions to the programs of :
1. Implementing an array sorting function in Cairo0.
2. Implementing removing duplicates from an array.
3. Implementing a binary merkle tree builder.
4. Implementing a binary range checker using only ifs → Pass a number in range 0 - 15 the program has to tell you in which quarter the provided number is. Cairo0
5. Implementing bitshifts in Cairo1.

## Getting Started

These instructions will guide you on how to run and test the programs in this repository. 

### Prerequisites

Before running the programs, ensure you have the following installed:
- Scarb (version 2.3.0)
- Protostar (version 0.8.1)
- Node.js and npm

### Installation

To install Protostar run this command :

```bash
curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash -s -- -v 0.8.1 # To install version 0.8.1
```

To install Scarb run this command :

```bash
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh -s -- -v 2.3.0 To install version 2.3.0
```

### Running the Programs

#### Cairo 0 Programs

To run the Cairo 0 programs, follow these steps:

```bash
cd cairo0
protostar build  # To build the program
protostar test   # To run the tests
```

#### Cairo 1 Program

To run the Cairo 1 program, use the following commands:

```bash
cd cairo1
scarb build  # To build the program
scarb test   # To run the test cases
```

#### Merkle Tree Script

To run the Merkle tree script:

```bash
npm i                    # To install the node modules
npx ts-node scripts/merkle.ts  # To run the script
```
