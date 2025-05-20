import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Configure these parameters
CSV_FILE = 'cpp.csv'
OUTPUT_IMAGE = 'benchmark_histograms_with_means.png'
CATEGORIES = ['Sorting', 'Hash', 'PID']  # Update based on your categories
APPROACHES = ['Procedural', 'Objective', 'Functional']  # Update based on your approaches
COLOR_PALETTE = 'husl'  # Try 'viridis', 'mako', or 'rocket' for different styles

TRIM_PERCENT = 5  # Percentage of outliers to remove from each side (0-49)


def trim_data(data, trim_percent):
    """Trim extreme values from both ends of the distribution"""
    if trim_percent <= 0:
        return data
    lower = np.percentile(data, trim_percent)
    upper = np.percentile(data, 100 - trim_percent)
    return data[(data >= lower) & (data <= upper)]


def analyze_data():
    # Read CSV data
    df = pd.read_csv(CSV_FILE, index_col='Run')
    
    # Set up plotting style
    sns.set_style('whitegrid')
    plt.figure(figsize=(15, 10))
    plt.suptitle('Performance Distribution Analysis with Mean Values', y=1.02, fontsize=14)
    
    # Create a consistent color palette
    palette = sns.color_palette(COLOR_PALETTE, n_colors=len(APPROACHES))
    
    # Create subplots for each category
    for i, category in enumerate(CATEGORIES, 1):
        ax = plt.subplot(len(CATEGORIES), 1, i)
        
        # Filter columns for this category
        category_cols = [col for col in df.columns if category in col]
        
        # Plot histograms and means for each approach
        for approach_idx, approach in enumerate(APPROACHES):
            col_name = f"{approach} {category}"
            if col_name in df.columns:
                data = df[col_name]
                data = trim_data(data, TRIM_PERCENT)
                mean_val = data.mean()
                
                # Plot histogram
                sns.histplot(
                    data, 
                    kde=True,
                    bins=15,
                    alpha=0.3,
                    label=f'{approach} (μ={mean_val:.2f}ms)',
                    element='step',
                    color=palette[approach_idx]
                )
                
                # Add mean line
                ax.axvline(mean_val, color=palette[approach_idx], 
                          linestyle='--', linewidth=1.5, alpha=0.8)
        
        ax.set_title(f"{category} Performance Distribution", pad=12)
        ax.set_xlabel('Time (ms)', fontsize=9)
        ax.set_ylabel('Frequency', fontsize=9)
        ax.legend(frameon=True, facecolor='white')
        
        # Add light grid
        ax.yaxis.grid(True, linestyle='--', alpha=0.4)
    
    # Adjust layout and save
    plt.tight_layout()
    plt.savefig(OUTPUT_IMAGE, dpi=300, bbox_inches='tight')
    print(f"Histograms saved to {OUTPUT_IMAGE}")

if __name__ == '__main__':
    analyze_data()