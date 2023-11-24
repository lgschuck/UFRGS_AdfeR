library(dplyr)

df_petr <- yfR::yf_get("PETR4.SA",
                       "2020-01-01")

df_ibov <- yfR::yf_get("^BVSP",
                       "2020-01-01") |>
  select(ref_date, ret_adjusted_prices) |>
  rename(ret_ibov = ret_adjusted_prices)

df_petr <- df_petr |>
  left_join(df_ibov, by ='ref_date') |>
  na.omit()

my_lm <- lm(ret_adjusted_prices ~ ret_ibov,
            data = df_petr)

cond_mean <- my_lm$fitted.values
my_res <- my_lm$residuals

n_sim <- 1000

theta_vec <- numeric(n_sim)
for (i_sim in seq(1, n_sim)) {
  
  my_res_sampled <- sample(my_res)
  y_star <- cond_mean + my_res_sampled
  
  df_reg <- tibble(
    y = y_star,
    x = df_petr$ret_adjusted_prices
  )
  
  my_lm_Temp <- lm(y ~x, data = df_reg)
  
  alpha <- coef(my_lm_Temp)[1]
  beta <- coef(my_lm_Temp)[2]
  
  theta_vec[i_sim] <- alpha/beta
}

my_sd <- sd(theta_vec)
my_sd

x11(); hist(theta_vec)
