#!/bin/bash

stop=0
until [ $stop = 7 ]
do
        if [ $# -ne 3 ]; then
                echo "usage: ./2024-OSS-Project1.sh file1 file2 file3"
                break
        fi
        if [ ! -f $1 ] || [ ! -f $2 ] || [ ! -f $3 ]; then
                echo "usage: ./2024-OSS-Project1.sh file1 file2 file3"
                break
        fi
        echo " **********OSS1-Project1**********
*    studentID : 12202346        *
*    Name: Yunji Kim             *
**********************************

[MENU]
1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in players.csv
2. Get the team data to enter a league position in teams.csv
3. Get the Top-3 Attendance matches in matches.csv
4. Get the team's league position and team's top soccer in teams.csv & players.csv
5. Get the modified format of date_GMT in matches.csv
6. Get the data of the winning team by the largest differnece on home stadium in teams.csv & matches.csv
7. Exit" 
        read -p "Enter your CHOICE(1~7):" choice
        case "$choice" in
        1)
                read -p "Do you want to get the Heung-Min Son's data?(y/n):" answer
                if [ $answer="y" ]; then
                        cat $2 | awk -F',' '$1=="Heung-Min Son"{print "Team:"$4 ",Apperance:"$6 ",Goal:" $7 ",Assist:" $8}'
                else
                        continue
                fi;;
        2)
                read -p "What do you want to get the team data of league_position[1~20]:" number
                cat $1 | awk -F',' -v num=$number '$6==num{print $6, $1, $2/($2+$3+$4)}';;

        3)      read -p "Do you want to know Top-3 attendance data? (y/n:)" answer
                if [ $answer="y" ]; then
                                                                                                echo "***Top-3 Attendance Match***"
                        cat $3 | tail -n+2 | sort -r -t',' -k 2 -n | awk -F',' 'NR<=3 {print $3 " vs " $4 " (" $1 ")"; print $2 " " $7}'
                else
                        continue
                fi;;
        4)
                read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n):" answer
                if [ $answer="y" ]; then
                        team_names=$(cat $1 | tail -n+2 | sort -t',' -k 6 -n | awk -F',' '{print $6, $1}')
                        IFS=$'\n' read -r -d ''  -a team_names_array <<< "$team_names"
                        for i in "${team_names_array[@]}"
                        do
                                echo "$i"
                                team_name="${i#* }"
                                cat $2 | tail -n+2 | sort -r -t',' -k 7,7 -n | awk -F',' -v team="$team_name" '$4 == team {print $1, $7; exit}'
                        done
                else
                        continue
                fi;;
        5)
                cat $3 | tail -n+2 |  awk -F',' '{print $1}' | sed -E 's/([A-Za-z]+) ([0-9]+) ([0-9]+) - ([0-9]+):([0-9]+)(am|pm)/\3\/\1\/\2 \4:\5\6/g'|sed 's/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/'|head -n 10;;
        6)
                cat $1 | tail -n+2 | awk -F',' '{print NR ")", $1}'
                read -p "Enter your team number:" number
                team_name=$(cat $1 | tail -n+2 | awk -F',' -v num=$number 'NR==num{print $1}')
                score=$(cat $3 | awk -F',' -v team="$team_name" -v max_value=0 '$3==team{
                value = ($5-$6);
                if(value > max_value) max_value = value;
                }
                END{
                print max_value;
		}')
		cat $3 | awk -F',' -v team="$team_name" -v score="$score" '$3==team && ($5-$6)==score {print"";print $1; print $3,$5 " vs " $6, $4}'
                ;;
        7)
                echo "Bye!"
                stop=7
        esac
echo ""
done

                                                                               
