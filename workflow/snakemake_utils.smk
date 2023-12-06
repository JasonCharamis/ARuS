
###=============================================================== Snakemake Utils Functions =====================================================================###

def is_docker() -> bool:
    with open('/proc/self/cgroup', 'r') as procfile:
        result = subprocess.run(["grep", "container"], stdin=procfile, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        if result.returncode == 0:
            return True
        else:
            return False

    return False


def find_repository_name(start_dir="."):
    current_dir = os.path.abspath(start_dir)

    while current_dir != '/':  # Stop searching at the root directory
        result = subprocess.run(["find", current_dir, "-type", "f", "-name", "Snakefile"], capture_output=True, text=True)

        if result.stdout:
            snakefiles = result.stdout.strip().split('\n')
            if len(snakefiles) == 1:
                return ( re.sub("workflow.*","", snakefiles[0]) )
            else:
                print("Multiple repositories identified:")
                for snakefile in snakefiles:
                    print(f"- {snakefile}")

        current_dir = os.path.dirname(current_dir)

    # Of course, if a different path is provided with the --snakefile argument, this will be used by Snakemake
    return None  # Return None if no Snakefile or snakefile is found


def find_workflow_path(dir="."):
    home_directory = os.path.expanduser("~")
    repository_name = find_repository_name(dir)
    result = subprocess.run(["find", home_directory, "-type", "d", "-name", repository_name], capture_output=True, text=True)
    return result.stdout

