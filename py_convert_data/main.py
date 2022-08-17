from perf_convert import *
from sim_convert import * 


def main():
  directory = input("input folder name: ")
  full_directory = "/home/og21893/proj_data/" + directory + "/"

  # read perf result and generate CSV file
  input_file = open( full_directory + "perf_results.txt", "r")
  csv_name = full_directory + "perf_" + directory + ".CSV"
  input_file.readline()

  output_file = open(csv_name, "w")
  read_perf_file(input_file, output_file)

  input_file.close()
  output_file.close()

  # read sim result and generate CSV file
  input_file = open(full_directory + "sim_results.txt", "r")
  csv_name = full_directory + "sim_" + directory + ".CSV"
  input_file.readline()   # date

  output_file = open(csv_name, "w")
  create_sim_headline(output_file)
  read_sim_file(input_file, output_file)

  input_file.close()
  output_file.close()

main()
  