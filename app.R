# =========================================================
# Shiny App: The Pooled-Data Normality Fallacy
# Demonstrates that pooling two normal groups can produce
# a distribution that appears non-normal.
# Requires: shiny only (base R graphics)
# =========================================================


# https://hbctraining.github.io/Training-modules/RShiny/lessons/shinylive.html
# Run the shinylive::export line to populate the docs folder 
# so that shinylive works from github
#shinylive::export(appdir = "../NormalPoolingFallacy/", destdir = "docs")
#httpuv::runStaticServer("docs/", port = 8008)

ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      #resample {
        background-color: #569BBD;
        color: white;
        border: none;
        padding: 6px 14px;
        font-size: 14px;
        margin-top: 4px;
      }
      #resample:hover  { background-color: #3E7C99; }
      #resample:active { transform: scale(0.97); }
      .well { background-color: #f7f7f7; border: 1px solid #ddd; }
      .well .form-group { margin-bottom: 5px; }
      .well h4 { margin-bottom: 6px; }
      blockquote p { margin-bottom: 6px; }
    "))
  ),
  
  titlePanel("The Pooled-Data Normality Fallacy",
             windowTitle = "Pooled Normality"),
  
  sidebarLayout(
    
    sidebarPanel(
      width = 3,
      
      wellPanel(
        h4("Group A", style = "color:#1B9E77; margin-top:0;"),
        sliderInput("mean_a", "Mean:", min = -20, max = 20, value =  0, step = 0.5),
        sliderInput("sd_a",   "SD:",   min =  0.5, max = 10, value =  2, step = 0.5),
        sliderInput("n_a",    "n:",    min =  5,   max = 200, value = 30, step = 5)
      ),
      
      wellPanel(
        h4("Group B", style = "color:#D95F02; margin-top:0;"),
        sliderInput("mean_b", "Mean:", min = -20, max = 20, value =  5, step = 0.5),
        sliderInput("sd_b",   "SD:",   min =  0.5, max = 10, value =  2, step = 0.5),
        sliderInput("n_b",    "n:",    min =  5,   max = 200, value = 30, step = 5)
      ),
      
      actionButton("resample", "Resample"),
      
      br(), br(),
      
      helpText("Glenn Tattersall, PhD"),
      helpText("For use in BIOL 3P96 - Biostatistics")
    ),
    
    mainPanel(
      width = 9,
      
      tabsetPanel(
        type = "tabs",
        
        # ---- Tab 1: Populations ----
        tabPanel(
          "Populations",
          br(),
          plotOutput("pop_plot", height = "420px"),
          br(),
          wellPanel(
            p(
              strong("What are we looking at?"),
              " Each curve represents the true population from which each ",
              "group's data will be drawn. Both populations are perfectly normal — ",
              "they just have different means and/or standard deviations. ",
              "Use the sliders to move the populations closer together or further apart, ",
              "and to change how spread out each one is."
            ),
            tags$hr(),
            p(strong("How common is this mistake?")),
            p(
              "A 2025 review in ", em("Royal Society Open Science"),
              " found that ", strong("over 70% of ecology papers and 90% of biology papers"),
              " applied normality tests to the raw data rather than to model residuals. ",
              "This is not a fringe error — it is the dominant practice in the published literature.",
              tags$br(),
              tags$small(
                style = "color:#777;",
                "Midway & White (2025) ",
                tags$em("R. Soc. Open Sci."),
                " 12:241904. ",
                tags$a("https://doi.org/10.1098/rsos.241904",
                       href = "https://doi.org/10.1098/rsos.241904",
                       target = "_blank")
              )
            ),
            p(
              "An earlier paper called it ",
              em("\"by far the most common misconception\""),
              " encountered when consulting for ecologists and wildlife biologists, ",
              "and noted the error likely appears in countless published studies.",
              tags$br(),
              tags$small(
                style = "color:#777;",
                "Kéry & Hatfield (2003) ",
                tags$em("Bull. Ecol. Soc. Am."),
                " 84:92–94. ",
                tags$a("https://www.jstor.org/stable/10.2307/bullecosociamer.84.2.92",
                       href   = "https://www.jstor.org/stable/10.2307/bullecosociamer.84.2.92",
                       target = "_blank")
              )
            ),
            p("Typical methods-section wording looks like this (paraphrased from published protocols):"),
            tags$blockquote(
              style = "border-left: 4px solid #ccc; padding-left: 12px; color: #555; font-style: italic;",
              p("\"All data were tested for normality using the Shapiro-Wilk test prior to ",
                "statistical analysis. Group differences were then assessed using an independent ",
                "samples t-test.\""),
              p("\"Data were checked for normality before applying a one-way ANOVA to compare ",
                "means across treatment groups.\"")
            ),
            p(
              "The problem: when data come from two groups with different means, ",
              "pooling them before testing creates a mixture distribution — which ",
              "may appear non-normal even though each group is perfectly normal on its own. ",
              "The tabs above let you see exactly when and why this happens."
            )
          )
        ),
        
        # ---- Tab 2: Samples ----
        tabPanel(
          "Samples",
          br(),
          plotOutput("sample_plot", height = "420px"),
          br(),
          wellPanel(
            p(
              strong("Random samples from each group."),
              " We drew a random sample from each population. ",
              "Each histogram shows the data from one group on its own. ",
              "Because each group was drawn from a normal population, ",
              "each sample should look roughly bell-shaped — though with small ",
              "sample sizes there will be some random wobble."
            )
          )
        ),
        
        # ---- Tab 3: Pooled data ----
        tabPanel(
          "Pooled Data",
          br(),
          plotOutput("pooled_plot", height = "420px"),
          br(),
          wellPanel(
            uiOutput("pooled_explanation")
          )
        ),
        
        # ---- Tab 4: The lesson ----
        tabPanel(
          "The Lesson",
          br(),
          plotOutput("lesson_plot", height = "500px"),
          br(),
          wellPanel(
            p(
              strong("Why this matters for your methods section."),
              " A common mistake is to check the raw (pooled) data for normality ",
              "before running a t-test, ANOVA, or linear model. But the normality ",
              "assumption in those tests is NOT about the raw pooled data — it is ",
              "about the data ",
              em("within each group"),
              " (or equivalently, about the residuals after fitting the model)."
            ),
            p(
              "If your two groups have different means, their data will pile up in ",
              "different places. Pool them together and you can get a ",
              "double-humped (bimodal) distribution — which will fail a normality ",
              "test even though each group is perfectly normal on its own. ",
              "Testing the pooled data does not tell you whether your groups meet ",
              "the assumption; it mainly tells you whether your groups differ — ",
              "which is exactly what you are trying to test in the first place!"
            ),
            p(
              strong("The correct approach:"),
              " Test each group separately, inspect residuals from your fitted model, ",
              "or use a Q-Q plot of model residuals. Do not test the raw pooled observations."
            ),
            p(
              strong("Reading this plot:"),
              " The x-axis shows the raw difference between group means. ",
              "The blue ribbon shows the range of W values across 1000 random samples — ",
              "lower W means more evidence against normality. ",
              "The dashed grey line is the critical W for your current sample sizes ",
              "(estimated from the simulation), below which p < 0.05. ",
              "The orange shaded zone marks where more than half of all samples ",
              "would be flagged as non-normal."
            )
          )
        )
      )
    )
  )
)

# =========================================================
# Server
# =========================================================

server <- function(input, output, session) {
  
  col_a    <- "#1B9E77"
  col_b    <- "#D95F02"
  col_pool <- "#569BBD"
  
  # ---- Reactive: draw samples (cached) ----
  samples <- reactive({
    input$resample
    list(
      a = rnorm(input$n_a, mean = input$mean_a, sd = input$sd_a),
      b = rnorm(input$n_b, mean = input$mean_b, sd = input$sd_b)
    )
  })
  
  # ---- Reactive: pooled vector ----
  pooled <- reactive({
    s <- samples()
    c(s$a, s$b)
  })
  
  # ---- Reactive: Shapiro-Wilk on pooled data (computed once, shared) ----
  sw_pooled <- reactive({
    shapiro.test(pooled())
  })
  
  # ---- Helper: normal density curve ----
  add_normal_curve <- function(mu, sigma, col, lwd = 2.5) {
    xs <- seq(mu - 4 * sigma, mu + 4 * sigma, length.out = 300)
    lines(xs, dnorm(xs, mean = mu, sd = sigma), col = col, lwd = lwd)
  }
  
  # ---- Tab 1: Population curves ----
  output$pop_plot <- renderPlot({
    
    mu_a <- input$mean_a;  sd_a <- input$sd_a
    mu_b <- input$mean_b;  sd_b <- input$sd_b
    
    xlim  <- c(min(mu_a - 4*sd_a, mu_b - 4*sd_b),
               max(mu_a + 4*sd_a, mu_b + 4*sd_b))
    y_max <- max(dnorm(mu_a, mu_a, sd_a), dnorm(mu_b, mu_b, sd_b)) * 1.25
    
    par(mar = c(5, 5, 3, 2), cex.axis = 1.3, cex.lab = 1.4, cex.main = 1.5)
    plot(NULL, xlim = xlim, ylim = c(0, y_max),
         xlab = "Value", ylab = "Density",
         main = "True Population Distributions")
    
    xs_a <- seq(xlim[1], xlim[2], length.out = 500)
    polygon(c(xs_a, rev(xs_a)),
            c(dnorm(xs_a, mu_a, sd_a), rep(0, 500)),
            col = adjustcolor(col_a, alpha.f = 0.20), border = NA)
    polygon(c(xs_a, rev(xs_a)),
            c(dnorm(xs_a, mu_b, sd_b), rep(0, 500)),
            col = adjustcolor(col_b, alpha.f = 0.20), border = NA)
    
    add_normal_curve(mu_a, sd_a, col_a)
    add_normal_curve(mu_b, sd_b, col_b)
    
    legend("topright",
           legend = c(paste0("Group A  (mean=", mu_a, ", SD=", sd_a, ")"),
                      paste0("Group B  (mean=", mu_b, ", SD=", sd_b, ")")),
           col = c(col_a, col_b), lwd = 3, bty = "n", cex = 1.2)
  })
  
  # ---- Tab 2: Sample histograms ----
  output$sample_plot <- renderPlot({
    
    s    <- samples()
    xlim <- range(c(s$a, s$b,
                    input$mean_a - 4*input$sd_a,
                    input$mean_b + 4*input$sd_b))
    
    par(mfrow = c(1, 2), mar = c(5, 5, 4, 2),
        cex.axis = 1.3, cex.lab = 1.4, cex.main = 1.5)
    
    sw_a <- shapiro.test(s$a)
    sw_b <- shapiro.test(s$b)
    
    plot_sample_hist <- function(x, mu, sigma, col, label, sw) {
      h    <- hist(x, plot = FALSE, breaks = "Sturges")
      xs   <- seq(xlim[1], xlim[2], length.out = 300)
      ys   <- dnorm(xs, mean = mu, sd = sigma)
      ylim <- c(0, max(max(h$density), max(ys)) * 1.25)
      hist(x, freq = FALSE, col = adjustcolor(col, alpha.f = 0.55),
           border = "white", main = label,
           xlab = "Value", ylab = "Density",
           xlim = xlim, ylim = ylim, breaks = "Sturges")
      lines(xs, ys, col = col, lwd = 2.5)
      mtext(paste0("Shapiro-Wilk: W = ", round(sw$statistic, 3),
                   ",  p = ", signif(sw$p.value, 3)),
            side = 3, line = 0.2, cex = 1.1)
    }
    
    plot_sample_hist(s$a, input$mean_a, input$sd_a, col_a,
                     paste0("Group A  (n = ", input$n_a, ")"), sw_a)
    plot_sample_hist(s$b, input$mean_b, input$sd_b, col_b,
                     paste0("Group B  (n = ", input$n_b, ")"), sw_b)
  })
  
  # ---- Tab 3: Pooled histogram ----
  output$pooled_plot <- renderPlot({
    
    s   <- samples()
    pld <- pooled()
    sw  <- sw_pooled()
    
    mu_pool <- mean(pld)
    sd_pool <- sd(pld)
    
    d_a  <- density(s$a)
    d_b  <- density(s$b)
    xlim <- range(pld)
    h    <- hist(pld, plot = FALSE, breaks = "Sturges")
    xs   <- seq(xlim[1], xlim[2], length.out = 400)
    ys   <- dnorm(xs, mu_pool, sd_pool)
    ylim <- c(0, max(max(h$density), max(ys),
                     max(d_a$y), max(d_b$y)) * 1.25)
    
    par(mar = c(5, 5, 4, 2), cex.axis = 1.3, cex.lab = 1.4, cex.main = 1.5)
    
    hist(pld, freq = FALSE,
         col = adjustcolor(col_pool, alpha.f = 0.55), border = "white",
         main = paste0("Pooled Data  (n = ", length(pld), ")"),
         xlab = "Value", ylab = "Density",
         xlim = xlim, ylim = ylim, breaks = "Sturges")
    
    lines(xs, ys, col = col_pool, lwd = 2.5, lty = 2)
    lines(d_a, col = col_a, lwd = 2)
    lines(d_b, col = col_b, lwd = 2)
    
    mtext(paste0("Shapiro-Wilk on pooled data: W = ", round(sw$statistic, 3),
                 ",  p = ", signif(sw$p.value, 3)),
          side = 3, line = 0.2, cex = 1.1)
    
    legend("topright",
           legend = c("Group A (density)", "Group B (density)",
                      "Normal fitted to pooled data"),
           col = c(col_a, col_b, col_pool),
           lwd = c(2, 2, 2.5), lty = c(1, 1, 2),
           bty = "n", cex = 1.1)
  })
  
  # ---- Tab 3: Explanation text ----
  output$pooled_explanation <- renderUI({
    
    sw     <- sw_pooled()
    p_val  <- signif(sw$p.value, 3)
    w_stat <- round(sw$statistic, 3)
    sig    <- sw$p.value < 0.05
    diff   <- abs(input$mean_a - input$mean_b)
    
    verdict <- if (sig) {
      paste0(
        "\u274C The pooled data fail the Shapiro-Wilk normality test ",
        "(W = ", w_stat, ", p = ", p_val, "). ",
        "Yet each group on its own was drawn from a normal population! ",
        "The test is picking up the separation between the two group means, ",
        "not a true violation of the normality assumption."
      )
    } else {
      paste0(
        "\u2705 The pooled data pass the Shapiro-Wilk test ",
        "(W = ", w_stat, ", p = ", p_val, "). ",
        "This tends to happen when the two group means are close together ",
        "or the sample sizes are small — the two humps haven't been ",
        "separated enough to be detectable yet. ",
        "Try moving the means further apart to see the test fail."
      )
    }
    
    tip <- if (diff < 1.5 * max(input$sd_a, input$sd_b)) {
      paste0(
        "Tip: The two group means are currently fairly close relative to their ",
        "spread. Move them further apart with the sliders to make the ",
        "pooled distribution more obviously non-normal."
      )
    } else {
      paste0(
        "Notice how the dashed blue curve (a single normal fitted to the pooled data) ",
        "doesn't match the actual shape. The pooled data have a flatter or ",
        "double-humped shape because two separate groups have been mixed together."
      )
    }
    
    tagList(
      p(strong("Shapiro-Wilk result on the pooled data:"), verdict),
      p(tip)
    )
  })
  
  # ---- Tab 4: W vs mean difference with 95% CI ribbon ----
  output$lesson_plot <- renderPlot({
    
    sd_a <- input$sd_a
    sd_b <- input$sd_b
    n_a  <- input$n_a
    n_b  <- input$n_b
    
    max_diff <- 5 * max(sd_a, sd_b)
    diffs    <- seq(0, max_diff, length.out = 40)
    n_rep    <- 1000
    
    # Run simulation: collect W statistic and significance for each replicate
    sim <- lapply(diffs, function(d) {
      w_vec   <- numeric(n_rep)
      sig_vec <- logical(n_rep)
      for (i in seq_len(n_rep)) {
        a   <- rnorm(n_a, mean = 0, sd = sd_a)
        b   <- rnorm(n_b, mean = d, sd = sd_b)
        sw  <- suppressWarnings(shapiro.test(c(a, b)))
        w_vec[i]   <- sw$statistic
        sig_vec[i] <- sw$p.value < 0.05
      }
      list(w = w_vec, sig = sig_vec)
    })
    
    w_mat    <- sapply(sim, `[[`, "w")    # n_rep x 40 matrix
    sig_mat  <- sapply(sim, `[[`, "sig")  # n_rep x 40 matrix
    
    w_med    <- apply(w_mat,  2, median)
    w_lo     <- apply(w_mat,  2, quantile, probs = 0.025)
    w_hi     <- apply(w_mat,  2, quantile, probs = 0.975)
    prop_sig <- apply(sig_mat, 2, mean)
    
    # Critical W estimated from simulation at d=0: the 5th percentile of W
    # when there is no true group difference — this is the n-adjusted threshold
    crit_w <- quantile(w_mat[, 1], probs = 0.05)
    
    # Where does the majority (>50%) of samples start failing?
    majority_fail <- which(prop_sig >= 0.50)
    fail_start    <- if (length(majority_fail) > 0) diffs[majority_fail[1]] else NA
    
    current_diff <- abs(input$mean_a - input$mean_b)
    
    y_min <- min(w_lo) - 0.02
    y_max <- 1.0
    
    par(mar = c(5, 5, 4, 2), cex.axis = 1.3, cex.lab = 1.4, cex.main = 1.5)
    
    plot(NULL, xlim = range(diffs), ylim = c(y_min, y_max),
         xlab = "Difference between group means",
         ylab = "Shapiro-Wilk W statistic",
         main = "How Mean Separation Drives Apparent Non-Normality")
    
    # Orange shaded zone: where >50% of samples fail (option 3)
    if (!is.na(fail_start)) {
      rect(fail_start, y_min, max(diffs), y_max,
           col = adjustcolor(col_b, alpha.f = 0.10), border = NA)
      text(fail_start + (max(diffs) - fail_start) / 2, y_max - 0.01,
           ">50% of samples fail normality test",
           col = col_b, cex = 0.95, adj = c(0.5, 1))
    }
    
    # Blue 95% CI ribbon
    polygon(c(diffs, rev(diffs)),
            c(w_hi, rev(w_lo)),
            col = adjustcolor(col_pool, alpha.f = 0.20), border = NA)
    lines(diffs, w_hi, col = col_pool, lwd = 1.5, lty = 2)
    lines(diffs, w_lo, col = col_pool, lwd = 1.5, lty = 2)
    lines(diffs, w_med, col = col_pool, lwd = 2.5)
    
    # Critical W line (option 2)
    abline(h = crit_w, lty = 2, col = "grey40")
    text(max_diff * 0.98, crit_w + 0.004,
         paste0("Critical W  (p = 0.05, n = ", n_a + n_b, ")"),
         col = "grey40", adj = c(1, 0), cex = 0.95)
    
    # Current slider setting marker
    abline(v = current_diff, col = col_b, lwd = 2, lty = 3)
    text(current_diff, y_min + 0.02,
         paste0("Your setting\n(\u0394 = ", round(current_diff, 1), ")"),
         col = col_b, adj = c(-0.1, 0), cex = 1.0)
    
    legend("bottomleft",
           legend = c("Median W", "95% interval", ">50% fail zone"),
           col    = c(col_pool,
                      adjustcolor(col_pool, alpha.f = 0.5),
                      adjustcolor(col_b, alpha.f = 0.3)),
           lwd    = c(2.5, 8, 8),
           bty = "n", cex = 1.1)
    
    mtext(paste0("(n\u2090 = ", n_a, ", SD\u2090 = ", sd_a,
                 ";  n\u1d2e = ", n_b, ", SD\u1d2e = ", sd_b,
                 ";  ", n_rep, " replicates per point)"),
          side = 3, line = 0.1, cex = 1.0, col = "grey40")
  })
}

shinyApp(ui = ui, server = server)