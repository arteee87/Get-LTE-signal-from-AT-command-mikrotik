:global lastTime;
:global currentSINR [ :toarray [ /log find message~"lte1: rcvd RS-SINR"  ] ] ;
:global currentLineCountSINR [ :len $currentSINR ] ;
:global currentTime [ :totime [/log get [ :pick $currentSINR ($currentLineCountSINR -1) ] time   ] ];
:global currentRSSI [ :toarray [ /log find message~"lte1: rcvd RSSI"  ] ] ;
:global currentLineCountRSSI [ :len $currentRSSI ] ;
:global currentRSRP [ :toarray [ /log find message~"lte1: rcvd AVG RSRP"  ] ] ;
:global currentLineCountRSRP [ :len $currentRSRP ] ;
:global currentRSRQ [ :toarray [ /log find message~"lte1: rcvd RSRQ"  ] ] ;
:global currentLineCountRSRQ [ :len $currentRSRQ ] ;

:global messageSINR "";
:global messageRSSI "";
:global messageRSRP "";
:global messageRSRQ "";
:global valueSINR "";
:global valueRSSI "";
:global valueRSRP "";
:global valueRSRQ "";

:if ( $lastTime = "" ) do={
    :set lastTime $currentTime ;
    :set messageSINR [/log get [ :pick $currentSINR ($currentLineCountSINR-1) ] message];
    :set messageRSSI [/log get [ :pick $currentRSSI ($currentLineCountRSSI-1) ] message];
    :set messageRSRP [/log get [ :pick $currentRSRP ($currentLineCountRSRP-1) ] message];
    :set messageRSRQ [/log get [ :pick $currentRSRQ ($currentLineCountRSRQ-1) ] message];
} else={
    :if ( $lastTime < $currentTime ) do={
        :set lastTime $currentTime ;
        :set messageSINR [/log get [ :pick $currentSINR ($currentLineCountSINR-1) ] message];
        :set messageRSSI [/log get [ :pick $currentRSSI ($currentLineCountRSSI-1) ] message];
        :set messageRSRP [/log get [ :pick $currentRSRP ($currentLineCountRSRP-1) ] message];
        :set messageRSRQ [/log get [ :pick $currentRSRQ ($currentLineCountRSRQ-1) ] message];
    }
}

:if ([:len $messageSINR]=25) do={
    :set valueSINR [:pick $messageSINR 20 23];
} else={
    :if ([:len $messageSINR]=24) do={
        :set valueSINR [:pick $messageSINR 20 22];
        } else={
            :if ([:len $messageSINR]=23) do={
                :set valueSINR [:pick $messageSINR 20];
            } else={
                :set valueSINR "(err)";
}}}
:if ([:len $messageRSSI]=26) do={
    :set valueRSSI [:pick $messageRSSI 17 23];
} else={
    :if ([:len $messageRSSI]=25) do={
        :set valueRSSI [:pick $messageRSSI 17 22];
    } else={
        :set valueRSSI "(err)";
    }
}
:if ([:len $messageRSRQ]=24) do={
    :set valueRSRQ [:pick $messageRSRQ 17 22];
} else={
    :if ([:len $messageRSRQ]=23) do={
        :set valueRSRQ [:pick $messageRSRQ 17 21];
    } else={
        :set valueRSRQ "(err)";
    }  
}
:if ([:len $messageRSRP]=30) do={
    :set valueRSRP [:pick $messageRSRP 21 27];
} else={
    :if ([:len $messageRSRP]=29) do={
        :set valueRSRP [:pick $messageRSRP 21 26];
    } else={
        :set valueRSRP "(err)";
    }
}