#!/bin/bash

NUMBER_OF_PICTURES=$(curl --silent http://motiondetector.mobi/pro/9/ia/images.php\?uniquekey\=55301679070175701\&index\=0  | grep -Eo 'image\.php\?uniquekey\=55301679070175701\&index\=[0-9]+' | wc -l)
FIRST_URL_PART='http://motiondetector.mobi/pro/9/ia/image.php?uniquekey=55301679070175701&index='
SECOND_URL_PART='&deleteimage=true'

while [ $NUMBER_OF_PICTURES -gt 0 ]; do
	LOOP_NUMBER=$(( NUMBER_OF_PICTURES -1 ))
	#echo $LOOP_NUMBER
	curl -I --silent -X GET $FIRST_URL_PART$LOOP_NUMBER$SECOND_URL_PART | grep HTTP
	NUMBER_OF_PICTURES=$(( NUMBER_OF_PICTURES -1 ))
done
