# Initialization settings
BEGIN {
          
        droppacket=0;
        sendLine = 0;
        recvLine = 0;
        fowardLine = 0;
        if(mseq==0)
  mseq=10000;
 for(i=0;i<mseq;i++){
  rseq[i]=-1;
  sseq[i]=-1;
 }
}
# Applications received packet
$0 ~/^s.* AGT/ {
# if(sseq[$6]==-1){
         sendLine ++ ;
#        sseq[$6]=$6;
# }
}

# Applications to send packets
$0 ~/^r.* AGT/{
# if(rreq[$6]==-1){
         recvLine ++ ;
#         sseq[$6]=$6;
#        }

}


# Routing procedures to forward the packet
$0 ~/^f.* RTR/ {

        fowardLine ++ ;

}

#150
#170
#300
#400
#500

# Final output
END {

droppacket=sendLine-recvLine
printf "cbr Send Packets:%d\nrecieve Packets:%d\nPacket Delivery Ratio :%.4f\nNumber of packet forwarded:%d\nNumber of Packet dropped=%d\n", sendLine, recvLine, (recvLine/sendLine),fowardLine,droppacket;

}
