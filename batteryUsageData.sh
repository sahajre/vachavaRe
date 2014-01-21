#! /usr/bin/env bash

timeStamp=`date "+%s"`
batteryStatus=`pmset -g batt | grep "InternalBattery" | cut -d";" -f2 | cut -d' ' -f2`
batteryPercentage=`pmset -g batt | grep "InternalBattery" | cut -d";" -f1 | cut -s -f2 | cut -d% -f1`
batteryEstimate=`pmset -g batt | grep "InternalBattery" | cut -d";" -f3`
powerSource=`pmset -g batt | grep "Currently drawing" | cut -d"'" -f2`
presentDir=`dirname $0`
dataFile="${presentDir}/server/batteryStrength.csv"

powerSourceBattery="Battery Power"

if [ -f $dataFile ]
then
  echo "$timeStamp,$batteryStatus,$batteryPercentage,1" >> $dataFile
else
    echo '"time","state","charge","count"' > dataFile
fi

# to make sure the server is available all the time
# when it is already running the command will fail, but that is okay as I am lazy!
cd ${presentDir}/server; python -m SimpleHTTPServer 4242 >& /dev/null &

if [ $batteryPercentage -eq 100 -a "${powerSource}" != "${powerSourceBattery}" ]
then

  say "Fully charged."   

  answer=$(osascript -e 'try
    tell application "SystemUIServer"
    display dialog "The battery is fully charged!\nPlease turn off the external power supply." buttons {"Show Usage Data", "Okay"} default button 2 with title "vachavaRe Battery" giving up after 60
    end
  end' | tr '\r' '\n')

  if [ "$answer" == "button returned:Show Usage Data" ] 
  then
    open "http://localhost:4242/index.html"
  fi

fi

