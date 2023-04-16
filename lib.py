import os
from termcolor import colored

""" 
py -m pip install termcolor
"""


def getDirectoryFile():
    # Get the home directory of the current user
    home_directory = os.path.expanduser('~')

    # Get the current working directory
    current_directory = os.getcwd()

    # Iterate over all files and directories in the current directory
    for component in os.scandir(current_directory):
        # Check if the component is a directory
        if component.is_dir():
            # Get the path of the directory and remove the user's home directory prefix
            subfolder_path = component.path.replace(home_directory, '', 1)

            # Print the subfolder path without the home directory prefix in yellow color
            print(colored(subfolder_path, 'yellow'))

            # List only the files in the subfolder (excluding those that start with a dot)
            for file in os.listdir(component.path):
                file_path = os.path.join(component.path, file)
                if os.path.isfile(file_path) and not file.startswith('.'):
                    # Print the file name in green color
                    print('- ' + colored(file, 'green'))


def getLineCount(directory='lib'):
    # Get the current working directory
    current_directory = os.getcwd()

    # Define the directory to scan for Dart files
    directory_path = os.path.join(current_directory, directory)

    # Initialize the line count to 0
    total_lines = 0

    # Initialize a list to hold the names of Dart files scanned
    dart_files = []

    # Iterate over all files and directories in the directory
    for file_or_dir in os.scandir(directory_path):
        # Check if the item is a directory
        if file_or_dir.is_dir():
            # Recursively call the function to count the lines of code in the subdirectory
            subdirectory_lines, subdirectory_files = getLineCount(
                os.path.join(directory, file_or_dir.name))
            total_lines += subdirectory_lines
            dart_files += subdirectory_files
            # Print the subdirectory path with color
            print(colored(os.path.join(directory, file_or_dir.name), 'yellow'))
        # Check if the item is a file and is a Dart file
        elif file_or_dir.is_file() and file_or_dir.name.endswith('.dart'):
            # Open the file and count the number of lines
            with open(file_or_dir.path, 'r') as f:
                lines = f.readlines()
                total_lines += len(lines)
            # Append the name of the Dart file to the list
            dart_files.append(file_or_dir.name)
            # Print the path of the Dart file with color
            print(colored(os.path.join(directory, file_or_dir.name), 'magenta'))

    # Print the names of the Dart files scanned with color
    print(
        colored(f'Scanned {len(dart_files)} Dart files in {directory}', 'green'))
    for dart_file in dart_files:
        print(colored('- ' + dart_file, 'magenta'))

    # Print the total number of lines of code in Dart files in the directory with color
    print(
        colored(f'Total lines of code in {directory}: {total_lines}', 'yellow'))

    # Return the total number of lines of code in Dart files in the directory and the list of Dart files scanned
    return total_lines, dart_files


if __name__ == '__main__':
    getLineCount()
