#!/usr/bin/env python

import argparse
import os
import os.path
import sys
import subprocess

if sys.version_info[0] < 3:
    raise Exception("Python 3 or a more recent version is required.")

colorizer_executable_path       = "Colorizer.exe"
colorizer_check_file_path       = "check.txt"
colorizer_replacement_file_path = "replacements.txt"

class ColorizerRunner(object):
    def __init__(self, force):
        self.file_pairs_new = 0
        self.file_pairs_up_to_date = 0
        self.file_pairs_updated = 0
        self.errors = 0
        self.force = force

    def execute_colorizer(self, code_file_path, color_file_path, html_file_path):
        command = "\"{}\" -c \"{}\" -r \"{}\" -W -l \"{}\" \"{}\" \"{}\"".format(colorizer_executable_path, colorizer_check_file_path, colorizer_replacement_file_path, code_file_path, color_file_path, html_file_path)
        result = subprocess.run(command, capture_output=True, text=True)
        if result.returncode == 0:
            return True
        else:
            print("COMMAND:")
            print(command)
            print()
            print("INFO:")
            print("{}\n{}".format(code_file_path, color_file_path))
            print()
            print("OUTPUT:")
            print(result.stdout)
            print(result.stderr)
            print()
            return False

    def needs_to_run(self, code_file_path, color_file_path, output_file_path):
        if self.force:
            return True
        else:
            code_file_mod_time = os.path.getmtime(code_file_path)
            color_file_mod_time = os.path.getmtime(color_file_path)
            output_file_mod_time = os.path.getmtime(output_file_path)
            return code_file_mod_time > output_file_mod_time or color_file_mod_time > output_file_mod_time

    def check_color_file(self, dir, filename):
        code_file_path   = filename + ".cpp"
        color_file_path  = filename + ".color"
        output_file_path = filename + ".html"
        if os.path.exists(code_file_path):
            if os.path.exists(output_file_path):
                if self.needs_to_run(code_file_path, color_file_path, output_file_path):
                    if self.execute_colorizer(code_file_path, color_file_path, output_file_path):
                        self.file_pairs_updated += 1
                    else:
                        self.errors += 1
                else:
                    self.file_pairs_up_to_date += 1
            else:
                if self.execute_colorizer(code_file_path, color_file_path, output_file_path):
                    self.file_pairs_new += 1
                else:
                    self.errors += 1
        else:
            print("file {} has no associated .cpp file".format(color_file_path))
            self.errors += 1

    def process_dir(self, dir):
        with os.scandir(dir) as it:
            for entry in it:
                if entry.is_file():
                    name, ext = os.path.splitext(entry.path)
                    if (ext == ".color"):
                        self.check_color_file(dir, name)
                if entry.is_dir():
                    self.process_dir(entry.path)
    
    def print_stats(self):
        print("SUMMARY:")
        print("up to date file pairs: {}".format(self.file_pairs_up_to_date))
        print("   updated file pairs: {}".format(self.file_pairs_updated))
        print("       new file pairs: {}".format(self.file_pairs_new))
        print("               errors: {}".format(self.errors))

    def run(self, path):
        self.process_dir(path)
        self.print_stats()

parser = argparse.ArgumentParser()
parser.add_argument(
    "-f", "--force", help="ignore file timestamps and run for all files", action="store_true")
args = parser.parse_args()
force = False

if args.force:
    force = True

runner = ColorizerRunner(force)
runner.run(".")
