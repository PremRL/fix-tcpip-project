import socket
import errno

def main(Message, SenderIP, TargerIP, SenderPort, TargetPort):

    Server_address, Client_address= (SenderIP, SenderPort), (TargerIP, TargetPort)
    # Create a datagram socket
    UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

    try :
        # Bind to address and ip
        UDPServerSocket.bind(Server_address)
        # Send Data message (Encoded) over UDP
        UDPServerSocket.sendto(Message, Client_address)
        print("Message : UDP packet has been transferred")
    except socket.error as e:
        print("Error Message in MessageOverUDP :", end =" ")
        if e.errno == errno.EADDRINUSE:
            print("Port is already in use")
        else:
            # something else raised the socket.error exception
            print(e)
    finally :
        # Make sure that UDPServerSocket has been closed
        UDPServerSocket.close()
    return None

if __name__=="__main__":
    Message = "This is a message".encode('latin-1')
    SenderIP = "127.0.0.1"
    TargerIP = "127.0.0.1"
    SenderPort = 1024
    TargetPort = 2341
    main(Message, SenderIP, TargerIP, SenderPort, TargetPort)
