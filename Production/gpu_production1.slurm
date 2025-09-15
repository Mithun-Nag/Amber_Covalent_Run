#!/bin/bash
#SBATCH --job-name=AMBER_6ONI_ligand
#SBATCH --mail-user=mithun.nag.karadi.giridhar@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1                    # Only 1 task needed (no MPI here)
#SBATCH --cpus-per-task=1
#SBATCH --mem=60G
#SBATCH --time=10-00:00:00
#SBATCH --gres=gpu:nvidia_rtx_a6000:1 # Request 3 GPUs
#SBATCH --partition=batch_gpu
#SBATCH --account=csb_gpu_acc
#SBATCH --output=AMBER_out_%j.log
#SBATCH --error=AMBER_err_%j.log

module purge
module load StdEnvACCRE/2023
module load gcc/12.3 openmpi/4.1.5 cuda/12.2
module load ambertools/25.0
module load scipy-stack/2025a
module load amber/24

# === Setup replicate directories and copy required files ===
%%bash
# === Setup replicate directories and copy required files ===
for rep in rep1 rep2 rep3; do
    if [ ! -d "$rep" ]; then
        echo "📂 Creating $rep"
        mkdir "$rep"
    fi

    # Copy production files if not already present
    for f in production.pl prod1.in prod1.in.start; do
        if [ ! -f "$rep/$f" ]; then
            echo "📄 Copying $f to $rep"
            cp "$f" "$rep/"
        fi
    done
done

# === Launch production runs in parallel ===
for rep in rep1 rep2 rep3; do
    echo "🔹 Starting production for $rep"
    cd "$rep"
    perl production.pl > "PRODUCTION_${rep}.OUT" 2> "ERROR_${rep}.LOG" &
    cd ..
done

# Wait for all background jobs to finish
wait
echo "✅ All replicates completed."
