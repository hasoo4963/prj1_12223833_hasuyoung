#!/bin/bash

echo "-----------------------------"

echo "User Name: HaSuyoung"
echo "Student Number: 12223833"


echo [ MENU ]
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"

echo "------------------------------"

read -p "Enter your choice [ 1-9 ] " userInput

while [ $userInput -ne 9 ]
do
	
	case $userInput in
		1)
			echo
			read -p "Please enter 'movie id'(1~1682):" movie_id
			echo
			cat $1 | awk -F\| -v movie_id="$movie_id" '$1 == movie_id { print }'
			echo
			;;
		2)
			echo
			read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" indicator
			echo
			if [ ${indicator} == "y" ]; then
				cat $1 | awk -F\| '$7 == 1{ print $1, $2}' | head -n 10
				echo
			fi
			;;
		3) 
			echo
			read -p "Please enter the 'movie id'(1~1682):" movie_id
			echo
			cat $2 | awk -v movie_id="$movie_id" '$2 == movie_id { sum += $3 
										count++ } 
				END { if(count > 0)
						average = sum / count
						printf("average rating of %d: %.5f\n", movie_id,
							average)}'
			echo
			;;
		4)
			echo
			read -p "Do you want to delete the 'IMDb URL'from 'u.item'?(y/n):" indicator
			echo
			if [ ${indicator} == "y" ]; then
				cat $1 | sed 's/http*:\/\/[^|]*//g' | head -n 10
				echo
			fi
			;;
		5)
			echo
			read -p "Do you want to get the data about users from 'u.user'?(y/n):" indicator
			echo
			if [ ${indicator} == "y" ]; then
				cat $3 | sed -E 's/M/male/;s/F/female/' | sed 's/\(.*\)|\(.*\)|\(.*\)|\(.*\)|\(.*\)/user \1 is \2 years old \3 \4/' | head -n 10
				echo
			fi
			;;
		6)
			echo
			read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):" indicator
			echo
			if [ ${indicator} == "y" ]; then
				cat $1 | sed -E 's/Jan/01/' | sed -E 's/Feb/02/' | sed -E 's/Mar/03/' | sed -E 's/Apr/04/' | sed -E 's/May/05/' | sed -E 's/Jun/06/' | sed -E 's/Jul/07/' | sed -E 's/Aug/08/' | sed -E 's/Sep/09/' | sed -E 's/Oct/10/' | sed -E 's/Nov/11/' | sed -E 's/Dec/12/' | sed 's/\([0-9]\{2\}\)-\([0-9]\{2\}\)-\([0-9]\{4\}\)/\3\2\1/' | tail -n 10
				echo
			fi
			;;
		7)
			echo
			read -p "Please enter the 'user id'(1~943):" userId
			echo
			cat $2 | awk -v userId="$userId" '$1 == userId { print $2; }' | sort -n | tr '\n' '|' | sed 's/|$/\n/'
			echo

			cat $2 | awk -v userId="$userId" '$1 == userId { print $2; }' | sort -n > temp.sorted

			for var in $( seq 1 10 )
			do
				read -r movie_id
				cat $1 | awk -v movie_id="$movie_id" -F '|' '$1 == movie_id { printf("%d|%s\n",$1,$2) }' | head -n 1
			done < temp.sorted

			rm "temp.sorted"

			echo
			;;
		8)
			echo
			read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" indicator
			echo
			if [ ${indicator} == "y" ]; then
				cat $3 | awk -F '|' '$2 >= 20 && $2 <= 29 && $4 == "programmer"{print $1}' > userid.temp

				while IFS=$'\t' read -r user_id; do
					cat $2 | awk -v user_id="$user_id" '$1 == user_id { print $2, $3; }' >> movie_and_rating.info
				done < userid.temp
				cat movie_and_rating.info | sort -n > movie_and_rating_sorted.info
				

				for var in $(seq 1 1684); do
    					cat movie_and_rating_sorted.info | awk -v var="$var" 'var==$1{ sum += $2
													count++ }
					END { if(count > 0){
							average = sum / count
							printf("%d %.5f\n", var, average)}
						}'
				done

				echo
				
				rm "movie_and_rating.info"
				rm "userid.temp"
				rm "movie_and_rating_sorted.info"

			fi 
			;;
		*)
			;;
	esac

	read -p "Enter your choice [ 1-9 ] " userInput

done

echo "Bye!"