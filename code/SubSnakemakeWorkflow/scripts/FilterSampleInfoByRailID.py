#!/usr/bin/env python3
import sys
SnaptronMetadataFile, RailIDFile = sys.argv[1:]

with open(RailIDFile, 'rU') as r_fh:
    rail_ids = set(r_fh.read().splitlines())

with open(SnaptronMetadataFile, 'rU') as s_fh:
    for i, line in enumerate(s_fh):
        l=line.strip('\n').split('\t')
        if i==0: #print header
            sys.stdout.write(line)
        elif i>=1 and l[0] in rail_ids:
            sys.stdout.write(line)
