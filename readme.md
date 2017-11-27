# Bit Stomach
A data ingestion tool and demonstration.

## Example Case

### Data  & Metadata 
I have a csv file with a structure plain as snow,
and everwhere this csv went, the metadata was sure to go.
id|time|perf
--|----|----
1 | 0  | 15
1 | 1  | 14
1 | 2  | 14
2 | 0  | 7
2 | 1  | 8
2 | 2  | 8

```json
  "tableSchema": {
    "columns": [
      {
        "datatype": "integer", 
        "dc:description": "Performer unique ID", 
        "name": "id", 
        "titles": "Identifier"
      }, 
      {
        "datatype": "integer", 
        "dc:description": "Time at which performance was measured.", 
        "name": "time", 
        "titles": "Time"
      }, 
      {
        "datatype": "integer", 
        "dc:description": "Demonstration performance metric", 
        "name": "perf", 
        "titles": "Performance"
      }, 
```
### Analysis Specification

Annotate each performer with applicable attributes:
- hasMastery
		```
		Performance above 10 for at least 3 consecutive time points
		  or
		Performance above 15 at any point
    ```
- notHasMastery
		```
		Performance never above 10 for 3 consecutive time points
      and
    Performance never above 15
    ```
- hasDownwardTrend
		```
		Latest 3 performance average is below average of previous performance
			and
		Slope of linear fit of latest 3 performance points is negative
		```

### Running the example

1. Start the front end.
2. Select example/input/data.csv as data file
3. Select example/input/metadata.csv as metadata file
4. Press Run.

