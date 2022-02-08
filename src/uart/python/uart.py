import serial
import numpy as np


class UartControl():

    def __init__(self) -> None:
        pass
        data = np.empty([10], dtype='bytes')
        point_x_bytes = b''
        point_y_bytes = b''
        self.point_x = 0
        self.point_y = 0
        status = 0

        self.flag_write = '0'

        COM_PORT = '/dev/ttyUSB0'
        BAUD_RATES = 115200
        self.ser = serial.Serial(COM_PORT, BAUD_RATES, bytesize=8,
                            stopbits=1, timeout=0.01)

        try:
            while True:
                while self.ser.in_waiting:
                    match status:
                        case 0:
                            if(self.ser.read(1) ==  b'S'):
                                status += 1
                            else:
                                status = 0
                        case 1:
                            if(self.ser.read(1) ==  b'T'):
                                status += 1
                            else:
                                status = 0
                        case 2:
                            data[1] = self.ser.read(1)
                            data[2] = self.ser.read(1)
                            point_x_bytes = data[2] + data[1]

                            data[3] = self.ser.read(1)
                            data[4] = self.ser.read(1)
                            point_y_bytes = data[4] + data[3]

                            status += 1
                        case 3:
                            if(self.ser.read(1) ==  b'E'):
                                status += 1
                            else:
                                status = 0
                        case 4:
                            if(self.ser.read(1) ==  b'N'):
                                status += 1
                            else:
                                status = 0
                        case 5:
                            if(self.ser.read(1) ==  b'D'):
                                status = 0
                                point_x = int.from_bytes(point_x_bytes, "big")
                                point_y = int.from_bytes(point_y_bytes, "big")
                                print(point_x, point_y)
                            else:
                                status = 0
                    self.ser_write()

        except KeyboardInterrupt:
            self.ser.close()
            print('close...')


    def ser_write(self):
        if(self.flag_write == '1'):
            self.ser.write(b'\x01')
        elif(self.flag_write == '0'):
            self.ser.write(b'\x00')



if __name__ == "__main__":
    uc = UartControl()