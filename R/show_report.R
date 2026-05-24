show_report <- function(res_df, summary_type = "file") {
  if (is.null(res_df)) {
    return(invisible(NULL))
  }

  # Print the optimization report heading.
  name_cli <- switch(summary_type,
    "file" = "file{?s}",
    "url" = "URL{?s}"
  )

  # nolint start
  totinit <- sum(res_df$src_bytes, na.rm = TRUE)
  totinit_pretty <- make_pretty_size(totinit)

  # nolint end

  heading <- cli::cli_div(theme = list(rule = list("line-type" = "double")))
  cli::cli_rule(left = "{.pkg resmush} summary")
  cli::cli_end(heading)
  cli::cli_alert_info(paste0(
    "Input: {nrow(res_df)} ",
    name_cli,
    ", total size {totinit_pretty}."
  ))

  nok <- res_df[res_df$notes != "OK", ]
  ok <- res_df[res_df$notes == "OK", ]

  # Report successful optimizations.
  if (nrow(ok) > 0) {
    # nolint start
    okinit <- sum(ok$src_bytes, na.rm = TRUE)
    okend <- sum(ok$dest_bytes, na.rm = TRUE)
    okinit_pretty <- make_pretty_size(okinit)
    okend_pretty <- make_pretty_size(okend)
    okdif <- make_pretty_size(okinit - okend)
    okperc <- 1 - okend / okinit
    okperc_pretty <- sprintf("%0.2f%%", okperc * 100)
    okdirs <- unique(dirname(ok$dest_img))
    # nolint end

    cli::cli_alert_success(paste0(
      "Optimized {nrow(ok)} ",
      name_cli,
      ": Size is now {okend_pretty} ",
      "(was {okinit_pretty}). Saved {okdif} ({okperc_pretty})."
    ))
    cli::cli_bullets(paste0(
      "Saved {cli::qty(nrow(ok))} result{?s} in ",
      "{cli::qty(okdirs)}director{?y/ies} ",
      "{.path {okdirs}}."
    ))
  }

  # Report failed optimizations.
  if (nrow(nok) > 0) {
    # nolint start
    nokdirs <- unique(dirname(nok$src_img))
    noks <- seq_len(nrow(nok))
    # nolint end

    if (summary_type == "file") {
      # Prepare failed-file bullets.
      makebull <- sprintf(
        paste0(
          "{.path {nok$src_img[%s]}} ",
          "({nok$src_size[%s]}): {nok$notes[%s]}."
        ),
        noks,
        noks,
        noks
      )

      names(makebull) <- rep("!", nrow(nok))
      makebull <- c(
        "i" = "File{cli::qty(nrow(nok))}{?s} not optimized:",
        makebull
      )

      cli::cli_alert_danger(paste0(
        "Failed to optimize {nrow(nok)} file{?s} in ",
        "{cli::qty(nokdirs)}director{?y/ies} {.path {nokdirs}}."
      ))
    } else {
      # Prepare failed-URL bullets.
      makebull <- sprintf(
        "{.url {nok$src_img[%s]}}: {nok$notes[%s]}.",
        noks,
        noks
      )

      names(makebull) <- rep("!", nrow(nok))
      cli::cli_alert_danger("Failed to optimize {nrow(nok)} URL{?s}:")
    }

    cli::cli_bullets(makebull)
  }

  invisible(NULL)
}
