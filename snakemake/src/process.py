"""
Protype for a process script.

Nominally, these scripts are called by the Snakefile to run a process. They would take input(s), 
enact the processing stps, and output the result(s), as provided by the command-line interface.
"""

__author__ = "Blaise Delaney"
__email__ = "blaise.delaney at cern.ch"

from argparse import ArgumentParser
from utils import AnalysisOperation
from pathlib import Path

if __name__ == "__main__":
    # Parse the command-line arguments
    parser = ArgumentParser(description="Process the input data.")
    parser.add_argument(
        "-i",
        "--input",
        type=str,
        help="The input file to process.",
        required=True,
        nargs="+",
    )
    parser.add_argument(
        "-o", "--output", type=str, help="The output file to write.", required=True
    )
    args = parser.parse_args()

    # Create the analysis operation
    analysis_operation = AnalysisOperation(args.input, args.output)

    # Process the data
    analysis_operation.process()

    # Print the result
    print(f"Success! Operation completed successfully for {analysis_operation}")
