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
        

def read_csv():
    csv_file = pd.read_csv('test_csv.csv') 
    return csv_file


def get_data_from_csv(time_stamp):
    aurora_data =  read_csv()
    all_data = []
    for index, row in aurora_data.iterrows():
        if index == time_stamp:
            all_data.append(row['Bt-med'])
            all_data.append(row['Bt-min'])
            all_data.append(row['Bt-max'])
            all_data.append(row['Bx-med'])
            all_data.append(row['Bx-min'])
            all_data.append(row['Bx-max'])
            all_data.append(row['By-med'])
            all_data.append(row['By-min'])
            all_data.append(row['By-max'])
            all_data.append(row['Bz-med'])
            all_data.append(row['Bz-min'])
            all_data.append(row['Bz-max'])
            all_data.append(row['Phi-mean'])
            all_data.append(row['Phi-min'])
            all_data.append(row['Phi-max'])
            all_data.append(row['Theta-med'])
            all_data.append(row['Theta-min'])
            all_data.append(row['Theta-max'])
            all_data.append(row['Dens-med'])
            all_data.append(row['Dens-min'])
            all_data.append(row['Dens-max'])
            all_data.append(row['Speed-med'])
            all_data.append(row['Speed-min'])
            all_data.append(row['Speed-max'])
            all_data.append(row['Temp-med'])
            all_data.append(row['Temp-min'])
            all_data.append(row['Temp-max'])
            all_data.append(row['TimeStamp'])
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
    dispatcher.map("/osc_message_to_python", get_osc_messages) #creating the variables we want to receive osc messages for

    #set up server to listen for osc messages
    server = osc_server.ThreadingOSCUDPServer((ip,inport),dispatcher)
    print("servering on {}".format(server.server_address))
    server.serve_forever()
    
    
    
    

   

 