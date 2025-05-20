# perf_task_clock.py
import subprocess
from typing import List, Union

class PerfStatError(Exception):
    """Base exception for perf stat related errors"""

def get_task_clock_time(command: Union[str, List[str]]) -> float:
    """
    Run a command with perf stat and return task-clock time in milliseconds
    
    Args:
        command: The command to execute, either as string or list of arguments
    
    Returns:
        Floating point value of task-clock time in milliseconds
        
    Raises:
        PerfStatError: If any error occurs during execution or parsing
        FileNotFoundError: If perf is not installed
    """
    if isinstance(command, str):
        command = command.split()
        
    perf_cmd = ['perf', 'stat'] + command
    
    try:
        result = subprocess.run(
            perf_cmd,
            stderr=subprocess.PIPE,
            text=True,
            check=True
        )
    except subprocess.CalledProcessError as e:
        raise PerfStatError(f"Command failed: {e}") from e
        
    return _parse_perf_output(result.stderr)

def _parse_perf_output(perf_output: str) -> float:
    for line in perf_output.split('\n'):
        line = line.strip()
        if "msec task-clock" in line:
            parts = line.split()
            try:
                # Find the msec task-clock element (might have : modifier)
                for i, part in enumerate(parts):
                    if part == "msec" and i+1 < len(parts) and parts[i+1].startswith("task-clock"):
                        # Handle both comma and dot decimal separators
                        value_str = parts[i-1].replace(',', '.')
                        return float(value_str)
            except (IndexError, ValueError) as e:
                raise PerfStatError(f"Failed to parse perf output: {line}") from e
    raise PerfStatError("Task-clock parameter not found in perf output")

if __name__ == "__main__":
    import sys
    try:
        if len(sys.argv) < 2:
            print(f"Usage: {sys.argv[0]} <command> [args...]")
            sys.exit(1)
            
        time_ms = get_task_clock_time(sys.argv[1:])
        print(f"{time_ms:.2f} ms")
        
    except Exception as e:
        print(f"Error: {str(e)}")
        sys.exit(1)