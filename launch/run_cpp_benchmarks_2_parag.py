import csv
import shlex
from perf_task_clock import get_task_clock_time, PerfStatError

# Configure your programs here (name and command)
PROGRAMS = [
    {
        'name': 'Procedural Sorting',
        'command': 'build/procedural_sorting'
    },
    {
        'name': 'Functional Sorting',
        'command': 'build/functional_sorting'
    },
    {
        'name': 'Procedural Hash',
        'command': 'build/procedural_hash'
    },
    {
        'name': 'Functional Hash',
        'command': 'build/functional_hash'
    },
    {
        'name': 'Procedural PID',
        'command': 'build/procedural_pid'
    },
    {
        'name': 'Functional PID',
        'command': 'build/functional_pid'
    },
]

def run_benchmark(output_file='results.csv', runs=1000):
    # Validate configuration
    if not PROGRAMS:
        raise ValueError("No programs configured in PROGRAMS list")
    
    # Prepare data collection
    results = {}
    
    # Benchmark each program in sequence
    for prog in PROGRAMS:
        program_name = prog['name']
        print(f"Benchmarking {program_name} ({runs} consecutive runs)...")
        command = shlex.split(prog['command'])
        program_times = []
        
        for _ in range(runs):
            try:
                time = get_task_clock_time(command)
                program_times.append(time)
            except PerfStatError as e:
                raise RuntimeError(f"Failed benchmarking {program_name}: {str(e)}") from e
        
        results[program_name] = program_times
    
    # Write results to CSV
    with open(output_file, 'w', newline='') as f:
        writer = csv.writer(f)
        
        # Write header
        headers = ['Run'] + [prog['name'] for prog in PROGRAMS]
        writer.writerow(headers)
        
        # Write data rows
        for run_idx in range(runs):
            row = [run_idx + 1]
            for prog in PROGRAMS:
                program_name = prog['name']
                row.append(results[program_name][run_idx])
            writer.writerow(row)
    
    print(f"Successfully wrote {runs} runs for {len(PROGRAMS)} programs to {output_file}")

if __name__ == '__main__':
    try:
        run_benchmark(
            output_file='cpp.csv',
            runs=50
        )
    except Exception as e:
        print(f"Error: {str(e)}")
        exit(1)