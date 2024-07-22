"""Generate dummy data and MC files for the tutorial."""

__author__ = "Blaise Delaney"
__email__ = "blaise.delaney at cern.ch"

import os
from pathlib import Path

# Define the base directory and variations
base_dir = Path("scratch")
data_variations = ["data", "mc"]
year_variations = ["2012", "2018"]

# Iterate over the combinations and create the files
for data in data_variations:
    for year in year_variations:
        # Construct the directory path
        dir_path = base_dir / data / year

        # Create the directory if it doesn't exist
        dir_path.mkdir(parents=True, exist_ok=True)

        # Create the files in the directory
        for i in range(
            10
        ):  # consider the simple case of 3 files per year, per data type
            file_path = dir_path / f"beauty2darkmatter_{i}.root"
            file_path.touch()

print("Files created successfully.")
