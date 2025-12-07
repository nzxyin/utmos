#!/bin/bash

#SBATCH --job-name=eval_librittsr
#SBATCH --error=err/eval_librittsr_%A_%a.err
#SBATCH --output=out/eval_librittsr_%A_%a.out
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
    "/data/user_data/xoy/LibriTTS_R/test-clean"
    "/data/user_data/xoy/LibriTTS_R/test-clean-indextts-synthesized"
    "/data/user_data/xoy/LibriTTS_R/test-clean-sparc-resynth"
    "/data/user_data/xoy/LibriTTS_R/dev-clean"
    "/data/user_data/xoy/LibriTTS_R/dev-clean-sparc-resynth"
)

INPUT_DIR=${DATASETS[$SLURM_ARRAY_TASK_ID]}
OUTPUT_DIR="../results/LibriTTS_R/$(basename $INPUT_DIR)"

mkdir -p $OUTPUT_DIR
echo "Running MOS evaluation on $INPUT_DIR"
uv run mos.py --input-dir $INPUT_DIR --output-dir $OUTPUT_DIR
echo "Results saved to $OUTPUT_DIR"