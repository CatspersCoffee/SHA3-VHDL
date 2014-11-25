This project is Hardware implementation of SHA-3(keccak) cryptographic hash function using VHDL designed by Guido Bertoni, Joan Daemen, Michaël Peeters, and Gilles Van Assche, building upon RadioGatún.

SHA-3 uses the sponge construction in which message blocks are XORed into a subset of the state, which is then transformed as a whole. In the version used in SHA-3, the state consists of a 5×5 array of 64-bit words, 1600 bits total.

references
http://keccak.noekeon.org/

The project can also be found on opencores at http://opencores.org/project,sha-3