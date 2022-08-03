
#!/usr/bin/env python3

import netmiko
import time
import sys
import os
from netmiko import ConnectHandler
import traceback
passwords = [ 'cisco', 'class', 'ciscoenpa55', 'cisco']

def checkPrompt(connect):
    #checks for the prompt
    connect.write_channel("\r\n")
    time.sleep(1)
    connect.write_channel("\r\n")
    time.sleep(1)
    output = connect.read_channel()
    return output

ip = sys.argv[1]
portNum = sys.argv[2]
try:
    def finalProgram(connect):  
        #sends in commands
            if "no" in checkPrompt(connect):
                output = connect.send_command_timing("no")
                output += connect.send_command_timing("\n")
                output += connect.send_command_timing("\n")

            if "#" not in checkPrompt(connect):

                cmd0 = "enable"
                output = connect.send_command_timing(cmd0)
                if 'Password' in output:
                    for elem in passwords:
                        output += connect.send_command_timing(elem)
                        output += connect.send_command_timing("\n")
                        output += connect.send_command_timing("\n")
                        output += connect.send_command_timing("\n")
                        connect.send_command_timing(cmd0)

                        if "#" in checkPrompt(connect):
                            break

            elif "config" in checkPrompt(connect):
                connect.send_command_timing("end")
                        

            cmd1 = "delete vlan.dat"
            output = connect.send_command_timing(cmd1)

            if 'Delete' in output:
                output += connect.send_command_timing("\n")
                output += connect.send_command_timing("\n")

            cmd2 = "erase startup-config"
            output = connect.send_command_timing(cmd2)

            if 'Erasing' in output:
                output += connect.send_command_timing("\n")
                output += connect.send_command_timing("\n")
                time.sleep(5)
                
            cmd3 = "reload"
            output = connect.send_command_timing(cmd3)  

            if 'modified' in output:
                output += connect.send_command_timing("no")
                output += connect.send_command_timing("\n")
                output += connect.send_command_timing("\n")
                output += connect.send_command_timing("\n")
            if 'reload' in output:
                output += connect.send_command_timing("\n")
                output += connect.send_command_timing("\n")
                output += connect.send_command_timing("\n")

                device = int(portNum) - 6000
                os.system("echo 'Done host: " + ip + " "+ "Device: " + str(device) + "' >> donePods.txt")
            



    try:
        #sometimes the first password does not get executed 
        #if there is a console passw and its on "press return to get started"
        #so this try esentially wakes up the device

            connect =   ConnectHandler(
                                        host=ip, 
                                        port= portNum,
                                        device_type="cisco_ios_telnet",
                                        password= "attemptToWakeUp",
                                
                                )
            
            finalProgram(connect)

            
    except:
        
        #has a counter so its not stuck in a loop
        c=0
        for elem in passwords:
            try:
                c+=1
                connect =   ConnectHandler(
                                            host= ip, 
                                            port= portNum,
                                            device_type="cisco_ios_telnet",
                                            password= elem
                                        
     )
                finalProgram(connect)
                break
            except: 
                if c==3:
                    pass                    
                else:
                    continue
            
            raise Exception
        
            
        

except: 
    #traceback.print_exc()
    device = int(portNum) - 6000 
    os.system("echo 'host: " + ip + " device: " + str(device) +  " could not be cleared' >> errorLogs.txt")
   