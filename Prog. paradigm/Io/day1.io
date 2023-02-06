# 1. Run an Io program from a file.
#
# run: io day1.io

# 2.
runner := Object clone
runner run := method ("Running like a fool!" println)
runner getSlot("run") call
