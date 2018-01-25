# Bit Stomach
A data ingestion tool and demonstration.

## Example Case

### Data  & Metadata 
I have a csv file with a structure plain as snow,
and everwhere this csv went, the metadata was sure to go.

performer  |  timepoint  |  score
-----------|-------------|--------
a  |  1  |  10
a  |  2  |  9
a  |  3  |  8
a  |  4  |  6
a  |  5  |  6
b  |  1  |  2
b  |  2  |  2
b  |  3  |  4
b  |  4  |  5
b  |  5  |  6
c  |  1  |  8
c  |  2  |  9
c  |  3  |  8
c  |  4  |  9
c  |  5  |  9
d  |  1  |  10
d  |  2  |  10
d  |  3  |  10
d  |  4  |  9
d  |  5  |  9
e  |  1  |  8
e  |  2  |  8
e  |  3  |  9
e  |  4  |  9
e  |  5  |  8


```json
  "tableSchema": {
    "columns": [
      {
        "datatype": "string", 
        "dc:description": "Performer unique ID", 
        "name": "performer", 
        "titles": "Performer"
      }, 
      {
        "datatype": "integer", 
        "dc:description": "Time at which performance was measured.", 
        "name": "timepoint", 
        "titles": "Time"
      }, 
      {
        "datatype": "integer", 
        "dc:description": "Demonstration performance metric", 
        "name": "Score", 
        "titles": "Value"
      }, 
```

### Analysis Specification
Situation specific interpretation of the performance values.  Specified by collaborator or domain expert.  Distilled down to statements that can be implemented by an algorithm.

Annotate each performer with applicable attributes:
- hasMastery
    ```
      Score above 10 for at least 3 consecutive time points
        or
      Score above 15 at any point
    ```

- notHasMastery
    ```
      Score never above 10 for 3 consecutive time points
        and
      Score never above 15
    ```

- hasDownwardTrend
    ```
      Latest 3 score average is below average of previous score
        and
      Slope of linear fit of latest 3 score points is negative
    ```

### Running the example

1. Start the front end.
2. Select example/input/data.csv as data file
3. Select example/input/metadata.csv as metadata file
4. Press Run.

