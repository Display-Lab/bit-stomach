# Bit Stomach
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1300745.svg)](https://doi.org/10.5281/zenodo.1300745)

Processes performance data to assert causal pathway attributes about performers. 

## Annotations
Functions to process input data and determine if attribute is present or not.  
Each function is called with the performance data and a column spec as args.
It is expected to return a table of the id and boolean value of the attribute.
Returned table must be grouped by id. e.g the result of annotate\_capability\_barier:

id | cabability\_barrier |
---|--------------------|
 Alice | TRUE |
 Bob | FALSE |
 Carol | FALSE |

## Example Case

### Input Spek
JSON-LD description of project including any apriori assertions about performers.

### Input Data
CSV format of performer, timepoint, value

### Annotation Specification
Situation specific interpretation of the performance values.  
Specified by collaborator or domain expert.  
Distilled down to statements that can be implemented by an algorithm,
and subsequently written as functions in an annotations.r file.

Annotate each performer with applicable attributes:
- capability\_barrier

    ```
      Score above 10 for at least 3 consecutive time points
        or
      Score above 15 at any point
    ```

- performance\_gap\_pos
    ```
      Value above %110 of background average at last time point.
    ```
- performance\_gap\_neg
    ```
      Performance below %90 of background average at last time point.
    ```
