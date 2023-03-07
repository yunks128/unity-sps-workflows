'''
Stub Python script to simulate a CMR query.
'''
import argparse
import datetime

# define the input arguments
parser = argparse.ArgumentParser()
parser.add_argument("-c", "--collection", help="Name of collection containing input granules", required=True)
parser.add_argument("--start_datetime", help="Start date and time for input granules", required=True, type=datetime.date.fromisoformat)
parser.add_argument("--stop_datetime", help="Stop date and time for input granules", required=True, type=datetime.date.fromisoformat)
parser.add_argument("--edl_username", help="Earth Data Login username")
parser.add_argument("--edl_password", help="Earth Data Login password")

# parse input arguments
args = parser.parse_args()
print("CMR COLLECTION: %s" % args.collection)
print("START DATE TIME: %s" % args.start_datetime)
print("STOP DATE TIME: %s" % args.stop_datetime)

# write output file with CMR search results
file_out_name = "cmr_results.txt"
file_out = open(file_out_name, 'w')
for i in range(0, 5):
    file_out.write("/tmp/granule_%s.nc\n" % i)
file_out.close()

# return output
print("OUT: %s" % file_out_name)
