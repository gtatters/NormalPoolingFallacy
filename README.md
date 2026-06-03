# The Pooled-Data Normality Fallacy

An interactive Shiny app for BIOL 3P96 (Biostatistics) at Brock University.

## What this app does

A remarkably common mistake in published research is to check the combined
(pooled) data for normality before running a t-test or ANOVA. This app shows
why that is the wrong thing to do.

Both groups in this simulation are drawn from perfectly normal populations —
you set the means, standard deviations, and sample sizes. When the two groups
have different means, pooling them produces a mixture distribution that can
look decidedly non-normal and will often fail a Shapiro-Wilk test. The
normality assumption in a t-test or ANOVA applies *within each group* (or
                                                                       equivalently, to the model residuals), not to the raw pooled data.

Four tabs walk through the demonstration:
  
  1. **Populations** — the true (normal) population curves for each group
2. **Samples** — random samples drawn from each population separately
3. **Pooled Data** — what happens when those samples are combined, with a
Shapiro-Wilk result updated in real time
4. **The Lesson** — a summary of why this matters, with references to the
published literature showing how widespread the error is

## How to use

1. Set means, SDs, and sample sizes for Group A and Group B.
2. Move the means far apart and watch the pooled histogram become bimodal
and the Shapiro-Wilk test fail.
3. Move the means close together and watch the test pass — even though
nothing about the assumption has changed.
4. Press **Resample** to draw a fresh pair of samples.

## Learning goals

- Understand that the normality assumption applies within groups, not to
pooled data
- See how a mixture of two normal distributions can appear non-normal
- Recognise this mistake in published methods sections

## Course context

Developed for BIOL 3P96 — Biostatistics, Brock University.
Built with R and Shiny (base R graphics only).

## References

Midway & White (2025). *R. Soc. Open Sci.* 12:241904.
https://doi.org/10.1098/rsos.241904

Kéry & Hatfield (2003). *Bull. Ecol. Soc. Am.* 84:92–94.