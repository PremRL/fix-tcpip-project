import threading
import sys
import TCPServerSock
from queue import Queue

def IsInt(s):
    try:
        int(s)
        return True
    except ValueError:
        return False

def Isfloat(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

def main() :
    global SeedQueue, PrintQueue, IsTransReady, IsStop, IsPeek

    # Initiate value
    IPAddr = input("Enter server IP Addr (Default: 192.168.7.25): ").replace(" ","")
    PortAddr = input("Enter server TCP Port (Default: 25123): ").replace(" ","")
    MaximumTransSize = input('Enter maximum transfer size: ').replace(" ","")
    NumberofSample = input('Enter Number of sample: ').replace(" ","")

    # Checking input
    if not IsInt(PortAddr) or not IsInt(MaximumTransSize) or not IsInt(NumberofSample):
        print('Error Message : Invalid input value')
        sys.exit()

    SeedQueue = Queue()
    PrintQueue = Queue()
    IsTransReady = threading.Event()
    IsStop = threading.Event()
    IsPeek = threading.Event()
    IsTransReady.clear()
    IsStop.clear()
    IsPeek.clear()

    # Initiate
    threads = list()
    threads.append(TCPServerSock.ServerThrend(IsTransReady, IsStop, IsPeek,\
    SeedQueue, PrintQueue, args=(IPAddr, int(PortAddr), int(MaximumTransSize), int(NumberofSample))))
    threads[0].start()

    while 1 :
        # Command input
        print('Command Input :', end='')
        sys.stdout.flush()
        InputCommand = sys.stdin.readline()[:-1]
        if command(InputCommand) :
            break

    # Joining tread
    for each_threads in threads :
        each_threads.join()
    while not PrintQueue.empty():
        print(PrintQueue.get(), end='')
    print("\nMessage : threads killed")
    print("Closed!!")
    return None

# Command
# "Print": print all meesage in queue
# "Peek": peeking the send and receive byte transferred
# "Ready": intialize transferring
# "Stop": kill server
# "TxData": Random seed init
def command(InputCommand):
    if InputCommand=="Print" :
        while not PrintQueue.empty():
            print(PrintQueue.get(), end='')
    elif InputCommand=="Peek" :
        IsPeek.set()
    elif InputCommand=="Ready" :
        IsTransReady.set()
    elif InputCommand=="Stop" :
        IsStop.set()
        IsTransReady.clear()
        return True
    elif InputCommand=="TxData" :
        print('Random seed input :', end='')
        sys.stdout.flush()
        RandSeed = sys.stdin.readline()[:-1]
        if IsInt(RandSeed):
            SeedQueue.put(int(RandSeed))
    return False

if __name__=="__main__" :
    main()
