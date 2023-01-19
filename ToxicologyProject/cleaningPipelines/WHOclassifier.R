## REQUIRES: input is a toxicity value who's value is numerical
## EFFECTS: returns the WHO class based on a toxicity value. Else, return NA
## NA if the element == NA
ld50_to_who_class <- function(tox) {
    if (tox > 5000) {
        a <- "U"
    } else if (tox > 2000) {
       a <- "III"
    } else if (tox >= 50) {
       a <- "II"
    } else if (tox >= 5) {
       a <- "Ib"
    } else if (tox < 5) {
        a <- "Ia"
    } else {
        a <- NA
    }
    a
}