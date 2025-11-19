library(readr)

data <- read_csv("C:/Users/bzimb/Desktop/DA Proj/numeric_data_clean.csv")

# Check column names
colnames(data)


# Select numeric columns
numeric_data <- data[, c("population", "share_of_temperature_change_from_ghg", 
                         "temperature_change_from_co2", "temperature_change_from_ghg", 
                         "consumption_co2", "co2")]

cor_matrix <- cor(numeric_data, use = "complete.obs")  # use complete cases
cor_matrix


cor_matrix["co2", ]  # correlations of co2 with all other numeric variables
cor_matrix["consumption_co2", ]  # correlations of consumption_co2 with others
