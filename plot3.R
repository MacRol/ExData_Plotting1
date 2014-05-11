#
# Exploratory Data Analysis Week-1 Assignment
#
# - Plot 3 Script -
# -----------------
#
# Get the URL of the zip file
# Get the name of the zip file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip <- "exdata_data_household_power_consumption.zip"
#
# Download the file if it isn't already there
#
if (!file.exists(zip)) {
    noquote("Downloading zip file from URL...")
    download.file(url,dest=zip,method="curl")
}
#
# Unzip the downloaded zip file
#
noquote("Unzipping downloaded file...")
file <- unzip(zip, list=FALSE, overwrite=TRUE)
#
# From the code book, start with character classes for the date and time column contents,
# and with numeric classes for the remaining 7 column contents
# Code book also mentions that NAs are encoded as '?' so specify that with 'na.strings'
# Checking the .txt file also reveals that ';' is the separator character
#
col.class <- c("character", "character", rep("numeric", 7))
noquote("Reading unzipped file contents into data frame...This takes a little while...")
data <- read.table(file, header=TRUE, sep=";", colClasses=col.class, na.strings="?")
#
# Now convert the date field from a character string to class "Date"
# Checking the .txt file reveals that the initial format is d/m/YYYY
#
noquote("Converting Date field to class Date...This takes a little while...")
data$Date <- as.Date(data$Date, "%d/%m/%Y")
#
# Now that dates are in a predictable Date class, we know that
# their character representation would be in YYYY-MM-DD format.
#
# We use this to filter out the rows that correspond to Feb 1 and Feb 2, 2007
#
noquote("Subsetting data frame to only rows of Feb 1 and Feb2 2007...")
feb.data <- subset(data, data$Date == "2007-02-01" | data$Date == "2007-02-02")
#
# Now remove the initial, massive, data frame to free up computer memory
# Per instructions, remaining work will be on Feb1 and Feb2 2007 data subset
#
rm(data)
#
# Now prepare to draw the third plot - Plot3:
# ===========================================
#
# Remaining plots in assignment are of values against time
# We create a field of class "chron" to capture date+time
# We call the new field 'datetime', and add to data frame
#
if (!("chron" %in% rownames(installed.packages())))
    install.packages("chron")
library(chron)
feb.data$datetime <- chron(as.character(feb.data$Date), feb.data$Time, format=c(dates="y-m-d", times="h:m:s"))

#
# Now draw Plot 3:
# ================
#
# This one overlays in 3 colors 3 line graphs, on the same plot:
# Sub_metering_1: with a black line
# Sub_metering_2: with a red line
# Sub_metering_3: with a blue line
# Also insert a legend at the top right of the plot
#
# We first start by plotting with the x-axis omitted,
# and we then add the customised x-axis using the axis() call
#
# Now get the positions on the x-axis of the automatically computed tick marks
# x-axis is #1 (and we'd rotate clockwise from there if we needed the others)
#
computed.ticks <- axTicks(1)
custom.ticks <- c(min(computed.ticks), median(computed.ticks), max(computed.ticks))
label.ticks <- c("Thu", "Fri", "Sat")
#
# Plot should be sent to a png file called "plot3.png"
#
png("plot3.png", width=480, height=480)
plot(feb.data$datetime, feb.data$Sub_metering_1, xlab="", ylab="Energy sub metering", xaxt="n", type="n")
axis(1,at=custom.ticks,labels=label.ticks)
points(feb.data$datetime, feb.data$Sub_metering_1, type = "l")
points(feb.data$datetime, feb.data$Sub_metering_2, type="l", col="red")
points(feb.data$datetime, feb.data$Sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), cex=0.8, lty=1, col=c("black", "red", "blue"))
#
# Close the current graphic device so it goes back to the screen
#
dev.off()