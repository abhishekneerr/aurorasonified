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
sendport = 7000
inport = 8000 
        
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
        max = 400.0 #359.99
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


def read_csv():
    #filename = 'test_csv.csv'
    filename = "for_csound.csv"
    csv_file = pd.read_csv(filename) 
    return csv_file


def get_data_from_csv(time_stamp):
    aurora_data =  read_csv()
    all_data = []
    for index, row in aurora_data.iterrows():
        if index == time_stamp:
            all_data.append(scaling_by_type(row['Bt-med'], 'Bt-med'))
            all_data.append(scaling_by_type(row['Bt-min'], 'Bt-min'))
            all_data.append(scaling_by_type(row['Bt-max'], 'Bt-max'))
            all_data.append(scaling_by_type(row['Bx-med'], 'Bx-med'))
            all_data.append(scaling_by_type(row['Bx-min'], 'Bx-min'))
            all_data.append(scaling_by_type(row['Bx-max'], 'Bx-max'))
            all_data.append(scaling_by_type(row['By-med'], 'By-med'))
            all_data.append(scaling_by_type(row['By-min'], 'By-min'))
            all_data.append(scaling_by_type(row['By-max'], 'By-max'))
            all_data.append(scaling_by_type(row['Bz-med'], 'Bz-med'))
            all_data.append(scaling_by_type(row['Bz-min'], 'Bz-min'))
            all_data.append(scaling_by_type(row['Bz-max'], 'Bz-max'))
            all_data.append(scaling_by_type(row['Phi-mean'], 'Phi-mean'))
            all_data.append(scaling_by_type(row['Phi-min'], 'Phi-min'))
            all_data.append(scaling_by_type(row['Phi-max'], 'Phi-max'))
            all_data.append(scaling_by_type(row['Theta-med'], 'Theta-med'))
            all_data.append(scaling_by_type(row['Theta-min'], 'Theta-min'))
            all_data.append(scaling_by_type(row['Theta-max'], 'Theta-max'))
            all_data.append(scaling_by_type(row['Dens-med'], 'Dens-med'))
            all_data.append(scaling_by_type(row['Dens-min'], 'Dens-min'))
            all_data.append(scaling_by_type(row['Dens-max'], 'Dens-max'))
            all_data.append(scaling_by_type(row['Speed-med'], 'Speed-med'))
            all_data.append(scaling_by_type(row['Speed-min'], 'Speed-min'))
            all_data.append(scaling_by_type(row['Speed-max'], 'Speed-max'))
            all_data.append(scaling_by_type(row['Temp-med'], 'Temp-med'))
            all_data.append(scaling_by_type(row['Temp-min'], 'Temp-min'))
            all_data.append(scaling_by_type(row['Temp-max'], 'Temp-max'))
            all_data.append(scaling_by_type(row['TimeStamp'], 'TimeStamp'))
            break

    return all_data

def get_osc_messages(data_path, data_sent):
    print("data received")
    date_time = data_sent
    all_data = get_data_from_csv(date_time)

    send_osc_messages(sendport,all_data)

def send_osc_messages(sendport, all_data):
    client.send_message("/Bt_med", all_data[0])
    client.send_message("/Bt_min", all_data[1])
    client.send_message("/Bt_max", all_data[2])
    client.send_message("/Bx_med", all_data[3])
    client.send_message("/Bx_min", all_data[4])
    client.send_message("/Bx_max", all_data[5])
    client.send_message("/By_med", all_data[6])
    client.send_message("/By_min", all_data[7])
    client.send_message("/By_max", all_data[8])
    client.send_message("/Bz_med", all_data[9])
    client.send_message("/Bz_min", all_data[10])
    client.send_message("/Bz_max", all_data[11])
    client.send_message("/Phi_med", all_data[12])
    client.send_message("/Phi_min", all_data[13])
    client.send_message("/Phi_max", all_data[14])
    client.send_message("/Theta_med", all_data[15])
    client.send_message("/Theta_min", all_data[16])
    client.send_message("/Theta_max", all_data[17])
    client.send_message("/Dens_med", all_data[18])
    client.send_message("/Dens_min", all_data[19])
    client.send_message("/Dens_max", all_data[20])
    client.send_message("/Speed_med", all_data[21])
    client.send_message("/Speed_min", all_data[22])
    client.send_message("/Speed_max", all_data[23])
    client.send_message("/Temp_med", all_data[24])
    client.send_message("/Temp_min", all_data[25])
    client.send_message("/Temp_max", all_data[26])
    client.send_message("/TimeStamp", all_data[27])
    
    # client.send_message("/extracted_data", all_data)
    print("message sent on port:", sendport)


if __name__ == '__main__':

    # time_stamp = "2021-01-27 00:00:00"
    #get_data_from_csv(time_stamp)


    ##sending osc messages on
    global client
    client = udp_client.SimpleUDPClient(ip,sendport)
    
    ##catching osc messages or receiving osc messages
    dispatcher = dispatcher.Dispatcher()
    dispatcher.map("/index_from_csound", get_osc_messages) #creating the variables we want to receive osc messages for

    #set up server to listen for osc messages
    server = osc_server.ThreadingOSCUDPServer((ip,inport),dispatcher)
    print("servering on {}".format(server.server_address))
    server.serve_forever()
    
    
    
    

   

 
