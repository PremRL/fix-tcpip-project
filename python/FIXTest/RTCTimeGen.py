import datetime

def bitstring_to_bytes(s):
    return int(s, 2).to_bytes((len(s) + 7) // 8, byteorder='big')

def main():
    # Get datetime in string
    now = datetime.datetime.now()
    # print(now)
    RTCmessage = "RTC=".encode('latin-1')
    DateType = ['Y', 'm', 'd', 'H', 'M']
    for strtype in DateType :
        RTCmessage = RTCmessage + bitstring_to_bytes(bin(int(now.strftime("%"+strtype)))[2:])
    Msec = now.strftime("%S") + now.strftime("%f")[:3]
    RTCmessage = RTCmessage + bitstring_to_bytes(bin(int(Msec))[2:])
    return RTCmessage

if __name__=="__main__" :
    print(main())
