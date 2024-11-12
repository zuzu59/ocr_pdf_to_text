#!/usr/bin/env bash
#Copie les pdf depuis mon iMAC sur mon LXC
#zf241112.1628

rsync -n --delete -r -v -t --progress --stats --modify-window=1 -e ssh zuzu@192.168.0.138:"/Users/zuzu/Desktop/Flash\ info/pdf_avant_1996" ./


