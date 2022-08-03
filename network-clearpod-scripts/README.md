
CODE EXPLAINED:
	This script connects to Cisco Switches/Routers and erases vlan configs, running-configs and reloads them.

BACKGROUND INFO:
	This code is made to run in a lab of 16 pods. 
	A console manager is connected to 2 pods which have 4 routers and 4 switches each. 
	Total of 16 devices per pod and 16 pods total.
	Switches run for ports 5-8 and 13-16. Routers run through ports 1-4 and 9-12

EACH FILE EXPLAINED:
	The runClearpod.py script uses clearPod.py script and takes command line args
	The clearPod.py script is the script being executed 
	The donePods.txt saves all pods that are completely cleared. It is reset everytime runClearpod.py is executed 
	The errorLogs.txt saves all pods that fail to be cleared. It is reset everytime runClearpod.py is executed

HOW TO EXECUTE: 
	python3 runClearpod.py <arg> 
	Argument can be 'all', pod number, or allSwitches/allRouters

