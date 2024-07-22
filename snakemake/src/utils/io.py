"""
Utility class to take in an input and touch the output. 
This is a placeholder for more complex analysis operations.
"""

__author__ = "Blaise Delaney"
__email__ = "blaise.delaney at cern.ch"

import os
import unittest
from typing import Any
from pathlib import Path


class AnalysisOperation:
    """Utility class to mimic an analysis operation. Take in an input and touch the output.

    Example usage:
    ----------------
        analysis_operation = AnalysisOperation("Sample Input", "Initial Output")
        print(analysis_operation)  # Before processing
        analysis_operation.process()
        print(analysis_operation)  # After processing
    """

    def __init__(self, input_data: Any, output_data: str) -> None:
        self._input = input_data
        self._output = output_data

    @property
    def input(self) -> Any:
        return self._input

    @input.setter
    def input(self, value: Any) -> None:
        self._input = value

    @property
    def output(self) -> str:
        return self._output

    @output.setter
    def output(self, value: str) -> None:
        self._output = value

    def process(self) -> None:
        """Process the input and write the output."""
        # book the path
        Path(self._output).parent.mkdir(parents=True, exist_ok=True)
        # emulate processing and writing
        AnalysisOperation.touch(self._output)

    @staticmethod
    def touch(filename: str) -> None:
        with open(filename, "w"):
            pass

    def __str__(self) -> str:
        return f"AnalysisOperation(input={self._input}, output={self._output})"

    def __repr__(self) -> str:
        return f"AnalysisOperation(input={self._input!r}, output={self._output!r})"


# Unit Tests
class TestAnalysisOperation(unittest.TestCase):
    def test_file_creation(self):
        """Test that the process method creates a file."""
        test_filename = "test_file.txt"
        operation = AnalysisOperation("Test Input", test_filename)
        operation.process()

        # Check if the file was created
        self.assertTrue(os.path.exists(test_filename))

        # Clean up: remove the created file
        os.remove(test_filename)


if __name__ == "__main__":
    unittest.main()
