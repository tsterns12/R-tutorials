fakedata <- data.frame(ptc = rep(1:100, 4),
                       time = c(rep(1, 100), rep(2, 100), rep(3, 100), rep(4, 100)))

A1 = rnorm(100, mean = 26, sd = 2)
A2 = rnorm(100, mean = 28, sd = 2)
A3 = rnorm(100, mean = 30, sd = 2)
A4 = rnorm(100, mean = 32, sd = 2)

Y1 = rnorm(100, mean = 104, sd = 15)
Y2 = rnorm(100, mean = 102, sd = 15)
Y3 = rnorm(100, mean = 100, sd = 15)
Y4 = rnorm(100, mean = 98, sd = 15)

fakedata <- fakedata %>%
  mutate(A = c(A1, A2, A3, A4),
         Y = c(Y1, Y2, Y3, Y4)) %>%
  group_by(ptc) %>%
  mutate(mean_A = mean(A)) %>%
  ungroup()
