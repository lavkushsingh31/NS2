set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(ant) Antenna/OmniAntenna ;# Antenna type
set val(ll) LL ;# Link layer type
set val(ifq) Queue/DropTail/PriQueue ;# Interface queue type
set val(ifqlen) 50 ;# max packet in ifq
set val(netif) Phy/WirelessPhy ;# network interface type
set val(rp) AODV ;# ad-hoc routing protocol
set val(nn) 20;# number of mobilenodes
set val(mac) Mac/802_11 ;# MAC type
set val(x) 500;
set val(y) 500;
set val(stop) 150;	# time of simulation end



set ns [new Simulator]
set tracefd       [open aodv.tr w]
set windowVsTime2 [open win.tr w]
set namtrace      [open aodv.nam w]   

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

# configure the nodes
        $ns node-config -adhocRouting $val(rp) \
                   -llType $val(ll) \
                   -macType $val(mac) \
                   -ifqType $val(ifq) \
                   -ifqLen $val(ifqlen) \
                   -antType $val(ant) \
                   -propType $val(prop) \
                   -phyType $val(netif) \
                   -channelType $val(chan) \
                   -topoInstance $topo \
                   -agentTrace ON \
                   -routerTrace ON \
                   -macTrace OFF \
                   -movementTrace ON
                   
      for {set i 0} {$i < $val(nn) } { incr i } {
        set node_($i) [$ns node]
        $node_($i) set X_ [ expr 10+round(rand()*480) ]
        $node_($i) set Y_ [ expr 10+round(rand()*380) ]
        $node_($i) set Z_ 0.0
    }

    for {set i 0} {$i < $val(nn) } { incr i } {
        $ns at [ expr 15+round(rand()*60) ] "$node_($i) setdest [ expr 10+round(rand()*480) ] [ expr 10+round(rand()*380) ] [ expr 2+round(rand()*15) ]"
        
    }

# Provide initial location of mobilenodes
#$node_(0) set X_ 5.0
#$node_(0) set Y_ 5.0
#$node_(0) set Z_ 0.0

#$node_(1) set X_ 490.0
#$node_(1) set Y_ 285.0
#$node_(1) set Z_ 0.0

#$node_(2) set X_ 150.0
#$node_(2) set Y_ 240.0
#$node_(2) set Z_ 0.0

#$node_(3) set X_ 350.0
#$node_(3) set Y_ 310.0
#$node_(3) set Z_ 0.0

#$node_(4) set X_ 550.0
#$node_(4) set Y_ 520.0
#$node_(4) set Z_ 0.0

#$node_(5) set X_ 740.0
#$node_(5) set Y_ 730.0
#$node_(5) set Z_ 0.0



# Generation of movements
#$ns at 10.0 "$node_(0) setdest 250.0 250.0 3.0"
#$ns at 15.0 "$node_(1) setdest 45.0 285.0 5.0"
#$ns at 110.0 "$node_(0) setdest 480.0 300.0 5.0"

# Set a UDP connection between node_(0) and node_(1)
set udp [new Agent/UDP]
$udp set class_ 2
set null [new Agent/Null]
$ns attach-agent $node_(0) $udp
$ns attach-agent $node_(1) $null
$ns connect $udp $null
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$ns at 10.0 "$cbr start"

# Printing the window size
#proc plotWindow {tcpSource file} {
#global ns
#set time 0.01
#set now [$ns now]
#set cwnd [$tcpSource set cwnd_]
#puts $file "$now $cwnd"
#$ns at [expr $now+$time] "plotWindow $tcpSource $file" }
#$ns at 10.1 "plotWindow $tcp $windowVsTime2" 

# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
# 30 defines the node size for nam
$ns initial_node_pos $node_($i) 30
}

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}

# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 150.01 "puts \"end simulation\" ; $ns halt"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
exec nam aodv.nam &
exit 0
}

$ns run
