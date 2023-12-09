import socket
import threading
import select
import sys
import pandas
import time
from queue import Queue

class ServerThrend(threading.Thread):
    def __init__(self, DataQueue, IsStop, args=(), kwargs=None) :
        threading.Thread.__init__(self, args=(), kwargs=None)
        self.DataQueue = DataQueue
        self.IsStop = IsStop
        self.SenderIP = args[0]
        self.TargerIP = args[1]
        self.SenderPort = args[2]
        self.TargetPort = args[3]
        self.RxBuff = bytes()
        self.read_list = list()
        self.write_list = list()

    def run(self):
        Server_address, Client_address= (self.SenderIP, int(self.SenderPort)), (self.TargerIP, int(self.TargetPort))
        # Create a datagram socket
        UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
        self.read_list = [UDPServerSocket]

        try :
            # Bind to address and ip
            UDPServerSocket.bind(Server_address)
        except socket.error as e:
            print("Error Message : ", end ="")
            if e.errno == errno.EADDRINUSE:
                print("Port is already in use")
            else:
                # something else raised the socket.error exception
                print(e)
        else :
            print('Message : Socket bind completed, ready to receive data')
            while 1:
                # Wait for receiving Data or
                try :
                    readable, writable, errored = select.select(self.read_list, self.write_list, [], 0.5)
                except select.error:
                    # connection error event here
                    print ('Error Message in ServerSock : ' + 'connection error')
                    break

                # Handle input
                for s in readable :
                    (recv_data, recv_addr) = s.recvfrom(1024)
                    if recv_addr==Client_address :
                        self.RxBuff += recv_data
                    else :
                        print('Error Message : UDP data packet receiving has an unexpected address')

                # Managing data in buffer
                self.DataExtraction()

                # Terminate
                if self.IsStop.is_set() :
                    break
            # End of loop

        finally :
            # Make sure that UDPServerSocket has been closed
            UDPServerSocket.close()
        return None

    # Message format
    # L T = x1 x2 y1 y2 SOH
    # where x1 concat x2 is TCP Payload length
    # and y1 concat y2 is clk of counter value (latency)
    def DataExtraction(self) :
        if len(self.RxBuff)>7:
            if self.RxBuff[:3]==b'LT=' and self.RxBuff[7]==1:
                message, self.RxBuff = self.RxBuff[:8], self.RxBuff[8:]
                # Message is valid
                PayloadLen = int.from_bytes(message[3:5], byteorder='big')
                ClkCycle = int.from_bytes(message[5:7], byteorder='big')
                # Put data in queue
                self.DataQueue.put((PayloadLen,ClkCycle))
            else :
                print(self.RxBuff)
                self.RxBuff = self.RxBuff[1::]
                print('Error message : message format is incorrect!')
                sys.exit()
            self.DataExtraction()
        return None

class FileWriter(threading.Thread):
    def __init__(self, DataQueue, IsStop, args=(), kwargs=None) :
        threading.Thread.__init__(self, args=(), kwargs=None)
        self.DataQueue = DataQueue
        self.IsStop = IsStop
        self.FilePath = args[0]
        self.FileNameHd = args[1]
        self.Time_sleep = args[2]
        self.FileNameNum = 1
        self.tot_write = 0
        self.WriteBuff = list()

    def run(self):
        while 1:
            # Time sleep blocking
            time.sleep(self.Time_sleep)
            # Terminating
            if self.IsStop.is_set():
                # Write file before killing this thread
                if self.WriteBuff:
                    self.Write_file()
                break

            # Get all data from queue
            self.queue_get_all()

            # writing file due to overloading buffer
            if len(self.WriteBuff)>50000:
                self.Write_file()

    def queue_get_all(self):
        while 1:
            try:
                self.WriteBuff.append(self.DataQueue.get_nowait())
            except :
                break
        return None

    def Write_file(self):
        ListData, self.WriteBuff = self.WriteBuff, list()
        Filename = self.FileNameHd + str(self.FileNameNum)
        self.FileNameNum += 1
        self.tot_write += len(ListData)
        try :
            WrFile = pandas.DataFrame(ListData, columns=['Payload Length', 'Clk cycle'])
            WrFile.to_csv(self.FilePath+Filename+".csv")
        except :
            print("Error Message : File writing fail")
        print('Message :' + 'File written "' + self.FilePath+Filename+".csv" + '"' )
        print('Message : cumulative number of packets written in file = ' \
        + str(self.tot_write) + " Packets")
        return None

## Main program
def IsNotInt(s):
    try:
        int(s)
        return False
    except ValueError:
        return True

def main(FilePath) :
    FileNameHd = input('Enter File name header : ')
    SenderIP = input('Enter your IP Address (192.168.7.25): ')
    TargerIP = input('Enter your target address (192.168.7.1) : ')
    SenderPort = input('Enter your port number (1024): ')
    TargetPort = input('Enter your target port number (63): ')

    if IsNotInt(SenderPort) or IsNotInt(TargetPort) :
        print("Error Message : Port number must be integer")
        sys.exit()

    # Initate variable
    DataQueue = Queue()
    IsStop = threading.Event()
    IsStop.clear()

    # start threading
    threads = list()
    threads.append(ServerThrend(DataQueue, IsStop, \
    args=(SenderIP, TargerIP, int(SenderPort), int(TargetPort))))
    threads.append(FileWriter(DataQueue, IsStop, args=(FilePath, FileNameHd, 1)))
    for thread in threads:
        thread.start()

    # running
    while 1:
        # taking Exit to terminate
        Cmd = input()
        if Cmd=="exit" :
            IsStop.set()
            break
    # End of loop
    for each_threads in threads:
        each_threads.join()
    print("Message : threads killed")
    print("Closed!!")
    return None

if __name__=="__main__":
    # Taking input: File Path
    FilePath = ""
    main(FilePath)
