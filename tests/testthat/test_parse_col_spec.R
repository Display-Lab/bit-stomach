context('Parse Column Specification from Spek')

spek_sans_input_table <- list(`@id` = "http://example.com/app#example-client", `@type` = "http://example.com/slowmo#slowmo_0000140")

spek_with_input_table <-
  list(`@id` = "http://example.com/app#example-client", `@type` = "http://example.com/slowmo#slowmo_0000140",
    `http://example.com/slowmo#input_table` = list(
    list(
      `@type` = "http://www.w3.org/ns/csvw#Table",
      `http://www.w3.org/ns/csvw#dialect` = list(
        list(
          `http://www.w3.org/ns/csvw#commentPrefix` = list(list(`@value` = "")),
          `http://www.w3.org/ns/csvw#delimiter` = list(list(`@value` = ",")),
          `http://www.w3.org/ns/csvw#doubleQuote` = list(list(`@value` = TRUE)),
          `http://www.w3.org/ns/csvw#encoding` = list(list(`@value` = "utf-8")),
          `http://www.w3.org/ns/csvw#header` = list(list(`@value` = TRUE)),
          `http://www.w3.org/ns/csvw#headerRowCount` = list(list(`@value` = "1")),
          `http://www.w3.org/ns/csvw#lineTerminators` = list(list(`@value` = "\\n")),
          `http://www.w3.org/ns/csvw#quoteChar` = list(list(`@value` = "\"")),
          `http://www.w3.org/ns/csvw#skipBlankRows` = list(list(`@value` = TRUE)),
          `http://www.w3.org/ns/csvw#skipColumns` = list(list(`@value` = 0L)),
          `http://www.w3.org/ns/csvw#skipInitialSpace` = list(list(`@value` = FALSE)),
          `http://www.w3.org/ns/csvw#skipRows` = list(list(`@value` = "")),
          `http://www.w3.org/ns/csvw#trim` = list(list(`@value` = FALSE))
        )
      ),
      `http://www.w3.org/ns/csvw#tableSchema` = list(list(
        `http://www.w3.org/ns/csvw#columns` = list(
          list(
            `http://www.w3.org/ns/csvw#datatype` = list(list(`@value` = "string")),
            `http://www.w3.org/ns/csvw#name` = list(list(`@value` = "performer")),
            `http://www.w3.org/ns/csvw#titles` = list(list(`@value` = "Name")),
            `http://purl.org/dc/terms/description` = list(list(`@value` = "Performer unique ID")),
            `http://example.com/slowmo#ColumnUse` = list(list(`@value` = "identifier"))
          ),
          list(
            `http://www.w3.org/ns/csvw#datatype` = list(list(`@value` = "integer")),
            `http://www.w3.org/ns/csvw#name` = list(list(`@value` = "timepoint")),
            `http://www.w3.org/ns/csvw#titles` = list(list(`@value` = "Time")),
            `http://purl.org/dc/terms/description` = list(list(`@value` = "Time at which performance was measured.")),
            `http://example.com/slowmo#ColumnUse` = list(list(`@value` = "time"))
          ),
          list(
            `http://www.w3.org/ns/csvw#datatype` = list(list(`@value` = "integer")),
            `http://www.w3.org/ns/csvw#name` = list(list(`@value` = "performance")),
            `http://www.w3.org/ns/csvw#titles` = list(list(`@value` = "Performance")),
            `http://purl.org/dc/terms/description` = list(list(`@value` = "Demonstration performance value")),
            `http://example.com/slowmo#ColumnUse` = list(list(`@value` = "value"))
          )
        )
      )),
      `http://purl.org/dc/terms/title` = list(list(`@value` = "Mock Performance Data"))
    )
  ))


test_that('Parsing empty col_spec has expected members',{
  result_names <- names(parse_col_spec(list()))
  expected_members <- c("id_cols", "val_cols")
  expect_identical(result_names, expected_members)
})

test_that('Parsing NULL has expected members',{
  result_names <- names(parse_col_spec(NULL))
  expected_members <- c("id_cols", "val_cols")
  expect_identical(result_names, expected_members)
})

test_that('Parsing empty col_spec results in empty values', {
  result <- parse_col_spec(list())
  empty_vals <- sapply(result, function(x) is.list(x) && length(x) < 1)
  expect_true(all(empty_vals))
})

test_that('Parsing spek without input table results in empty values.',{
  result <- parse_col_spec(spek_sans_input_table)
  empty_vals <- sapply(result, function(x) is.list(x) && length(x) < 1)
  expect_true(all(empty_vals))
})

test_that('Column specification is extracted from spek.',{
  result <- parse_col_spec(spek_with_input_table)
  expect_identical(result$id_cols, c("performer"))
  expect_identical(result$val_cols, c("performance"))
})
