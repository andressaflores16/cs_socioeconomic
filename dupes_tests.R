selected_rows <- c(2, 4, 6, 8, 10, 12, 14)

# Calculate row sums for specific rows
wdi_row_sums <- wdi_dupes %>%
  slice(selected_rows) %>%
  mutate(TotalSums = rowSums(select(., where(is.numeric))))
 
# Display the result
print(specific_row_sums)

#---
check_dupes_wdi_v2 <- wdi_wide %>% 
  mutate(dupl=!duplicated(wdi_wide)) %>% 
  group_by(country_code, year) %>% 
  summarize(total=sum(dupl))

#---
# Replace all NA values with 0
wdi_wide_0 <- wdi_wide %>% replace_na(list_if(is.numeric, 0))

# Identify duplicates
df <- df %>% mutate(dupl=duplicated(order_id, product_id))

# Split the data into unique and duplicate rows
df_unique <- df %>% filter(!dupl)
df_dupl <- df %>% filter(dupl)

# For each numeric column, compare the values in the unique and duplicate rows
numeric_cols <- sapply(df, is.numeric)  # Identify numeric columns
for (col in names(df)[numeric_cols]) {
  print(paste("Column:", col))
  
  # Get the values in the unique and duplicate rows
  unique_vals <- df_unique[[col]]
  dupl_vals <- df_dupl[[col]]
  
  # Compare the values
  diff <- setdiff(unique_vals, dupl_vals)
  if (length(diff) > 0) {
    print("Values in unique rows not present in duplicate rows:")
    print(diff)
  }
  
  diff <- setdiff(dupl_vals, unique_vals)
  if (length(diff) > 0) {
    print("Values in duplicate rows not present in unique rows:")
    print(diff)
  }
}
