library(parallel)

timeconsumingfun <- function() {
  Sys.sleep(5)  
}

n <- 5

# Serial execution using system.time
serial_time <- system.time({
  for (i in 1:n) {
    timeconsumingfun()
  }
})
cat("ts:", serial_time["elapsed"], "\n")

# Parallel computing
workers <- detectCores()
num_cores <- min(workers - 1, 4)
c <- makeCluster(num_cores)
clusterExport(c, "timeconsumingfun")

# Parallel execution using system.time
parallel_time <- system.time({
  parLapply(c, 1:n, function(x) timeconsumingfun())
})

stopCluster(c)

cat("tp:", parallel_time["elapsed"], "\n")

speedup <- as.numeric(serial_time["elapsed"]) / as.numeric(parallel_time["elapsed"])
efficiency <- (speedup / num_cores) * 100

cat("Speedup:", speedup, "\n")
cat("Efficiency:", efficiency, "%\n")
