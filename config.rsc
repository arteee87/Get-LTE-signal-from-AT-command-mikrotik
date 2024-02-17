/system logging
add topics=async

/system script
add dont-require-permissions=yes name=lte_info owner=arteee87 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="/in lte at-chat [find where \
    name=lte1] input=\"AT^DEBUG\?\"\r\
    \n/in lte at-chat [find where name=lte1] input=\"AT^CA_INFO\?\""
add dont-require-permissions=no name=lte_log_parser policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":global lastTime;\r\
    \n\r\
    \n:global currentSINR [ :toarray [ /log find message~\"lte1: rcvd RS-SINR\"  ] ] ;\r\
    \n:global currentLineCountSINR [ :len \$currentSINR ] ;\r\
    \n:global currentTime [ :totime [/log get [ :pick \$currentSINR (\$currentLineCountSINR -1) ] time   ] ];\r\
    \n\r\
    \n:global currentRSSI [ :toarray [ /log find message~\"lte1: rcvd RSSI\"  ] ] ;\r\
    \n:global currentLineCountRSSI [ :len \$currentRSSI ] ;\r\
    \n\r\
    \n:global currentRSRP [ :toarray [ /log find message~\"lte1: rcvd AVG RSRP\"  ] ] ;\r\
    \n:global currentLineCountRSRP [ :len \$currentRSRP ] ;\r\
    \n\r\
    \n:global currentRSRQ [ :toarray [ /log find message~\"lte1: rcvd RSRQ\"  ] ] ;\r\
    \n:global currentLineCountRSRQ [ :len \$currentRSRQ ] ;\r\
    \n\r\
    \n:global messageSINR \"\";\r\
    \n:global messageRSSI \"\";\r\
    \n:global messageRSRP \"\";\r\
    \n:global messageRSRQ \"\";\r\
    \n\r\
    \n:global valueSINR \"\";\r\
    \n:global valueRSSI \"\";\r\
    \n:global valueRSRP \"\";\r\
    \n:global valueRSRQ \"\";\r\
    \n\r\
    \n:if ( \$lastTime = \"\" ) do={\r\
    \n    :set lastTime \$currentTime ;\r\
    \n    :set messageSINR [/log get [ :pick \$currentSINR (\$currentLineCountSINR-1) ] message];\r\
    \n    :set messageRSSI [/log get [ :pick \$currentRSSI (\$currentLineCountRSSI-1) ] message];\r\
    \n    :set messageRSRP [/log get [ :pick \$currentRSRP (\$currentLineCountRSRP-1) ] message];\r\
    \n    :set messageRSRQ [/log get [ :pick \$currentRSRQ (\$currentLineCountRSRQ-1) ] message];\r\
    \n \r\
    \n} else={\r\
    \n    :if ( \$lastTime < \$currentTime ) do={\r\
    \n        :set lastTime \$currentTime ;\r\
    \n        :set messageSINR [/log get [ :pick \$currentSINR (\$currentLineCountSINR-1) ] message];\r\
    \n        :set messageRSSI [/log get [ :pick \$currentRSSI (\$currentLineCountRSSI-1) ] message];\r\
    \n        :set messageRSRP [/log get [ :pick \$currentRSRP (\$currentLineCountRSRP-1) ] message];\r\
    \n        :set messageRSRQ [/log get [ :pick \$currentRSRQ (\$currentLineCountRSRQ-1) ] message];\r\
    \n    }\r\
    \n}\r\
    \n\r\
    \n:if ([:len \$messageSINR]=25) do={\r\
    \n    :set valueSINR [:pick \$messageSINR 20 23];\r\
    \n} else={\r\
    \n    :if ([:len \$messageSINR]=24) do={\r\
    \n        :set valueSINR [:pick \$messageSINR 20 22];\r\
    \n        } else={\r\
    \n            :if ([:len \$messageSINR]=23) do={\r\
    \n                :set valueSINR [:pick \$messageSINR 20];\r\
    \n            } else={\r\
    \n                :set valueSINR \"(err)\";\r\
    \n}}}\r\
    \n\r\
    \n:if ([:len \$messageRSSI]=26) do={\r\
    \n    :set valueRSSI [:pick \$messageRSSI 17 23];\r\
    \n} else={\r\
    \n    :if ([:len \$messageRSSI]=25) do={\r\
    \n        :set valueRSSI [:pick \$messageRSSI 17 22];\r\
    \n    } else={\r\
    \n        :set valueRSSI \"(err)\";\r\
    \n    }\r\
    \n}\r\
    \n\r\
    \n:if ([:len \$messageRSRQ]=24) do={\r\
    \n    :set valueRSRQ [:pick \$messageRSRQ 17 22];\r\
    \n} else={\r\
    \n    :if ([:len \$messageRSRQ]=23) do={\r\
    \n        :set valueRSRQ [:pick \$messageRSRQ 17 21];\r\
    \n    } else={\r\
    \n        :set valueRSRQ \"(err)\";\r\
    \n    }  \r\
    \n}\r\
    \n\r\
    \n:if ([:len \$messageRSRP]=30) do={\r\
    \n    :set valueRSRP [:pick \$messageRSRP 21 27];\r\
    \n} else={\r\
    \n    :if ([:len \$messageRSRP]=29) do={\r\
    \n        :set valueRSRP [:pick \$messageRSRP 21 26];\r\
    \n    } else={\r\
    \n        :set valueRSRP \"(err)\";\r\
    \n    }\r\
    \n}"
add dont-require-permissions=no name=http_push_lte_signal_info owner=arteee87 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":global valueSINR;\r\
    \n:global valueRSSI;\r\
    \n:global valueRSRP;\r\
    \n:global valueRSRQ;\r\
    \n\r\
    \n:local pushdata \"<prtg><result><channel>RSRQ</channel><value>\$valueRSRQ</value><float>1</float><u\
    nit>custom</unit><customunit>dB</customunit></result><result><channel>RSRP</channel><value>\$valueRSR\
    P</value><float>1</float><unit>custom</unit><customunit>dBm</customunit></result><result><channel>RSS\
    I</channel><value>\$valueRSSI</value><float>1</float><unit>custom</unit><customunit>dBm</customunit><\
    /result><result><channel>SINR</channel><value>\$valueSINR</value><unit>custom</unit><customunit>dB</c\
    ustomunit></result></prtg>\";\r\
    \n\r\
    \n:local prtg \"http://192.168.0.7:5050\";\r\
    \n:local token \"3EEDB517-ECB4-4952-9886-072D936B2FBF\";\r\
    \n\r\
    \n/tool fetch http-method=get url=\"\$prtg/\$token\?content=\$pushdata\" http-header-field=\"h1:appli\
    cation/x-www-form-urlencoded\""

/system scheduler
add interval=15s name=lte_info on-event="/system/script/run lte_info" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-time=startup
add interval=30s name=lte_log_parser on-event="/system script run lte_log_parser" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-time=startup
add interval=1m name=send_lte_info on-event="/system script run http_push_lte_signal_info" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-time=startup
