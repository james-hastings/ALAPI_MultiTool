#!/bin/bash

#Get user info by email or get account info by CID:

# ALAPI_Multitool.sh - returns customer info by entering an email address, account info by CID, pulls CI usage by CI CID, or allows users to search through security content.
#Usage is outputted to a .csv file, and content is outputted to a .txt file
 
# Parameters: <ci_username> <ci_password> <email> 
# Prerequisite:  This script uses “jq”, JSON Query filter and must be installed/loaded before execution.

# This script curls the CI AIMS API: https://console.cloudinsight.alertlogic.com/api/aims/ you must have CURL installed too.

#Email/Credentials - You must have a CID2 account and API capabilites to the Insight Platform, currently set through the Cloud Insight UI.

#If this does not work for you, verify that your email has the correct permissions.

#Created and maintained by James Hastings - jhastings@alertlogic.com
#Please contact if you experience issues
#this will be the code to test the OS version and install necessary requirements

#this will be the code to test the OS version and install necessary requirements

###
###OS X Helper
printf '\e[8;44;71t'
clear


#sweet banner
echo -e "\n\n\n\n\n\n\n"
echo -e "======================================================================="
echo -e "======================================================================="
echo -e "                         _                 _____ _____ "
echo -e "                   /\   | |          /\   |  __ \_   _|"
echo -e "                  /  \  | |         /  \  | |__) || |  "
echo -e "                 / /\ \ | |        / /\ \ |  ___/ | |  "
echo -e "                / ____ \| |____   / ____ \| |    _| |_ "
echo -e "               /_/  __\_\______| /_/ _  \_\_|   |_____|"
echo -e "               |  \/  |     | | | (_) |            | | "
echo -e "               | \  / |_   _| | |_ _| |_ ___   ___ | | "
echo -e "               | |\/| | | | | | __| | __/ _ \ / _ \| | "
echo -e "               | |  | | |_| | | |_| | || (_) | (_) | | "
echo -e "               |_|  |_|\__,_|_|\__|_|\__\___/ \___/|_| "
echo -e "\n"
echo -e "======================================================================="
echo -e "======================================================================="
echo -e "\n\n\n\n"
echo -e "                        James Hastings 2018"

#slight pause for dramatic effect
sleep 1


#Specify or get username
#ci_username=""
read -p "Enter CID2 Email Address: " ci_username


#Capture password
read -s -p "Enter Password: " ci_password
#ci_password=""



#Display user banner / successful login

		#Specify api endpoint
		endpoint='https://api.cloudinsight.alertlogic.com'
		
		#Get token
		json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
		token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

		#Get user info based on email login
		json2="`curl -s -X GET $endpoint/aims/v1/user/email/$jhastings@ -H "x-aims-auth-token: $token"`"

		#Parse user f/l name, strip " " off, and specify test value
		user_name=`echo $json2 | jq .name`
		current_user=`echo $user_name | tr -d '"'`
		usercheck=""


#User credential validation
#	if [ "$current_user" == "$usercheck" ]
#		then
#		clear
#			echo -e "\n\n      Your credentials were not accepted!"
#			echo -e "\n     You have either entered your password"
#			echo -e "      incorrectly, or your email does not"
#			echo -e "        have the necessary permissions.\n\n"
#		exit

#	else
#		clear
#		echo -e "\n\nWelcome to the AL API MultiTool, $current_user!"
#		echo -e "\n"
#		say "Hi ${current_user%% *}"
#	fi













#Specify endpoint - US or UK
clear
endpointcheck=0
while [ $endpointcheck -lt 1 ]; do
		echo -e " Which endpoint do you need:\n"
		echo "  1) US"
		echo -e "  2) UK"
		echo -e "\n  3) Exit\n"
read -p "  " usuk



#US endpoint
	if [ $usuk -eq 1 ]
		then
		endpoint='https://api.cloudinsight.alertlogic.com'
		clear
		echo -e "\n\n  US API Endpoint Selected"
		let endpointcheck=endpointcheck+1

#UK endpoint	
	elif [ $usuk -eq 2 ]
		then
		endpoint='https://api.cloudinsight.alertlogic.co.uk'
		clear
		echo -e "\n\n  UK API Endpoint Selected"
		let endpointcheck=endpointcheck+1

#Exit	
	elif [ $usuk -eq 3 ]
		then
		let endpointcheck=endpointcheck+1
		clear
        exit		

#So long and thanks for all the fish
	elif [ $usuk -eq 42 ]
		then
		clear
		echo -e "\n\nWe're not looking for the answer to the Ultimate Question\n of Life, the Universe, and Everything, but thanks!\n"
		
#error handling
	else
		clear
		echo -e "\n\n **************************************"
		echo -e " *** Please make a valid selection! ***"
		echo -e " **************************************\n\n"
		
	fi
done













#While statement keeps looping unless 5/exit option is selected
functioncheck=0
while [ $functioncheck -lt 1 ]; do

		echo -e "\n"
		echo -e " What do you want to do:\n"
		echo -e "  1) Get User by Email"
		echo -e "  2) Get Account by CID"
		echo -e "  3) Get Account by Name"
		echo -e "  4) Pull Cloud Insight Usage"
		echo -e "  5) Search for Security Exposures"
		echo -e "  6) List CI Config Checks\n"

		echo -e "  99) Delete a User"
		echo -e "  100) Delete a Deployment"
		echo -e "  111) CWE Collector Accounts"
		echo -e "  112) IRIS Incident Search\n"
		
		echo -e "  7) Exit\n\n"


#capture user choise
read -p "  " emailCID








#Get user account info by email
if [ $emailCID -eq 1 ]

	then 
		clear
		echo -e "\n\n"
			echo -e "  Search for Users by Email"
			echo -e "\n"
		read -p " Enter desired email: " email

# Authenticate to get security token
		json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
		token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

#Get user info - or get account info by CID
		json2="`curl -s -X GET $endpoint/aims/v1/user/email/$email -H "x-aims-auth-token: $token"`"

#Assign JSON to variable
		userid=`echo $json2 | jq .id`
		usercid=`echo $json2 | jq .account_id`
		cid4actname=`echo $usercid | tr -d '"'`
		user_name=`echo $json2 | jq .name`
		useremail=`echo $json2 | jq .email`
		user_linkedusers=`echo $json2 | jq .linked_users`
		emailsearchcheck=""

#Check if email is present in system
		if [ "$user_name" == "$emailsearchcheck" ]
			then
			clear
				echo -e "\n\n  $email - Not Found In System"

		else

#Get account name using seperate call
		json5="`curl -s -X GET $endpoint/aims/v1/$cid4actname/account -H "x-aims-auth-token: $token"`"
		account_name=`echo $json5 | jq .name`
		
#Output desired info and parse with J-Query
		clear
			echo -e "\n\n ***************************************************"
			echo -e " ******************** User Info ********************"
			echo -e " ***************************************************"
			echo -e "\n User ID: $userid" 
			echo -e " Account: $account_name"
			echo -e " CID: $usercid" 
			echo -e " Name: $user_name" 
			echo -e " Email: $useremail\n" 
			echo -e " Linked Users: $user_linkedusers" 
			echo -e "\n ***************************************************"
			echo -e " ***************************************************\n"

			echo -e "\n\n"
			echo -e "  Do you want the associated account information?\n"
			echo -e "  1) Yes"
			echo -e "  2) No\n\n"
			read -p "" getaccountinfo

			if [ $getaccountinfo -eq 1 ]
				then
				clear
					#Get user info - or get account info by CID
					json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
					token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`
					json2="`curl -s -X GET $endpoint/aims/v1/$cid4actname/account -H "x-aims-auth-token: $token"`"

					maybeUKcheck=""

					if [ "$json2" == "$maybeUKcheck" ]
						then
						json2="`curl -s -X GET https://api.cloudinsight.alertlogic.co.uk/aims/v1/$cid4actname/account -H "x-aims-auth-token: $token"`"

					else
						maybeUKcheck="true"
					fi


					#Output desired info and parse with J-Query
					echo -e "\n\n****************************************************"
					echo -e "******************* Account Info *******************"
					echo -e "****************************************************"
					echo $json2 | jq .
					echo -e "\n****************************************************"
					echo -e "****************************************************\n"

					echo -e "\n\n"
			echo -e "  What do you want to do?\n"
			echo -e "  1) Get Usage"
			echo -e "  2) Get Entitlement\n"
			echo -e "  3) Exit\n"
			read -p "" getentitlement

			if [ $getentitlement -eq 2 ]
				then
				clear

					# Call to grab entitlement
json3="`curl -H "x-aims-auth-token: ${token}" -s -X GET https://api.cloudinsight.alertlogic.com/ekko/v1/entitlements/by-cid/$cid4actname`"

# Print to screen
clear
	#Output desired info and parse with J-Query
					echo -e "\n\n****************************************************"
					echo -e "***************** Entitlement Info *****************"
					echo -e "****************************************************"
					echo $json3 | jq .
					echo -e "\n****************************************************"
					echo -e "****************************************************\n"


				elif [ $getentitlement -eq 1 ]
					then
					clear
					# Call to grab entitlement
json3="`curl -H "x-aims-auth-token: ${token}" -s -X GET https://api.cloudinsight.alertlogic.com/ekko/v1/usage/monthly/by-cid/$cid4actname`"
#Output desired info and parse with J-Query
					echo -e "\n\n****************************************************"
					echo -e "****************** Account Usage *******************"
					echo -e "****************************************************"
					echo $json3 | jq .
					echo -e "\n****************************************************"
					echo -e "****************************************************\n"
					
				else
					clear
				fi
				else
					clear
				fi
	fi










#Pull account info by CID

elif [ $emailCID -eq 2 ]
	then
		clear
			echo -e "\n\n  Search for Account by CID"
			echo -e "\n"
		read -p " Enter Desired CID: " CID



# Authenticate to get security token
		json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
		token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

#Get user info - or get account info by CID
		json2="`curl -s -X GET $endpoint//aims/v1/$CID/account -H "x-aims-auth-token: $token"`"

		account_name=`echo $json2 | jq .name`
	
#See if account exists
	if [ "$account_name" == "$usercheck" ]
	
#if it doesn't
	then
		clear
		echo -e "\n\n  Invalid CID - Account Not Found!"

#If account exists
	else

		#Output desired info and parse with J-Query
		echo -e "\n\n****************************************************"
		echo -e "******************* Account Info *******************"
		echo -e "****************************************************"
		echo $json2 | jq .
		echo -e "\n****************************************************"
		echo -e "****************************************************\n"

		echo -e "\n\n"
			echo -e "  What do you want to do?\n"
			echo -e "  1) Get Usage"
			echo -e "  2) Get Entitlement\n"
			echo -e "  3) Exit\n"
			read -p "" getentitlement

			if [ $getentitlement -eq 2 ]
				then
				clear

					# Call to grab entitlement
json3="`curl -H "x-aims-auth-token: ${token}" -s -X GET https://api.cloudinsight.alertlogic.com/ekko/v1/entitlements/by-cid/$CID`"

# Print to screen
clear
	#Output desired info and parse with J-Query
					echo -e "\n\n****************************************************"
					echo -e "***************** Entitlement Info *****************"
					echo -e "****************************************************"
					echo $json3 | jq .
					echo -e "\n****************************************************"
					echo -e "****************************************************\n"


				elif [ $getentitlement -eq 1 ]
					then
					clear
					# Call to grab entitlement
json3="`curl -H "x-aims-auth-token: ${token}" -s -X GET https://api.cloudinsight.alertlogic.com/ekko/v1/usage/monthly/by-cid/$CID`"
#Output desired info and parse with J-Query
					echo -e "\n\n****************************************************"
					echo -e "****************** Account Usage *******************"
					echo -e "****************************************************"
					echo $json3 | jq .
					echo -e "\n****************************************************"
					echo -e "****************************************************\n"
					
				else
					clear
				fi
	fi











#Pull CI Usage by CI CID

elif [ $emailCID -eq 4 ]
	then
	usage_check=0
	while [ $usage_check -lt 1 ]; do
		clear
			echo -e "\n  Cloud Insight Usage Tool"
			echo -e "\n"
			echo -e "  Do you want to search by CID or use a know account?\n"
			echo -e "  1) CID"
			echo -e "  2) Known Account\n"
			echo -e "  3) Exit\n\n"
			read -p "" usage_choice

			if [ $usage_choice -eq 1 ]
				then		
					read -p " Enter CI CID: " i 

			# Authenticate to get security token
 
 			json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
			token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

			#Get Account Name to Append to File
			json3="`curl -s -X GET https://api.cloudinsight.alertlogic.com/aims/v1/$i/account -H "x-aims-auth-token: $token" -k`"
 			account_name=`echo $json3 | jq .name`
	
			#See if account exists
				if [ "$account_name" == "$usercheck" ]
	
				#if it doesn't
					then
					clear
					echo -e "\n\n  Cloud Insight Account Not Found!"

#If account exists
				else
					clear
					echo -e "\n\n Account: $account_name\n"
#Get usage and create output file
					read -p " Enter desired month (XX): " month
					read -p " Enter desired year (XXXX): " year
					echo -e "\n"
					clear

			#Get usage nd output success banner

				echo -e "\n\n  Processing usage for $account_name"
				(
				echo "Usage for ${month}/${year}"
				echo "Account Name","CID","Instance Days"
 				json="`curl -s -X GET $endpoint/usage/v2/$i/summary/$year/$month -H "x-aims-auth-token: $token" -k`"
 				host_days=`echo $json | jq .host_days`
 				json2="`curl -s -X GET https://api.cloudinsight.alertlogic.com/aims/v1/$i/account -H "x-aims-auth-token: $token" -k`"
 				name=`echo $json2 | jq .name`
 				echo $name,$i,$host_days
				) >${i}_CI_Usage_${month}_${year}.csv
		
				echo -e "\n\n********************************************************************"
				echo -e "********************************************************************\n"
				echo -e "Successfully outputted usage for "$month"/"$year" to .csv!"
				echo -e " - $PWD\n"
				echo "********************************************************************"
				echo -e "********************************************************************\n"

				fi

elif [ $usage_choice -eq 2 ]
	then
		customer_check=0
		while [ $customer_check -lt 1 ]; do
		clear
		echo -e "\n\n  Which Account?\n"
		echo -e "  1) Epsilon"
		echo -e "  2) CareerBuilder"
		echo -e "  3) Turner"
		echo -e "  4) Meredith"
		echo -e "  5) Sony"
		echo -e "\n  6) Exit\n\n"
		read -p "" customer_choice

	


			if [ $customer_choice -eq 1 ]
				then
				clear
				echo -e "\n\n"
				echo -e "Epsilon\n"
				read -p "Enter desired month (XX): " month

				read -p "Enter desired year (XXXX): " year


				cid=( `cat /Users/jameshastings/Dropbox/Tools/epsilon_accounts.txt `)
				endpoint='https://api.cloudinsight.alertlogic.com'

# Authenticate to get security token
 
				json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
				token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

#Get usage and create output file
				echo Processing……
				(
				echo "Usage for ${month}/${year}"
				echo "Account Name","CID","Instance Days"
				total_usage=0
				for i in ${cid[@]}
				do
 					json="`curl -s -X GET $endpoint/usage/v2/$i/summary/$year/$month -H "x-aims-auth-token: $token" -k`"
 					host_days=`echo $json | jq .host_days`
 					json2="`curl -s -X GET $endpoint/aims/v1/$i/account -H "x-aims-auth-token: $token" -k`"
 					name=`echo $json2 | jq .name`
 					#support_status=`echo $json2 | jq .active`
 					echo $name,$i,$host_days
 					let total_usage=$(($total_usage+$host_days))
				done
				echo " "
 				echo "Total Monthly Usage:","${total_usage}") >Epsilon_Usage_${month}_${year}.csv
				echo Usage "for" $month"/"$year exported to .csv file successfully.
				echo Done




			elif [ $customer_choice -eq 2 ]
				then
				clear
				echo -e "\n\n"
				echo -e "CareerBuilder\n"
				read -p "Enter desired month (XX): " month

				read -p "Enter desired year (XXXX): " year

				cid=( `cat /Users/jameshastings/Dropbox/Tools/careerbuilder_accounts.txt `)

				endpoint='https://api.cloudinsight.alertlogic.com'

# Authenticate to get security token
 
				json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
				token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

#Get usage and create output file
				echo Processing……
				(
				echo "Usage for ${month}/${year}"
				echo "Account Name","CID","Instance Days"
				total_usage=0
					for i in ${cid[@]}
					do
 						json="`curl -s -X GET $endpoint/usage/v2/$i/summary/$year/$month -H "x-aims-auth-token: $token" -k`"
 						host_days=`echo $json | jq .host_days`
 						json2="`curl -s -X GET $endpoint/aims/v1/$i/account -H "x-aims-auth-token: $token" -k`"
 						name=`echo $json2 | jq .name`
 						echo $name,$i,$host_days
 						let total_usage=$(($total_usage+$host_days))
					done 
					echo " "
 					echo "Total Monthly Usage:","${total_usage}") >CareerBuilder_Usage_${month}_${year}.csv
				echo Usage "for" $month"/"$year exported to .csv file successfully.
				echo Done


			elif [ $customer_choice -eq 3 ]
				then
				clear
				echo -e "\n\n"
				echo -e "Turner\n"
				read -p "Enter desired month (XX): " month

				read -p "Enter desired year (XXXX): " year


				cid=( `cat /Users/jameshastings/Dropbox/Tools/turner_accounts.txt `)
				endpoint='https://api.cloudinsight.alertlogic.com'

# Authenticate to get security token
 
				json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
				token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

#Get usage and create output file
				echo Processing……
				(
				echo "Usage for ${month}/${year}"
				echo "Account Name","CID","Instance Days"
				total_usage=0
					for i in ${cid[@]}
					do
 						json="`curl -s -X GET $endpoint/usage/v2/$i/summary/$year/$month -H "x-aims-auth-token: $token" -k`"
 						host_days=`echo $json | jq .host_days`
 						json2="`curl -s -X GET $endpoint/aims/v1/$i/account -H "x-aims-auth-token: $token" -k`"
 						name=`echo $json2 | jq .name`
 						echo $name,$i,$host_days
 						let total_usage=$(($total_usage+$host_days))
					done
					echo " "
 					echo "Total Monthly Usage:","${total_usage}") >Turner_Usage_${month}_${year}.csv
						echo Usage "for" $month"/"$year exported to .csv file successfully.
						echo Done


elif [ $customer_choice -eq 4 ]
				then
				clear
				echo -e "\n\n"
				echo -e "Meredith\n"
				read -p "Enter desired month (XX): " month

				read -p "Enter desired year (XXXX): " year


				cid=( `cat /Users/jameshastings/Dropbox/Tools/meredith_accounts.txt `)
				endpoint='https://api.cloudinsight.alertlogic.com'

# Authenticate to get security token
 
				json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
				token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

#Get usage and create output file
				echo Processing……
				(
				echo "Usage for ${month}/${year}"
				echo "Account Name","CID","Instance Days"
				total_usage=0
				for i in ${cid[@]}
				do
 					json="`curl -s -X GET $endpoint/usage/v2/$i/summary/$year/$month -H "x-aims-auth-token: $token" -k`"
 					host_days=`echo $json | jq .host_days`
 					json2="`curl -s -X GET $endpoint/aims/v1/$i/account -H "x-aims-auth-token: $token" -k`"
 					name=`echo $json2 | jq .name`
 					#support_status=`echo $json2 | jq .active`
 					echo $name,$i,$host_days
 					let total_usage=$(($total_usage+$host_days))
				done
				echo " "
 				echo "Total Monthly Usage:","${total_usage}") >Meredith_Usage_${month}_${year}.csv
				echo Usage "for" $month"/"$year exported to .csv file successfully.
				echo Done

			




			elif [ $customer_choice -eq 5 ]
				then
				clear
				echo -e "\n\n"
				echo -e "Sony\n"
				read -p "Enter desired month (XX): " month

				read -p "Enter desired year (XXXX): " year


				cid=( `cat /Users/jameshastings/Dropbox/Tools/sony_accounts.txt `)
				endpoint='https://api.cloudinsight.alertlogic.com'

# Authenticate to get security token
 
				json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
				token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

#Get usage and create output file
				echo Processing……
				(
				echo "Usage for ${month}/${year}"
				echo "Account Name","CID","Instance Days"
				total_usage=0
					for i in ${cid[@]}
					do
 						json="`curl -s -X GET $endpoint/usage/v2/$i/summary/$year/$month -H "x-aims-auth-token: $token" -k`"
 						host_days=`echo $json | jq .host_days`
 						json2="`curl -s -X GET $endpoint/aims/v1/$i/account -H "x-aims-auth-token: $token" -k`"
 						name=`echo $json2 | jq .name`
 						echo $name,$i,$host_days
 						let total_usage=$(($total_usage+$host_days))
					done
					echo " "
 					echo "Total Monthly Usage:","${total_usage}") >Sony_Usage_${month}_${year}.csv
						echo Usage "for" $month"/"$year exported to .csv file successfully.
						echo Done

			elif [ $customer_choice -eq 6 ]
				then
				let customer_check=customer_check+1
				clear
				echo -e ""
				exit

			else 
			clear
			echo -e "\n\n Make a Valid Selection!"

			fi
		done 


elif [ $usage_choice -eq 3]
	then
	let usage_check=usage_check+1
	clear
	exit 

else 
	echo -e "\n\n  Please Make a Valid Choice!"
fi

done











#Content search
elif [ $emailCID -eq 5 ]
	then 
		clear
		echo -e "\n"                                                   

		echo -e "\n    This tool allows you to search for security exposures"
		echo -e "    that are used in Alert Logic Scanning Solutions."
		echo -e "\n\n"
		read -p "What are you looking for: " content

# Authenticate to get security token
		json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
		token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

#Get user info - or get account info by CID
		json2="`curl -s -X POST -H "x-aims-auth-token: ${token}" \
  --data-urlencode "q={$content}" \
  https://api.cloudinsight.alertlogic.com/aether/exposures/2013-01-01/search`"
		
		echo -e "\n\n"
		echo -e "Processing...\n"
		echo -e $json2 | jq .

		echo -e "\n\nWould you like to output to a .txt file?"
		echo -e " 1) Yes"
		echo -e " 2) No"
		read -p "  " choice
		echo "\n"
	
		if [ $choice -eq 1 ]
			then
			clear
#Output desired info and parse with J-Query to txt file
		content_name=`echo ${content// /_}`
		(echo -e $json2 | jq . ) > $content_name.txt

		echo -e "\n\n********************************************************************"
		echo -e "********************************************************************\n"
		echo -e "Successfully outputted to ${content_name}.txt"
		echo -e "- $PWD\n"
		echo "********************************************************************"
		echo -e "********************************************************************\n"
		
		else
			clear
			echo -e "\nThank you, come again."
		fi









#CI Config Check Dump
elif [ $emailCID -eq 6 ]
	then 
json3="`curl -H "x-aims-auth-token: ${token}" -s -X GET https://api.cloudinsight.alertlogic.com/inquisitor/v1/rules`"


echo $json3 | jq .

echo -e "\n\nWould you like to output to a .txt file?"
		echo -e " 1) Yes"
		echo -e " 2) No"
		read -p "  " choice
		echo "\n"
	
		if [ $choice -eq 1 ]
			then
			clear
#Output desired info and parse with J-Query to txt file
		
		(echo $json3 | jq -r . ) > CI_Config_Checks.txt

		echo -e "\n\n********************************************************************"
		echo -e "********************************************************************\n"
		echo -e "Successfully outputted to CI_Config_Checks.txt"
		echo -e "- $PWD\n"
		echo "********************************************************************"
		echo -e "********************************************************************\n"
		
		else
			clear
			echo -e "\nThanks for using my tool - James\n\n"
		fi


#Get account by name
elif [ $emailCID -eq 3 ]
	then 
		clear
		echo -e "\n"                                                   

		echo -e "\n    This let's you search for account by name - this should let you return a list of accounts too"
		echo -e "\n\n"
		read -p "Enter the search term: " search_name

# Authenticate to get security token
		json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
		token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`

#Get user info - or get account info by CID
		json2="`curl -s -X GET $endpoint/aims/v1/accounts/name/$search_name -H "x-aims-auth-token: $token"`"
		
		echo -e "\n\n"
		echo -e $json2 | jq .








#exit statement
elif [ $emailCID -eq 7 ]
		then
		let functioncheck=functioncheck+1
		clear



elif [ $emailCID -eq 99 ]
		then
		clear
		echo "Delete a user:"

		read -p "Enter the CID: " user_account_id
clear
		read -p "Enter the user_id: " user_id

		clear

		
		echo -e "\n"
		json2="`curl -s -X GET $endpoint/aims/v1/user/$user_id -H "x-aims-auth-token: $token"`"
		echo -e $json2 | jq .
echo -e "\n\nAre you really sure you want to delete the user above?"
		echo -e "\n__________"
		echo -e "Proceed"
		echo -e "Cancel\n"

		read -p "Fully type one of the options below to continue: " delete_choice

		if [ "$delete_choice" == "Proceed" ]
			then
			clear
			token=$(curl -s  -X POST  -u '11564950d4ea1e83:f1f655ae13144048858d2f9380f228ed75418ca2564654339148cc8b93079ea6' https://api.cloudinsight.alertlogic.com/aims/v1/authenticate | jq -r .authentication.token)
			curl -X DELETE https://api.cloudinsight.alertlogic.com/aims/v1/$user_account_id/users/$user_id -H "x-aims-auth-token: $token"
			echo -e "User Deleted"
			sleep 2

		else
			echo "Canceled!"
			sleep 2
		fi

		clear

	
elif [ $emailCID -eq 100 ]
		then
		clear
		echo "Delete a Deployment:"

		read -p "Enter the CID: " user_account_id
clear
		read -p "Enter the Deployment/Environment ID: " env_id

		clear

		
		echo -e "\n"


		json2="`curl -s -X GET https://api.cloudinsight.alertlogic.com/environments/v1/$user_account_id/$env_id -H "x-aims-auth-token: $token"`"
		echo -e $json2 | jq .
echo -e "\n\nAre you really sure you want to delete the deployment above?"
		echo -e "\n__________"
		echo -e "Proceed"
		echo -e "Cancel\n"

		read -p "Fully type one of the options below to continue: " delete_choice

		if [ "$delete_choice" == "Proceed" ]
			then
			clear
			token=$(curl -s  -X POST  -u '11564950d4ea1e83:f1f655ae13144048858d2f9380f228ed75418ca2564654339148cc8b93079ea6' https://api.cloudinsight.alertlogic.com/aims/v1/authenticate | jq -r .authentication.token)
			curl -X DELETE https://api.cloudinsight.alertlogic.com/environments/v1/$user_account_id/$env_id -H "x-aims-auth-token: $token"
			echo -e "User Deleted"
			sleep 2

		else
			echo "Canceled!"
			sleep 2
		fi

		clear



#You're going to need a towel
elif [ $emailCID -eq 42 ]
		then
		clear
			echo -e "\n\nWe're not looking for the answer to the Ultimate Question\n of Life, the Universe, and Everything, but thanks!\n"
		#curl -H "X-AIMS-Auth-Token: $token" "https://api.cloudinsight.alertlogic.com/remediations/v1/41525/deployments/E7687A2E-1C3A-4B29-954A-2BC6CA4B43AC/assessment-specs"	


elif [ "$emailCID" == "111" ]
	then
	#Get token
json="[`curl -s -X POST $endpoint/aims/v1/authenticate -u $ci_username:$ci_password`]"
token=`echo $json | jq '.[] | (.authentication.token | tostring)' | tr -d '\"'`
clear

echo -e "\n\n Looking for CWE collectors in AIMS..."

    (


    ACC_IDS=$( \
        curl -sH "x-aims-auth-token:$token" $endpoint"/environments/v1/accounts" \
           | jq '.accounts[].account_id' \
           | sed 's/"//g' \
    )
    TOTAL_ACC=$( echo ${ACC_IDS} | wc -w )

        echo "AIMS accounts with CWE Collectors"
        echo "Account Name", "CID"

        for acc_id in ${ACC_IDS}; do
        #echo ${acc_id}:
        Deployment_ID=`curl -s -H "x-aims-auth-token:$token" $endpoint"/sources/v1/$acc_id/sources?source.config.collection_type=cwe" | jq '.sources[].source.id'`
        blank=""
        if [ "$Deployment_ID" == "$blank" ]
        then
            endpoint='https://api.cloudinsight.alertlogic.com'
        else
            json3="`curl -s -X GET https://api.cloudinsight.alertlogic.com/aims/v1/$acc_id/account -H "x-aims-auth-token: $token" -k`"
            account_name=`echo $json3 | jq .name`
            echo $account_name,$acc_id

        fi
    done) >Accounts_with_CWE_collectors.csv

    clear

    echo -e "\n\n Accounts with CWE collectors sucessfully exported to .CSV"
    echo -e "\n - $PWD\n\n\n"


#IRIS Incident Search by CID
elif [ $emailCID -eq 112 ]
		then
		clear
			echo -e "\nIRIS Incident Search by CID\n"
			read -p "Enter the desired CID: " iris_cid
			clear
			#call to get the account name
			json5="`curl -s -X GET $endpoint//aims/v1/$iris_cid/account -H "x-aims-auth-token: $token"`"
		account_name=`echo $json5 | jq .name`

		#call to pull back incidents associated with CID
		json3="`curl -s -X POST https://api.cloudinsight.alertlogic.com/iris/v2/$iris_cid/incident/search -H "x-aims-auth-token: $token"`"

		#display account name
		echo -e "\n\nIncidents for $account_name\n\n"
		echo $json3 # | jq .

			


elif [ "$emailCID" == "rickroll" ]
	then
	printf '\e[8;30;80t'
	curl -s -L http://bit.ly/10hA8iC | bash


elif [ "$emailCID" == "starwars" ]
	then
	telnet towel.blinkenlights.nl


#So you picked something random, but not 41
	else
		clear
			echo -e "\n\n**************************************"
			echo -e "*** Please make a valid selection! ***"
			echo -e "**************************************\n"
		
	fi

done





