import argparse
import pandas as pd
import os

def collate_results(
    args: argparse.Namespace,
):
    all_results = []
    for seed in range(args.seed_range):
        file_path = os.path.join(args.input_dir, f"{seed}", "metrics.csv")
        if not os.path.exists(file_path):
            print(f"Warning: File {file_path} does not exist. Skipping.")
            continue
        df = pd.read_csv(file_path)
        df['seed'] = seed  # Add a column to identify the seed
        all_results.append(df)
    
    if all_results:
        collated_df = pd.concat(all_results, ignore_index=True)
        # average and std across all seeds
        # cols are rep, category ... metrics
        # we want to group by rep, category
        grouped = collated_df.groupby(['rep', 'category']).agg(['mean', 'std']).reset_index()
        grouped.to_csv(args.output_file, index=False)
        print(f"Collated results saved to {args.output_file}")
        print("==== Collated Results ====")
        print(grouped)
        
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Collate seed results from multiple runs.")
    parser.add_argument(
        "--input_dir",
        type=str,
        required=True,
        help="Directory containing seed result files.",
    )
    parser.add_argument(
        "--output_file",
        type=str,
        required=True,
        help="File to write the collated results.",
    )
    parser.add_argument(
        "--seed_range",
        type=int,
        default=5,
        help="seed range: 0 - n, specify n (default: 5)"
    )
    args = parser.parse_args()
    
    collate_results(args)