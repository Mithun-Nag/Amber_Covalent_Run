#!/bin/bash
#SBATCH --job-name=AMBER_6ONI_ligand
#SBATCH --mail-user=mithun.nag.karadi.giridhar@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1                    # Only 1 task needed (no MPI here)
#SBATCH --cpus-per-task=1
#SBATCH --mem=60G
#SBATCH --time=10-00:00:00
#SBATCH --gres=gpu:nvidia_rtx_a6000:3 # Request 3 GPUs
#SBATCH --partition=batch_gpu
#SBATCH --account=csb_gpu_acc
#SBATCH --output=HREMD_out_%j.log
#SBATCH --error=HREMD_err_%j.log

module purge
module load StdEnvACCRE/2023
module load gcc/12.3 openmpi/4.1.5 cuda/12.2
module load ambertools/25.0
module load scipy-stack/2025a
module load amber/24

# === Setup replicate directories and copy required files ===
for rep in rep1 rep2 rep3; do
    if [ ! -d "$rep" ]; then
        echo "📂 Creating $rep"
        mkdir "$rep"
    fi

    for f in production.pl prod1.in prod1.in.start; do
        if [ ! -f "$rep/$f" ]; then
            echo "📄 Copying $f to $rep"
            cp "$f" "$rep/"
        fi
    done
done

# === Launch production runs on separate GPUs ===
gpu=0
for rep in rep1 rep2 rep3; do
    echo "🔹 Starting production for $rep on GPU $gpu"
    cd "$rep"
    CUDA_VISIBLE_DEVICES=$gpu perl production.pl > "PRODUCTION_${rep}.OUT" 2> "ERROR_${rep}.LOG" &
    cd ..
    gpu=$((gpu+1))
done

# Wait for all jobs to finish
wait
echo "✅ All replicates completed (each ran on its own GPU)."
