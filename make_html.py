#!/usr/bin/env python3

import statistics

def saveInt(s):
    try:
        return int(s)
    except ValueError:
        return None

def stats(ratings):
    valid_ratings = [int(r) for r in ratings if saveInt(r) is not None and 0 <= int(r) <= 5]
    l = len(valid_ratings)
    try:
        m = statistics.mean(valid_ratings)
    except statistics.StatisticsError:
        m = "-"
    try:
        med = statistics.median(valid_ratings)
    except statistics.StatisticsError:
        med = "-"
    try:
        std = statistics.pstdev(valid_ratings)
    except statistics.StatisticsError:
        std = "-"
    return l, m, med, std

print("<html><pre>")

with open("ratings.txt") as f:
    print("Coffee               MEAN  MEDIAN    STD")
    print("------               ----  ------    ---")
    print()
    vals = []
    for line in f.readlines():
        if not line.strip() or line.startswith("#") or line.startswith(" "):
            continue
        name, *ratings = line.split()
        l, m, med, std = stats(ratings)
        vals.append((name, l, m, med, std))
    for line in sorted(vals, key=lambda x: -x[2]):
        name, l, m, med, std = line
        print("{name:20s} {m:4.2f}  {med:6.0f} {std:6.2f} ({l} ratings)".format(name=name, m=m, med=med, std=std, l=l))

print("</pre></html>")

