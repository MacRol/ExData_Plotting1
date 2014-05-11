#
# Exploratory Data Analysis Week-1 Assignment
#
# - Plot 2 Script -
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
# Now prepare to draw second plot - Plot2:
# ========================================
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
# Now draw plot 2:
# ================
# It's a line plot with no label for the x-axis
# and "Global Active Power (kilowatts)" label for y-axis
# The labels at the ticks of the x-axis are the days of the week
# We first start by plotting with the x-axis omitted,
# and we then add the customised x-axis using the axis() call
#
# Plot should be sent to a png file called "plot2.png"
#
png("plot2.png", width=480, height=480)
plot(feb.data$datetime, feb.data$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)", xaxt="n")
#
# Now get the positions on the x-axis of the automatically computed tick marks
# x-axis is #1 (and we'd rotate clockwise from there if we needed the others)
#
computed.ticks <- axTicks(1)
custom.ticks <- c(min(computed.ticks), median(computed.ticks), max(computed.ticks))
label.ticks <- c("Thu", "Fri", "Sat")
#
# Now draw the missing x-axis in our custom way, using the axis() command
#
axis(1, at=custom.ticks, labels=label.ticks)
# Close the current graphical device (the png file) 
dev.off()