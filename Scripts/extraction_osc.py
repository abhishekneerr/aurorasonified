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
        

def read_csv():
    csv_file = pd.read_csv('test_csv.csv') 
    return csv_file


def get_data_from_csv(index_from_csound):
    
    aurora_data =  read_csv()
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
    client.send_message("/Bt_med", float(all_data[0]))
    client.send_message("/Bt_min", float(all_data[1]))
    client.send_message("/Bt_max", float(all_data[2]))
    client.send_message("/Bx_med", float(all_data[3]))
    client.send_message("/Bx_min", float(all_data[4]))
    client.send_message("/Bx_max", float(all_data[5]))
    client.send_message("/By_med", float(all_data[6]))
    client.send_message("/By_min", float(all_data[7]))
    client.send_message("/By_max", float(all_data[8]))
    client.send_message("/Bz_med", float(all_data[9]))
    client.send_message("/Bz_min", float(all_data[10]))
    client.send_message("/Bz_max", float(all_data[11]))
    client.send_message("/Phi_med", float(all_data[12]))
    client.send_message("/Phi_min", float(all_data[13]))
    client.send_message("/Phi_max", float(all_data[14]))
    client.send_message("/Theta_med", float(all_data[15]))
    client.send_message("/Theta_min", float(all_data[16]))
    client.send_message("/Theta_max", float(all_data[17]))
    client.send_message("/Dens_med", float(all_data[18]))
    client.send_message("/Dens_min", float(all_data[19]))
    client.send_message("/Dens_max", float(all_data[20]))
    client.send_message("/Speed_med", float(all_data[21]))
    client.send_message("/Speed_min", float(all_data[22]))
    client.send_message("/Speed_max", float(all_data[23]))
    client.send_message("/Temp_med", float(all_data[24]))
    client.send_message("/Temp_min", float(all_data[25]))
    client.send_message("/Temp_max", float(all_data[26]))
    client.send_message("/TimeStamp", str(all_data[27]))
    
    print("message sent on port:", sendport)


if __name__ == '__main__':

    ##sending osc messages on
    global client
    client = udp_client.SimpleUDPClient(ip,sendport)
    
    ##catching osc messages/receiving osc messages
    dispatcher = dispatcher.Dispatcher()
    dispatcher.map("/osc_message_to_python", get_osc_messages) #creating the variables we want to receive osc messages for

    #set up server to listen for osc messages
    server = osc_server.ThreadingOSCUDPServer((ip,inport),dispatcher)
    print("serving on {}".format(server.server_address))
    server.serve_forever()
    
    # time_stamp = 1
    # get_data_from_csv(time_stamp)



    
    
    
    

   

 