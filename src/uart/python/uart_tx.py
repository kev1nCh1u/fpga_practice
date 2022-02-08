import serial
import numpy as np

data = np.empty([10], dtype='bytes')
point_x_bytes = b''
point_y_bytes = b''
point_x = 0
point_y = 0
flag = 0
status = 0

COM_PORT = '/dev/ttyUSB0'
BAUD_RATES = 115200
ser = serial.Serial(COM_PORT, BAUD_RATES, bytesize=8,
                     stopbits=1, timeout=0.01)

try:
    while True:
        while ser.in_waiting:
            a = input()
            if(a == '1'):
                ser.write(b'\x01')
            elif(a == '0'):
                ser.write(b'\x00')

except KeyboardInterrupt:
    ser.close()
    print('close...')
