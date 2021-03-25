from pythonosc import dispatcher            #  to catch and map input from osc
from pythonosc import osc_server            #  to create and send OSC messages
from pythonosc import osc_message_builder   #  to package osc messages 
from pythonosc import udp_client            #  to listen for messages
from pythonosc.osc_server import AsyncIOOSCUDPServer
import argparse                             #  to understand messages that come in
import asyncio
import time
import pandas as pd
import csv

ip = "127.0.0.1"
sendport = 9000
inport = 8000 

filename = "../Data_csound/for_csound.csv"
aurora_data = pd.read_csv(filename) 

def scaling(value, minimum, maximum, factor=1):
    """Scale the value according to the recorded minimum and maximum values, to something between 0-1"""
    return (value-minimum)/(maximum-minimum)

def scaling_by_type(value, type):
    """Collection of maximum and minimum for different types of values"""

    factor = 1
    # Commented values are the actually observed min and max.
    if "Bt" in type:
        max = 30.0 # 23.21
        min = 0.0 # 0.25
    elif "Bx" in type:
        max = 20.0  #13.68
        min = -10.0 #-6.82
    elif "By" in type:
        max = 10.0 #7.77
        min = -25.0 #-19.74
    elif "Bz" in type:
        max = 25.0 #20.55
        min = -25.0 #-19.09
    elif "Phi" in type:
        max = 360.0 #359.99
        min = 0.0 #0
    elif "Theta" in type:
        max = 100.0 #89.41
        min = -100.0 #-87.77
    elif "Dens" in type:
        max = 100.0 #63.74
        min = 0.0 #0.1
    elif "Speed" in type:
        max = 1000.0 #682.4
        min = 200.0 #291.9
    elif "Temp" in type:
        max = 1500000.0 #1128079
        min = 4000.0 #5000
    elif "TimeStamp" in type:
        return value
    else:
        print("Couldn't recognize type")
        return False
    return scaling(value, min, max, factor)




def get_data_from_csv(index_from_csound):
    
    selected_row = aurora_data.iloc[index_from_csound]
    all_data = []
    for index in selected_row: 
        all_data.append(index)
    return all_data

def get_osc_messages(data_path, data_sent):
    print("data received from csound")
    time_stamp = data_sent
    all_data = get_data_from_csv(time_stamp)

    send_osc_messages(sendport,all_data)

def send_osc_messages(sendport, all_data):
    # TEMP:
    
    client.send_message("/Bt_med", scaling_by_type(float(all_data[0]), "Bt_med"))
    client.send_message("/Bt_min", scaling_by_type(float(all_data[1]), "Bt_min"))
    client.send_message("/Bt_max", scaling_by_type(float(all_data[2]), "Bt_max"))
    client.send_message("/Bx_med", scaling_by_type(float(all_data[3]), "Bx_med"))
    client.send_message("/Bx_min", scaling_by_type(float(all_data[4]), "Bx_min"))
    client.send_message("/Bx_max", scaling_by_type(float(all_data[5]), "Bx_max"))
    client.send_message("/By_med", scaling_by_type(float(all_data[6]), "By_med"))
    client.send_message("/By_min", scaling_by_type(float(all_data[7]), "By_min"))
    client.send_message("/By_max", scaling_by_type(float(all_data[8]), "By_max"))
    client.send_message("/Bz_med", scaling_by_type(float(all_data[9]), "Bz_med"))
    client.send_message("/Bz_min", scaling_by_type(float(all_data[10]), "Bz_min"))
    client.send_message("/Bz_max", scaling_by_type(float(all_data[11]), "Bz_max"))
    client.send_message("/Phi_med", scaling_by_type(float(all_data[12]), "Phi_med"))
    client.send_message("/Phi_min", scaling_by_type(float(all_data[13]), "Phi_min"))
    client.send_message("/Phi_max", scaling_by_type(float(all_data[14]), "Phi_max"))
    client.send_message("/Theta_med", scaling_by_type(float(all_data[15]), "Theta_med"))
    client.send_message("/Theta_min", scaling_by_type(float(all_data[16]), "Theta_min"))
    client.send_message("/Theta_max", scaling_by_type(float(all_data[17]), "Theta_max"))
    client.send_message("/Dens_med", scaling_by_type(float(all_data[18]), "Dens_med"))
    client.send_message("/Dens_min", scaling_by_type(float(all_data[19]), "Dens_min"))
    client.send_message("/Dens_max", scaling_by_type(float(all_data[20]), "Dens_max"))
    client.send_message("/Speed_med", scaling_by_type(float(all_data[21]), "Speed_med"))
    client.send_message("/Speed_min", scaling_by_type(float(all_data[22]), "Speed_min"))
    client.send_message("/Speed_max", scaling_by_type(float(all_data[23]), "Speed_max"))
    client.send_message("/Temp_med", scaling_by_type(float(all_data[24]), "Temp_med"))
    client.send_message("/Temp_min", scaling_by_type(float(all_data[25]), "Temp_min"))
    client.send_message("/Temp_max", scaling_by_type(float(all_data[26]), "Temp_max"))
    client.send_message("/TimeStamp", scaling_by_type(str(all_data[27]), "TimeStamp"))
    
    print("message sent on port:", sendport)


if __name__ == '__main__':

    ##sending osc messages on
    global client
    client = udp_client.SimpleUDPClient(ip,sendport)
    
    ##catching osc messages/receiving osc messages
    dispatcher = dispatcher.Dispatcher()
    dispatcher.map("/index_from_csound", get_osc_messages) #creating the variables we want to receive osc messages for

    #set up server to listen for osc messages
    server = osc_server.ThreadingOSCUDPServer((ip,inport),dispatcher)
    server.serve_forever()
    
    # time_stamp = 1
    # get_data_from_csv(time_stamp)



    
    
    
    

   

 
