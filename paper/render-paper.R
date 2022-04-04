if (!requireNamespace("rmarkdown")) install.packages("rmarkdown", dependencies = TRUE)

render_papers = function() {

  files = list.files(
    path = "paper/rmd/",
    full.names = TRUE,
    pattern = ".Rmd$"
  )

  .render = function(input) {
    rmarkdown::render(
      input = input,
      output_dir = "paper/docx/",
      output_format = rmarkdown::word_document(
        reference_docx = "template.docx"
      )
    )
  }

  invisible(
    x = lapply(files, .render)
  )
}
