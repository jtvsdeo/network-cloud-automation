#!/usr/bin/env python3

import os
import sys, time

def usage():
	print("python3 runClearpod.py []"
		"\nEnter POD between 1-16 or enter 'all' for all devices"
		"\nView errorLogs.txt for any pods that did not clear and donePods.txt to check which cleared"
		"\n To run routers only or switches only, enter 'allRouters' / 'allSwitches' ")



os.system("echo > errorLogs.txt")
os.system("echo > donePods.txt")

try:
	pod = sys.argv[1]
	if pod == "all":
		for i in range(1,9):
			hostend = 190 + i
			host = "10.41.30." + str(hostend)
			for port in range(6001, 6017):
				if port == 6016:
					os.system("python3 clearPod.py " + host + " " +  str(port) + " ")
					
				else:
					os.system("python3 clearPod.py " + host + " " +  str(port) + " " + "&")
					


	elif pod == "allRouters":
		for i in range(1,9):
			hostend = 190 + i
			host = "10.41.30." + str(hostend)
			for port in range(6001, 6005):
				os.system("python3 clearPod.py " + host + " " +  str(port) + " " "&")
			for port in range(6009, 6013):
				if port == 6012:
					os.system("python3 clearPod.py " + host + " " +  str(port) + " ")

				else:
					os.system("python3 clearPod.py " + host + " " +  str(port) + " " "&")
					time.sleep(1)


	elif pod == "allSwitches":
		for i in range(1,9):
			hostend = 190 + i
			host = "10.41.30." + str(hostend)
			
			for port in range(6005, 6009):
				os.system("python3 clearPod.py " + host + " " +  str(port) + " " "&")
			for port in range(6013, 6017):
				if port == 6016:
					os.system("python3 clearPod.py " + host + " " +  str(port) + " ")

				else:
					os.system("python3 clearPod.py " + host + " " +  str(port) + " " "&")
					time.sleep(1)

	else:

		pod = int(pod)
		if pod > 16 or pod < 1:
			raise Exception
		hostend = 190 + (pod//2 + (pod % 2))
		host = "10.41.30." + str(hostend)
		if pod % 2 == 1:
			a = 6001
			b = 6009
		else: 
		    a = 6009
		    b = 6017

		for port in range(a,b):
			os.system("python3 clearPod.py " + host + " " +  str(port) + " " + "&")

			
except: 
	usage()

