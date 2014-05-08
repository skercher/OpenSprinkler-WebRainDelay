#!/bin/bash -x

# The URL for the Yahoo weather API. To configure the URL for
# your location, simpy browse to http://weather.yahoo.com and
# navigate to your local weather (by entering the city or zip
# code). When the resulting page comes up, you will find your
# locations ID at the end the URL.  For example, the page for
# Orlando, Fl is
#
# http://weather.yahoo.com/united-states/florida/orlando-23686031/
#
# the ID for that location, therefore, is 23686031.

#loc=12792927
loc=2430632


# The URL to use to connect to the interval program running on
# your OpenSprinkler or OSPi


############ NO NEED TO EDIT BELOW THIS LINE ###############

dir=`dirname "$0"`
xsl="yahoo_weather.xslt"
csv="yahoo_weather.csv"
url="http://weather.yahooapis.com/forecastrss?w=$loc"
pushd $dir > /dev/null
code=`curl "$url" | xsltproc $xsl -`
weather=`grep "^${code}," "$csv"`
delay=`grep "^${code}," "$csv" | cut -d , -f 3`
echo "DELAY " $delay 

if [[ ! -z "$delay" ]];then
    echo "Setting OpenSprinkler for Delay: " $delay " Weather: " $weather 
    curl "${os}/cv?pw=${pw}&rd=$delay"
    echo $weather | mail -s "OpenSprinkler RainDelay DELAY: ${delay} Hours" shawn.kercher@gmail.com
fi
#[[ -z "$delay" ]] || curl "${os}/cv?pw=${pw}&rd=$delay"
popd > /dev/null
