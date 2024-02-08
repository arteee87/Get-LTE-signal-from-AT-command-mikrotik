:global valueSINR;
:global valueRSSI;
:global valueRSRP;
:global valueRSRQ;

:local pushdata "<prtg><result><channel>RSRQ</channel><value>$valueRSRQ</value><unit>custom</unit><customunit>dB</customunit></result><result><channel>RSRP</channel><value>$valueRSRP</value><unit>custom</unit><customunit>dBm</customunit></result><result><channel>RSSI</channel><value>$valueRSSI</value><unit>custom</unit><customunit>dBm</customunit></result><result><channel>SINR</channel><value>$valueSINR</value><unit>custom</unit><customunit>dB</customunit></result></prtg>";
:local prtg "http://PRTG PROBE IP:PORT";
:local token "TOKEN FORM THE HTTP PUSH DATA ADVANCED SENSOR (USE HTTP GET)";

/tool fetch http-method=get url="$prtg/$token?content=$pushdata" http-header-field="h1:application/x-www-form-urlencoded"