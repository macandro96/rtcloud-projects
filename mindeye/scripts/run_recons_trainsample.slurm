#!/bin/bash
#SBATCH --job-name=sub-005_ses-03_rt_recon
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=1              
#SBATCH --gres=gpu:1
#SBATCH --constraint="a100|h100|rtx8000"
#SBATCH --mem=64G
#SBATCH --cpus-per-task=1      # 40 / 80 / 176 distributed across node
#SBATCH --time=02:00:00         # total run time limit (HH:MM:SS)
#SBATCH -e slurms/%A_%a.err     # first create a "slurms" folder in current directory to store logs
#SBATCH -o slurms/%A_%a.out
#SBATCH --no-requeue
#SBATCH --array=1-10              # 0 or 0-9

echo "My SLURM_ARRAY_JOB_ID is ${SLURM_ARRAY_JOB_ID}"
echo "My SLURM_ARRAY_TASK_ID is ${SLURM_ARRAY_TASK_ID}"
echo "Executing on the machine: $(hostname)"

source $SCRATCH/projects/rtcloud-projects/mindeye/conf/.venv/bin/activate

MODEL_NAME="sub-005_all_task-C_bs24_MST_rishab_repeats_3split_sample=${SLURM_ARRAY_TASK_ID}_avgrepeats_finalmask_epochs_150"
# MODEL_NAME="sub-005_ses-01_task-C_bs24_MST_rishab_repeats_3split_samplesize=${SLURM_ARRAY_TASK_ID}_avgrepeats_finalmask_epochs_150"
DELAY=0
SEED=0

main_script=mindeye_backup_recon_ses3_special515


jupyter nbconvert "${main_script}.ipynb" --to python && \
python "${main_script}.py" \
    --model_name=${MODEL_NAME} \
    --delay=${DELAY} \
    --seed=${SEED}