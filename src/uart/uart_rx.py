import serial

COM_PORT = '/dev/ttyUSB0'
BAUD_RATES = 115200
ser = serial.Serial(COM_PORT, BAUD_RATES, bytesize=8,
                    parity=serial.PARITY_EVEN, stopbits=1, timeout=0.01)

try:
    while True:
        while ser.in_waiting:
            # data_raw = ser.readline()
            data_raw = ser.read(1)
            print('get org: ', data_raw)
            data = data_raw.decode('utf-8')
            print('get data: ', data)

except KeyboardInterrupt:
    ser.close()
    print('close...')
