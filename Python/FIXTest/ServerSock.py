import select
import threading
import socket
from queue import Queue

class ServerThrend(threading.Thread):
    def __init__(self, queue, stop_threads, args=(), kwargs=None) :
        threading.Thread.__init__(self, args=(), kwargs=None)
        self.queue = queue
        self.IPAddr = args[0]
        self.PortAddr = args[1]
        self.stop_threads = stop_threads
        self.read_list = list()
        self.write_list = list()

    def run(self):
        Max_Transfer_Size = 8960
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        print ('Message : Socket created')
        try:
            soc.bind((self.IPAddr, self.PortAddr))
            print ('Message : Socket bind complete')
        except socket.error as msg:
            print ('Error Message in ServerSock : ', end='')
            print(msg)
        except :
            print("Error Message in ServerSock : Terrible error")
        else :
            ## Run server
            #Start listening on socket, only 1 connection
            soc.listen(1)
            print("Message : Server start listening")
            self.read_list = [soc]
            while True:
                try :
                    readable, writable, errored = select.select(self.read_list, self.write_list, [], 1)
                except select.error:
                    # connection error event here
                    print ('Error Message in ServerSock : ' + 'connection error')
                    break

                # Terminate
                if self.stop_threads.is_set() :
                    if self.write_list :
                        self.Close_connection(self.write_list[0])
                    break

                # Handle input
                for s in readable :
                    # Accept client
                    if s is soc:
                        client_socket, address = soc.accept()
                        self.read_list.append(client_socket)
                        self.write_list.append(client_socket)
                        print("Message : Clearing queue")
                        # Clear queue
                        with self.queue.mutex:
                            self.queue.queue.clear()
                        print("Message : Connection from", address)
                    # received data
                    else :
                        recv_data = s.recv(Max_Transfer_Size)
                        # Peer want to end of transmission
                        if not recv_data :
                            self.Close_connection(self.write_list[0])

                # Handle output
                # there's some data in queue
                if (not self.queue.empty()) and self.write_list:
                    # conn in writable
                    if  self.write_list[0] in writable:
                        self.write_list[0].sendall(self.queue.get())

            ## End of loop
        finally :
            # Always kill the socket
            soc.close()
            print ('Message : Socket has been terminated')
            return None

    def Close_connection(self, conn) :
        conn.shutdown(2)    # 0 = done receiving, 1 = done sending, 2 = both
        conn.close()
        self.write_list.remove(conn)
        self.read_list.remove(conn)
        return None
