## Exercise 04
df_ibov <- yfR::yf_get("^BVSP", first_date = Sys.Date()-3*365) |>
  na.omit()

C <- mean(df_ibov$ret_adjusted_prices)
my_sd = sd(df_ibov$ret_adjusted_prices)
nT <- 100
P_0 <- dplyr::last(df_ibov$price_adjusted)
n_sim <- 1000


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
  ) |>
    dplyr::mutate(
      ref_date = dplyr::last(df_ibov$ref_date) + 1:nT
    )
  
  return(df_out)
}


df_sim <- purrr::map_df(
  1:n_sim,
  create_rnd_walk,
  nT = nT,
  C = C,
  P_0 = P_0,
  my_sd = my_sd
)

library(ggplot2)

p <- ggplot(df_ibov |>
              dplyr::filter(ref_date >= as.Date('2023-01-01')),
            aes(x = ref_date, 
                         y = price_adjusted)) + 
              geom_line() + 
  geom_line(data = df_sim, 
            aes(x = ref_date,
                y = P,
                group = i_sim),
            alpha = 0.25)
x11(); p
