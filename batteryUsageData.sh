#! /usr/bin/env bash

timeStamp=`date "+%s"`
batteryStatus=`pmset -g batt | grep "InternalBattery" | cut -d";" -f2 | cut -d' ' -f2`
batteryPercentage=`pmset -g batt | grep "InternalBattery" | cut -d";" -f1 | cut -s -f2 | cut -d% -f1`
batteryEstimate=`pmset -g batt | grep "InternalBattery" | cut -d";" -f3`
dataFile="./server/batteryStrength.csv"

if [ -f $dataFile ]
then
  echo "$timeStamp,$batteryStatus,$batteryPercentage,1" >> $dataFile
else
    echo '"time","state","charge","count"' > dataFile
fi

if [ $batteryPercentage -eq 100 ]
then

  say "Fully charged."   

  answer=$(osascript -e 'try
    tell application "SystemUIServer"
    display dialog "The battery is fully charged!\nPlease turn off the external power supply." buttons {"Show Usage Data", "Okay"} default button 2 with title "vachavaRe Battery"
    end
  end' | tr '\r' '\n')

  if [ "$answer" == "button returned:Show Usage Data" ] 
  then
    cd server; python -m SimpleHTTPServer 4242 >& /dev/null &
    open "http://localhost:4242/index.html"
  fi

fi
