convert_to_inches <- function(x, units, res) {
  if (units == "in") {
    x
  } else if (units == "cm") {
    x / 2.54
  } else if (units == "mm") {
    x / 25.4
  } else if (units == "px") {
    x / res
  } else {
    NA_real_
  }
}
