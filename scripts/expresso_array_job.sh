#!/bin/bash

#SBATCH --job-name=eval_expresso
#SBATCH --error=err/eval_expresso_%A_%a.err
#SBATCH --output=out/eval_expresso_%A_%a.out
#SBATCH --partition=array
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --gpus-per-task=1
#SBATCH --array=0-4
#SBATCH --mem=32G
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=xoy@andrew.cmu.edu

source ../.venv/bin/activate

DATASETS=(
    "/data/hf_cache/expresss2s/datasets/expresso/ground_truth"
    "/data/hf_cache/expresss2s/runs/IndexTTS2/gens/expresso"
    "/data/hf_cache/expresss2s/runs/IndexTTS2-ft/stress17k/gens/expresso"
    "/data/hf_cache/expresss2s/runs/IndexTTS2-ft/paraspeechcap/gens/expresso"
    "/data/hf_cache/expresss2s/runs/IndexTTS2-ft/stress17k-paraspeechcap/gens/expresso"
)

OUTPUT_BASENAMES=(
    "gt"
    "indextts2_base"
    "indextts2_ft_stress17k"
    "indextts2_ft_pscaps"
    "indextts2_ft_stress17k_pscaps"
)

INPUT_DIR=${DATASETS[$SLURM_ARRAY_TASK_ID]}
OUTPUT_BASENAME=${OUTPUT_BASENAMES[$SLURM_ARRAY_TASK_ID]}
OUTPUT_DIR="../results/expresso/$OUTPUT_BASENAME"

mkdir -p $OUTPUT_DIR
echo "Running MOS evaluation on $INPUT_DIR"
uv run mos.py --input-dir $INPUT_DIR --output-dir $OUTPUT_DIR
echo "Results saved to $OUTPUT_DIR"