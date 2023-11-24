## Exercise 03
create_rnd_walk <- function(
    i_sim,
    nT, C, P_0, my_sd
    ) {
  
  R <- numeric(nT)
  P <- numeric(nT)
  P[1] <- P_0
  
  for (t in seq(2, nT)) {
    #cli::cli_alert_info("simulation {i_sim}, price {t}")
    R[t] <- C + rnorm(1, 0, my_sd)
    P[t] <- P[t-1]*exp(R[t])
    
  }
  
  df_out <- tibble::tibble(
    i_sim = i_sim,
    t = 1:nT,
    P = P
  )
  
  return(df_out)
}

set.seed(10)

C <- 0
my_sd = 0.015
my_var <- my_sd^2
nT <- 100
P_0 <- 100
n_sim <- 1000

r <- 0.05
C_strike_price <- 110
P_strike_price <- 90

df_sim <- purrr::map_df(
  1:n_sim,
  create_rnd_walk,
  nT = nT,
  C = C,
  P_0 = P_0,
  my_sd = my_sd
)

library(ggplot2)

prices_at_T <- df_sim |>
  dplyr::filter(t == nT) |>
  dplyr::mutate(
    payoff_C = dplyr::if_else(
      P > C_strike_price, P-C_strike_price,0
    ),
    payoff_P = dplyr::if_else(
      P < P_strike_price, P_strike_price - P,0
    )
  )

C_premium <- mean(prices_at_T$payoff_C)/(1+r)
C_premium

P_premium <- mean(prices_at_T$payoff_P)/(1+r)
P_premium
