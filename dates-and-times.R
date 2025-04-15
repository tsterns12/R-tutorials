# Create dataframe
time <- data.frame(day = c(1, 5, 6, 14, 5, 18, 11, 20, 31, 31, 24, 5),
                   month = c(1, 2, 3, 6, 4, 3, 7, 8, 4, 5, 6, 7),
                   year = c(paste0(199, 0:9), 1967, 1988))

# Check initial variables & var types
time
str(time) # mix of character and numeric variables

# Note that row 9 in 'time' = April 31, 1998 -- which is not a possible date.
# Follow row 9 throughout the code to see how it's handled...

# Create 'date' variable
time1 <- time %>%
  mutate(date = paste(year, month, day, sep = "-"))

time1
class(time1$date) # date is a character variable

# Convert 'date' to date/time format
time2 <- time1 %>%
  mutate(date = as.POSIXct(date, format = "%Y-%m-%d", tz = 'UTC'))

time2
str(time2) 
# 'date' is now in a date/time format.
# Note that 'date' is now NA for row 9 as April 31, 1998 isn't possible.



