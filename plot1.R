#
# Exploratory Data Analysis Week-1 Assignment
#
# - Plot 1 Script -
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
# Now draw first plot - Plot1:
# ============================
#
# It's a red histogram of the Global_active_power values, with proper labeling
# Plot should be sent to a png file called "plot1.png"
#
png("plot1.png", width=480, height=480)
hist(feb.data$Global_active_power, col="red", xlab = "Global Active Power (kilowatts)", ylab="Frequency", main="Global Active Power")
dev.off()
