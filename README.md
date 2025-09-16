# 🧪 Amber Covalent Ligand–Protein MD Run  
This repository contains a Jupyter Notebook workflow for setting up and running a fully solvated molecular dynamics simulation of a **covalent protein–ligand complex** (PPARγ + EEY) using **Amber 24** and **AmberTools 25**.

---

## 📂 Contents
**Covalent_Input_Prep.ipynb** – System preparation and parameterization:  
- Uses files that were already generated from **H++ server** for protein protonation and **R.E.D. server** for RESP charge derivation.  
- Guides through **PyMOL/Chimera** steps for ligand extraction, protonation, and covalent bond creation.  
- Important for Amber pre processing steps : Runs Antechamber and `parmchk2` to generate the ligand `.ac`, `.prepin`, and `frcmod` parameter files for LEaP.  


**Minimization_Production.ipynb** – System build and MD run:  
- Merges the protonated protein and parameterized ligand into a single covalent complex.  
- Solvates the system with TIP3P water and neutralizes with counterions.  
- Performs staged minimization (restrained → unrestrained).  
- Runs NVT and NPT equilibration to stabilize the system.  
- Launches production MD using `production.pl` in multiple 100 ns chunks (extendable for μs-scale runs).

---

## 🏗️ System Setup
Amber 24 and AmberTools 25 were used for all steps.  

Although designed for **ACCRE (Vanderbilt University HPC cluster)**,  
this workflow can be easily adapted to other HPC clusters or even a local AMBER installation.

**Important:**  
- On ACCRE, the notebook loads the required Amber modules.  
- On other systems, adjust the `module load` lines to match your environment.  
- If modules are not available, you can source Amber manually at the top of the notebook:  
```bash
!source /sb/apps/amber22/amber.sh


    (\_/)
   ( •_•)   Covalent Setup Complete
   / >🍵   Time to Relax & Run MD!
  /   | \
 /    |  \
/_____|___\

 Happy Simulation!
