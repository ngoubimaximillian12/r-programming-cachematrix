
# Load required libraries
if (!require("data.table")) install.packages("data.table", dependencies=TRUE)
library(data.table)

# Set file path (adjust this to your actual upload path)
data_file <- "~/Week 1/household_power_consumption.txt"  # Change if needed

# Use fread if file is accessible; fall back to read.table otherwise
if (file.exists(data_file)) {
  data <- tryCatch({
    fread(data_file, na.strings = "?", sep = ";")
  }, error = function(e) {
    read.table(data_file, header = TRUE, sep = ";", na.strings = "?")
  })
} else {
  stop("Data file not found. Please check the path.")
}

# Convert Date and Time
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data$Datetime <- as.POSIXct(paste(data$Date, data$Time), format = "%Y-%m-%d %H:%M:%S")

# Filter for two specific days
subset_data <- data[data$Date == "2007-02-01" | data$Date == "2007-02-02", ]

### Plot 1 - Histogram
png("plot1.png", width = 480, height = 480)
hist(as.numeric(subset_data$Global_active_power), 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", 
     col = "red")
dev.off()

### Plot 2 - Global Active Power over Time
png("plot2.png", width = 480, height = 480)
plot(subset_data$Datetime, as.numeric(subset_data$Global_active_power), 
     type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
dev.off()

### Plot 3 - Energy Sub Metering
png("plot3.png", width = 480, height = 480)
plot(subset_data$Datetime, as.numeric(subset_data$Sub_metering_1), 
     type = "l", xlab = "", ylab = "Energy sub metering")
lines(subset_data$Datetime, as.numeric(subset_data$Sub_metering_2), col = "red")
lines(subset_data$Datetime, as.numeric(subset_data$Sub_metering_3), col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1)
dev.off()

### Plot 4 - Multiple Base Plots
png("plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))

# Top-left
plot(subset_data$Datetime, as.numeric(subset_data$Global_active_power), 
     type = "l", xlab = "", ylab = "Global Active Power")

# Top-right
plot(subset_data$Datetime, as.numeric(subset_data$Voltage), 
     type = "l", xlab = "datetime", ylab = "Voltage")

# Bottom-left
plot(subset_data$Datetime, as.numeric(subset_data$Sub_metering_1), 
     type = "l", xlab = "", ylab = "Energy sub metering")
lines(subset_data$Datetime, as.numeric(subset_data$Sub_metering_2), col = "red")
lines(subset_data$Datetime, as.numeric(subset_data$Sub_metering_3), col = "blue")
legend("topright", col = c("black", "red", "blue"), lty = 1, bty = "n", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Bottom-right
plot(subset_data$Datetime, as.numeric(subset_data$Global_reactive_power), 
     type = "l", xlab = "datetime", ylab = "Global Reactive Power")

dev.off()

# Confirmation
cat("✅ All plots saved in current directory.\n")
