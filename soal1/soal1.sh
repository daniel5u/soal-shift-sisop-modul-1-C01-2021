#!/bin/bash

input="syslog.log"

cut -d " " -f 1-3 $input
grep -oE "(ERROR)(.*)\(.*\)" syslog.log | sort | uniq | cut -d " " -f 2-  


input3=$(cat syslog.log)
regex="(ERROR |INFO )(.*) \((.*)\)"
regex2="(ERROR )(.*) \((.*)\)"


grep -oP "$regex" "$input"

get_error_log(){
 local s=$1 regex=$2 
 while [[ $s =~ $regex ]]; do
  printf "${BASH_REMATCH[2]}\n"
  s=${s#*"${BASH_REMATCH[0]}"}
 done
}
IFS=
errorlog=$(
while read -r line
do
 get_error_log "$line" "$regex2"
done < "$input")

sortederrorlog=$(echo $errorlog | sort | uniq -c | sort -nr | tr -s [:space:])
echo $sortederrorlog


get_user_log(){
 local s=$1 regex=$2
 while [[ $s =~ $regex ]]; do
  printf "${BASH_REMATCH[3]}\n"
  s=${s#*"${BASH_REMATCH[0]}"}
 done
}
userlog=$(
while read -r line
do
 get_user_log "$line" "$regex"
done < "$input")

sorteduserlog=$(echo $userlog | sort | uniq | sort)


printf "Error,Count\n" >> "error_message.csv"
echo "$sortederrorlog" | grep -oP "^ *[0-9]+ \K.*" | while read -r line
do
 count=$(grep "$line" "$input" | wc -l)
 printf "$line,$count\n"
 
done >> "error_message.csv"


error=$(grep "ERROR" "$input") 
info=$(grep "INFO" "$input")
printf "Username,INFO,ERROR\n" >> "user_statistic.csv"
echo "$sorteduserlog" | while read -r line
do
 errcount=$(echo "$error" | grep -w "$line" | wc -l)
 infocount=$(echo "$info" | grep -w "$line" | wc -l)
 printf "$line,$infocount,$errcount\n"
done >> "user_statistic.csv"