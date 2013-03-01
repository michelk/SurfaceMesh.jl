#!/usr/bin/env Rscript
args <- commandArgs(TRUE)
if (length(args) != 1) stop("Usage: perf.R <2dm-file>")
require("methods", quietly = TRUE)
require("SurfaceMesh", quietly = TRUE)
m <- read2dm(args)

### * Face-area calculation
a <- sum(elementAreaIndexMesh(m))
sprintf("R  %f", a)
q(status = 0)
