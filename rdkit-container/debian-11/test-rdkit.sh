#!/bin/sh

python3 -c "from rdkit import Chem; m = Chem.MolFromSmiles('Cc1ccccc1');print(m);print(m.GetNumAtoms())"
