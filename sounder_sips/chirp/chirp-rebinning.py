'''
Stub Python script to simulate the CHIRP rebinning algorithm.
'''
import argparse

# define the input arguments
parser = argparse.ArgumentParser()
parser.add_argument("-g", "--granules", help="Path to file containing listing of input files", required=True)

# parse input arguments
args = parser.parse_args()
print("IN: %s" % args.granules)

# read input file
file_in = open(args.granules, 'r')
lines = file_in.readlines()
file_in.close()
  
# write output file
# Strips the newline character
file_out_name = "products.txt"
file_out = open(file_out_name, 'w')
for line in lines:
    file_out.write("%s_out\n" % line.strip())
file_out.close()

# return output
print("OUT: %s" % file_out_name)
