BEGIN {
recvdSize = 0
txsize=0
drpSize=0
startTime = 0
stopTime = 0
thru=0

}

{
event = $1
time = $2
node_id = $3
pkt_size = $8
level = $4

# Store start time
if (level == "AGT" && event == "s" ) {
if (time < startTime) {
startTime = time
}
# hdr_size = pkt_size % 400
#      pkt_size -= hdr_size
# Store transmitted packet’s size
txsize++;

}

# Update total received packets’ size and store packets arrival time
if (level == "AGT" && event == "r" ) {
if (time > stopTime) {
stopTime = time
}
# Rip off the header
#  hdr_size = pkt_size % 400
# pkt_size -= hdr_size
# Store received packet’s size
recvdSize++
# thru=(recvdSize/txsize)
# printf(” %.2f %.2f \n” ,time,thru)>”tru2.tr”

}
if (level == "AGT" && event == "D" ) {
# hdr_size = pkt_size % 400
#      pkt_size -= hdr_size
# Store received packet’s size
drpSize++

}
}
END {
printf("Average Throughput[kbps] = %.2f\ns=%.2f\nd=%.2f\nr=%.2f\nStartTime=%.2f\nStopTime=%.2f\n",(recvdSize/(stopTime-startTime)),txsize,drpSize,recvdSize,startTime,stopTime)

}
