## lanscape appearance

rm(list=ls(all=TRUE))

df <- as.data.frame(data)

View(df)

df$class <- NA

df[1:6, 2] <- rep(2.5, times = 6)

df[7:19, 2] <- rep(13, times = 13)

df[20:35, 2] <- rep(30, times = 16)

df[36:67, 2] <- rep(50, times = 32)

df[68:77, 2] <- rep(70, times = 10)

df[78:80, 2] <- rep(88, times = 3)

s

str(df)

mean(df$class)

sd(df$class)

## standard error funtion
se <- function(x) sqrt(var(x)/length(x))
se(df$class)

## force the data frame into a factor to create a count table

factorframe <- as.factor(df$class)

table <- table(factorframe)

str(table)

## lets write a function!!!

fun<- function(midpoint, counts) {
  rep(midpoint, 
      times = counts)
}

la.df <- c(fun(2.5, 6), fun(13, 13), fun(30, 16), fun(50, 32), fun(70, 10), fun(88, 3))

View(la.df)

lamean<- mean(la.df)

sd(la.df)

lase <-se(la.df)

coninf <- c(lamean - lase*1.96, lamean + lase*1.96)

