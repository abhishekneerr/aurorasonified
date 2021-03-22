import pandas as pd
import csv

time_stamp = "2021-01-27 11:00:00"


def read_csv():
    csv_file = pd.read_csv('test_csv.csv') 
    return csv_file


def main():
    aurora_data =  read_csv()
    all_data = []
    for index, row in aurora_data.iterrows():
        #print(index,row)
        if row['TimeStamp'] == time_stamp:
            all_data.append(row['Bt-med'])
            all_data.append(row['Bz-min'])
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

    # return all_data

    print(all_data)
    


main()
