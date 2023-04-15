#!/bin/bash
echo "Given below is the list of task that this Script can perform."
echo "Press 1 to Print Private IP Address | Press 2 to Print Public IP Address | Press 3 to Print MAC Address"
echo "Press 4 to Ping a Host | Press 5 to Check port is open | Press 6 to SSH into remote server | Press 0 to Exit"
ip_addr=$(curl ifconfig.me 2>./error.txt)
exit_status=$?
pvt_ip=$(hostname -i)
status=$?
read -r input
while [ "$input" != "0" ]
do
	if [ "$input" == "1" ]; then

		if [ $status -ne 0 ]; then
			echo "Private IP Address is: $(ipp addr show | grep inet)"
		else
			echo "Your Private IP Address is: $pvt_ip"
		fi
	elif [ "$input" == "2" ]; then
		if [ $exit_status -ne 0 ]; then
			echo -e "\nError while getting public ip address\nYou can see the error log in error.txt file.\n"
			read -rp "To print this error now | Press p: " inp
			if [ "$inp" == "p" ]; then
				echo -e "\nThe error file is:\n$(cat error.txt)"
			fi
			else
				echo "Your Public IP Address is: $ip_addr"
			fi
	elif [ "$input" == "3" ]; then
		echo -e "MAC Address is:\n$(ip link show | grep link)"
	elif [ "$input" == "4" ]; then
		read -rp "Input a Host Name: " host
		read -rp "How many data packets you want to send: " pac
		if ! ping -c "$pac" "$host" &>>ping_log.txt; then
			echo -e "Error while sending the packet\nYou can see the log in ping_log.txt file"
			read -rp "To see the error log now | Press y: " inp
			if [ "$inp" == "y" ]; then
				echo -e "The error file is:\n$(cat ping_log.txt)"
			fi
		else
			echo -e "\nWait while we are sending $pac packets to $host."
			ping -c "$pac" "$host" 1>>ping_log.txt
			echo -e "\nSuccessfully send the $pac to $host"
			echo "Your log is stored in ping_log.txt file"
		fi
	elif [ "$input" == "5" ]; then
		echo -e "Remote Server Name Can be like scame.nmap.org | Port : 80\n"
		read -rp "Input Home Name or IP Address: " ip1
		read -rp "Input Port Number: " ip2
		if ! nc -zvw10 "$ip1" "$ip2" 2>nc_log.txt; then
			echo -e "\nError while testing the $ip2 port\nThe error log file is stored with name nc_log.txt"
			read -rp "To Print the error file now. Press y: " input
			if [ "$input" == "y" ]; then
				echo -e "\nThe error log file for nc command is:\n$(cat nc_log.txt)"
			fi
		else
			nc -zvw10 "$ip1" "$ip2"
		fi
	elif [ "$input" == "6" ]; then
		set -e
		read -rp  "Input the Username:  " username
		read -rp "Input IP Address: " addr
		if ssh -o ConnectTimeout=10 "$username"@"$addr"; then
			echo -e "\nYou are successfully logged in to $username server"
			echo -e "Listing Memory utilization of server:\n$(free -h)"
			echo -e "\nListing disk usage of server:\n$(df -h)"
			echo -e "\nListing all the process running on the server:\n$(ps -aux)"
			echo -e "\nListing system informatio:\n$(cat /etc/os-release)\n$(uname -a)"
		fi
	fi
	echo -e "\nPress 1 to Print Private IP Address | Press 2 to Print Public IP Address | Press 3 to Print MAC Address"
	echo "Press 4 to Ping a Host | Press 5 to Check port is open | TO ssh press 6 | Press 0 to Exit"
	read -r input
done
