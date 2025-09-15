#!/bin/bash
# load script using: tleap -s -f script-name.tleap

source leaprc.protein.ff14SB
source leaprc.gaff2
source leaprc.water.tip3p
loadamberparams frcmod.ionsjc_tip3p

loadAmberPrep t007.prepin
loadAmberParams ../ligand_prep/frcmod2.t007
loadAmberParams ../ligand_prep/frcmod1.t007

complex = loadpdb ../Models/PPARg_T007_combined1.pdb   # residue 285 renamed to T00; names match prepin

addions complex Na+ 4
addions complex Cl- 0

solvateoct complex TIP3PBOX 10.0 iso

#addions complex K+ 16
#addions complex Cl- 16

saveamberparm complex prepin.prmtop prepin.inpcrd
savepdb       complex prepin.pdb
quit
