
# jarvis

![](https://img.shields.io/badge/lifecycle-experimental-brightgreen.svg)

## Installation

``` r
pak::pak("ericmshearer/jarvis")
```

## Tables

`tbl_totals()`

- Default calculates column totals. For row, set `where` to “row”.
- Name of summed cell defaults to “Total”. To change, update `name`.

``` r
linelist |>
  count(Race) |>
  tbl_totals()
#> # A tibble: 9 × 2
#>   Race                                          n
#>   <chr>                                     <dbl>
#> 1 American Indian or Alaska Native             15
#> 2 Asian                                        11
#> 3 Black or African American                    16
#> 4 Multiple Races                                6
#> 5 Native Hawaiian or Other Pacific Islander    15
#> 6 Other                                        16
#> 7 Unknown                                       9
#> 8 White                                        17
#> 9 Total                                       105
```

`tbl_percentage()`

- Control rounding via `digits`.
- Default calculates column percentages. For row, set `where` to “row”.

``` r
linelist |>
  count(Race) |>
  tbl_percentage()
#> # A tibble: 8 × 2
#>   Race                                          n
#>   <chr>                                     <dbl>
#> 1 American Indian or Alaska Native           14.3
#> 2 Asian                                      10.5
#> 3 Black or African American                  15.2
#> 4 Multiple Races                              5.7
#> 5 Native Hawaiian or Other Pacific Islander  14.3
#> 6 Other                                      15.2
#> 7 Unknown                                     8.6
#> 8 White                                      16.2
```

## Data Visualization

`scale_percent()`

For unscaled percentages (i.e. not multiplied by 100), update `scale` to
FALSE.

``` r
linelist |>
  count(Race) |>
  mutate(percent = add_percent(n)) |>
  ggplot(aes(x = Race, y = percent)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(label = wrap_labels(delim = "or")) +
  scale_y_continuous(expand = c(0,0), label = scale_percent()) +
  theme_apollo()
```

<img src="man/figures/README-scale_percent-1.png" width="100%" />
