#' @title Format p-values
#'
#' @param p Numeric vector of p-value(s).
#' @param k Number of decimal places. Defaults to 3.
#'
#' @export

style.p <- function(p, k = 3) {
  data.table::fcase(
    p < 0.001, "< 0.001",
    p >= 0.001, paste0("= ", round(p, digits = k))
  )
}

#' @title Get label from correlation tests
#'
#' @description
#'
#'   Get the manuscript-ready label out from correlation
#'   tests.
#'
#' @param h An `htest` object (typical class from correlation
#' test in native R system using `cor.test()`).
#'
#' @export

cor_label <- function(h) {

  info = switch(
    names(h$estimate),
    rho = c(mth = "$\\rho_{Spearman}$", dtb = "S"),
    cor = c(mth = "$r_{Pearson}$", dtb = paste0("$t_{Student}$ (", h$parameter, ")")),
    tau = c(mth = "$\\tau_{Kendall}$", dtb = "z")
  )

  elements = list()

  elements$stat = paste0(
    info[['dtb']], " = ", round(h$statistic, 1)
  )

  elements$pval = paste(
    "p", style.p(h$p.value)
  )

  elements$effect = paste0(
    info[["mth"]], " = ", round(h$estimate, 2)
  )

  if ("conf.int" %in% names(h)) {
    h$conf.int = round(h$conf.int, 2)

    ci = paste0(
      attr(h$conf.int, "conf.level") * 100, "%"
    )

    elements$confint = paste0(
      "CI~", ci, "~[", h$conf.int[1], ", ", h$conf.int[2], "]"
    )
  }

  output = paste0(elements, collapse = ", ")

  return(output)
}

#' @title Mean and SD
#' @rdname mean_sd
#'
#' @description
#'
#'   Compute mean and standard deviation in the format
#'   "Mean ± SD".
#'
#' @param .data Data from which obtain columns.
#' @param vars Variables from which compute mean and sd.
#' @param x Numeric variable.
#' @param k Numeric indicating the number of decimal places.
#'
#' @export

mean_sd <- function(x, k = 1) {
  x = x[!is.na(x)]
  mu = round(mean(x), k)
  sigma = round(stats::sd(x), k)
  mark = rawToChar(x = as.raw(c(0xc2, 0xb1)))
  out = paste(mu, mark, sigma)
  return(out)
}

#' @rdname mean_sd
#' @export

colmean_sd <- function(.data, vars, k = 1) {
  stopifnot(
    inherits(.data, "data.frame")
  )

  if (!inherits(.data, "data.table")) {
    data.table::setDT(.data)
  }

  if (missing(vars)) {
    stop("Must indicate at least 1 numeric variable to use.")
  }

  out = .data[, lapply(.SD, mean_sd, k = k), .SDcols = vars]
  out = data.table::transpose(out, keep.names = "vars")
  colnames(out) = c("vars", "mean_sd")

  return(out)
}
