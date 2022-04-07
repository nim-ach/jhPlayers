if (!requireNamespace("rmarkdown")) install.packages("rmarkdown", dependencies = TRUE)

render_papers = function(papers = TRUE) {

  files = NULL

  if (papers) {
    files = list.files(
      path = "paper/rmd/",
      full.names = TRUE,
      pattern = ".Rmd$"
    )
  }

  files = c(files, "paper/peer review/author-response.md")

  .render = function(input) {
    rmarkdown::render(
      input = input,
      output_dir = "paper/docx/",
      output_format = rmarkdown::word_document(
        reference_docx = here::here("paper/rmd/template.docx")
      )
    )
  }

  invisible(
    x = lapply(files, .render)
  )
}
