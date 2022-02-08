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
            match status:
                case 0:
                    if(ser.read(1) ==  b'S'):
                        status += 1
                    else:
                        status = 0
                case 1:
                    if(ser.read(1) ==  b'T'):
                        status += 1
                    else:
                        status = 0
                case 2:
                    data[1] = ser.read(1)
                    data[2] = ser.read(1)
                    point_x_bytes = data[2] + data[1]

                    data[3] = ser.read(1)
                    data[4] = ser.read(1)
                    point_y_bytes = data[4] + data[3]

                    status += 1
                case 3:
                    if(ser.read(1) ==  b'E'):
                        status += 1
                    else:
                        status = 0
                case 4:
                    if(ser.read(1) ==  b'N'):
                        status += 1
                    else:
                        status = 0
                case 5:
                    if(ser.read(1) ==  b'D'):
                        status = 0
                        point_x = int.from_bytes(point_x_bytes, "big")
                        point_y = int.from_bytes(point_y_bytes, "big")
                        print(point_x, point_y)
                    else:
                        status = 0

except KeyboardInterrupt:
    ser.close()
    print('close...')
