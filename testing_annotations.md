# Using Annotation Testing Harness

A set of functions that facilitate setting up the environment in which annotations are run.
Can be used to debug or develop annotations.

## Setup
Read the components of a vignette or project into your global environment
```R
devtools::load_all()
library(fs)

# Path to vignettes directory
vdir <- path('~','workspace','vra','vignettes')

# Paths to relevant files in vignette
anno_path <- path(vdir, 'bob','annotations.r')
spek_path <- path(vdir, 'bob','spek.json')
data_path <- path(vdir, 'bob','performance.csv')

# Read annotation functions
anno_env <- source_annotations(anno_path)

# Read spek
spek <- spekex::read_spek(spek_path)

# Read data
col_types <- spekex::cols_for_readr(spek)
raw_data <- read_data(data_path, col_types)
```

## Run annotations for single measure (first measure)

Two thigs I found useful to examine was the processed measure data and the resulting dispositions
from a measure
```R
measure_data <- h_setup_measure_data(spek, raw_data)
dispositions <- h_single_measure_run(spek, anno_env, measure_data)
```

The table of dispositions can then be examined for the expected annotations.
```R
library(dplyr)

dispositions

# # A tibble: 4 x 2
#   `@id` `http://purl.obolibrary.org/obo/RO_0000091`
#   <chr> <list>                                     
# 1 Bob   <list [3]>                                 
# 2 Peer1 <list [1]>                                 
# 3 Peer2 <list [2]>                                 
# 4 Peer3 <list [3]>

bobs_dispos <- dispositions %>% filter(`@id` == 'Bob') %>% pull(2)
str(bobs_dispos)

# List of 1
#  $ :List of 3
#   ..$ :List of 1
#   .. ..$ @type: chr "http://purl.obolibrary.org/obo/psdo_0000095"
#   ..$ :List of 1
#   .. ..$ @type: chr "http://purl.obolibrary.org/obo/psdo_0000104"
#   ..$ :List of 1
#   .. ..$ @type: chr "http://purl.obolibrary.org/obo/psdo_0000099"
```

## Setup environment as would exist inside a call in annotations.

Get the annotation function args
```R
anno_call_args <- h_setup_annotation_call_args(spek, anno_env, measure_data)
```

With those in hand, both the args and the enclosing frame (`anno_env`)
can be attached to the current search() path
That lets us step through the  annotation function in our global workspace.

```R
attach(anno_env)
attach(anno_call_args)
# ... run your annotation function line by line ...
detach(anno_env)
detach(anno_call_args)
```
