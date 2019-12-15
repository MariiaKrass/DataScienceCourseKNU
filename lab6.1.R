data = read.table("lab6.txt", sep = ";", header = T)
data[,"Date"] = as.Date(data[,"Date"], format = "%d/%m/%Y")
data = data[(data[,"Date"] <= as.Date("2007-02-02")) & (data[,"Date"] >= as.Date("2007-02-01")), ]

GAP = data[data[,"Global_active_power"] != "?", "Global_active_power"]
hist(as.numeric(GAP), xlab = "Global active power (killowatts)", 
     ylab = "Frequency", col = "Red", main = "Global active power")