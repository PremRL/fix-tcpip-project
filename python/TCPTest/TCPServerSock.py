import select
import threading
import socket
import random
from queue import Queue

class ServerThrend(threading.Thread):
    def __init__(self, IsTransReady, IsStop, IsPeek, SeedQueue, PrintQueue, args=(), kwargs=None) :
        threading.Thread.__init__(self, args=(), kwargs=None)
        self.IsTransReady = IsTransReady
        self.IsStop = IsStop
        self.IsPeek = IsPeek
        self.SeedQueue = SeedQueue
        self.PrintQueue = PrintQueue
        self.IPAddr = args[0]
        self.PortAddr = args[1]
        self.MaxTransSize = args[2]
        self.NumSample = args[3]
        # Initiate process buffer
        self.TxBuff = list()
        self.read_list = list()
        self.write_list = list()
        self.TotalRecv = 0
        self.TotalSend = 0

    def run(self):
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        soc.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        self.PrintQueue.put('Message : Socket created\n')
        try:
            soc.bind((self.IPAddr, self.PortAddr))
            self.PrintQueue.put('Message : Socket bind complete\n')
        except socket.error as msg:
            self.PrintQueue.put('Error Message in ServerSock')
            self.PrintQueue.put(msg + '\n')
        else :
            ## Run server
            #Start listening on socket, only 1 connection
            soc.listen(1)
            self.PrintQueue.put('Message : Server start listening\n')
            self.read_list = [soc]

            while 1:
                try :
                    readable, writable, errored = select.select(self.read_list, self.write_list, [], 0)
                except select.error:
                    # connection error event here
                    self.PrintQueue.put('Error Message in ServerSock : ' + 'connection error\n')
                    break

                # Terminate thread
                if self.IsStop.is_set() :
                    self.IsStop.clear()
                    if self.write_list :
                        self.Close_connection()
                    break

                # Generating output data
                self.GenTxBuff()

                # Handle peek
                if self.IsPeek.is_set() :
                    self.IsPeek.clear()
                    self.PeekTransfer()

                # Handle input
                for s in readable :
                    # Accept client
                    if s is soc:
                        self.Accept_connection()
                    # received data
                    else :
                        recv_data = s.recv(self.MaxTransSize)
                        self.TotalRecv += len(recv_data)
                        # Peer want to end of transmission
                        if not recv_data :
                            self.Close_connection()

                # Handle output
                # there's some data in queue
                for s in writable :
                    # Main want to transfer data
                    if self.IsTransReady.is_set() and self.TxBuff:
                        # Send Message
                        self.Transfer2connection()
            ## End of loop

        finally :
            # Always kill the socket
            soc.close()
            self.PrintQueue.put('Message : Socket has been terminated\n')
            return None

    def Accept_connection(self) :
        self.TotalRecv = 0
        self.TotalSend = 0
        client_socket, address = (self.read_list[0]).accept()
        self.read_list.append(client_socket)
        self.write_list.append(client_socket)
        self.PrintQueue.put("Message : Connection from " + str(address) + ' \n')
        return None

    def Close_connection(self) :
        self.PeekTransfer()
        self.TotalRecv = 0
        self.TotalSend = 0
        self.write_list[0].shutdown(2)    # 0 = done receiving, 1 = done sending, 2 = both
        self.write_list[0].close()
        self.write_list.remove(self.write_list[0])
        self.read_list.remove(self.write_list[0])
        self.PrintQueue.put('Message : ' + 'Connection has been closed\n')
        return None

    def GenTxBuff(self) :
        if not self.SeedQueue.empty() :
            random.seed(int(self.SeedQueue.get()))
            list_buff = [i+1 for i in range (int(self.MaxTransSize))]*self.NumSample #1 - 8960
            random.shuffle(list_buff)
            self.TxBuff.extend(list_buff)
            #self.PrintQueue.put('Transfer size 1st 30 : '+str(self.TxBuff[-30::][::-1])+'\n')
        return None

    def Transfer2connection(self) :
        try :
            Message = self.TCPGenData(self.TxBuff.pop()) # get data from buffer
            self.TotalSend += len(Message)
            self.write_list[0].setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, len(Message))
            self.write_list[0].sendall(Message)
            self.write_list[0].send(b'') # Flush
        except IndexError :
            self.PrintQueue.put('Error Message in ServerSock : ' + 'TxBuff is empty but called\n')
        except socket.error as msg:
            self.PrintQueue.put('Error Message in ServerSock : ')
            self.PrintQueue.put(msg + '\n')
        return None

    def PeekTransfer(self):
        self.PrintQueue.put('Message : ' + 'Number of bytes received = ' + str(self.TotalRecv) + ' Bytes' + \
        ', Total send data = ' + str(self.TotalSend) + ' Bytes\n')
        return None

    def TCPGenData(self, length):
        return (chr(length%255).encode('latin-1')*length)
