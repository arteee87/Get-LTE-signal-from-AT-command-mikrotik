This does the following:
1) send at command to the modem
2) show output in the log
3) extract values of SINR, RSSI, RSRQ, RSRP
4) send HTTP GET packet to the PRTG PROBE with these values

It is done this way as reading AT-CHAT directly does not work (dont ask me why).

Running or pasting the contents of "config.rsc" file should do all the setup.
After that go to the "http_push_lte_signal_info" script in your router's /system/scripts/ menu and change the variables "prtg" and "token" to the correct ones.

Tested on rbm33g, routeros 7.14beta10, modem Dell DW5821e fw T77W968.F1.0.0.5.2.GC.013 035
PRTG version 24.1.92.1496+ [Preview], HTTP Push Data Advanced sensor
