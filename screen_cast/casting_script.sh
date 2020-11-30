# Let's examine performance data about Alice
cat performance.csv
# There is Alice and three other performers.

# Let's look at the measure description in spek
jq '."slowmo:IsAboutMeasure"' spek.json
# You can see this measure uses a social comparator.
#  That means average performance of the peers will be used. 

# Let's look at the performance data description in spek.json
jq '."slowmo:InputTable"."csvw:tableSchema"' spek.json
# This gives the names of columns and their uses.
#   This information will be when running the annotations.

# Peek at the math behind an assertion in annotations.r
head -n 72 annotations.r | tail -n 14
# The double bang !! is what allows us to use the names of columns from the spek.
#  It is an rlang feature to evaluate part of an expression before the entire thing.
#  In this case, it's allowing variable symbol injection.
#  That makes re-using annotations between clients MUCH easier.

# Let's add annotations of the performers to the spek
bitstomach.sh -h
bitstomach.sh -s spek.json -a annotations.r -d performance.csv > output.json

# Examine the updated spek output for performcer, Alice.
jq '."http://example.com/slowmo#IsAboutPerformer"[] | select(."@id" == "_:pAlice")' output.json

# There are two annotations made about Alice:
#   IRIs ending with psdo_0000095 and psdo_0000104.

# psdo_0000095 means social comparator content.
#  This was given by the spek.json measure description.

# psdo_0000104 means positive performance gap.
#  This was derived from the performance data.

# The output.json is an updated spek.json suitable for the next program in the pipeline.
