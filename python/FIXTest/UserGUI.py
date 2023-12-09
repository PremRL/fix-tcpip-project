# USER GUI for FIX meesage generator
import tkinter as tk
import threading
import RTCTimeGen
import FixMessageGen
import MessageOverUDP
import ServerSock
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
    

def on_closing():
    stop_threads.set()
    if threads :
        print("Message : Wait for killing threads")
        for each_threads in threads :
            each_threads.join()
        print("Message : threads killed")
    root.destroy()
    print("Window closed!!")

def Change_status(textinfo):
    # Kill widget
    try :
        for widget in frame5.winfo_children():
            widget.place_forget()
        tk.Label(frame5, text=textinfo, bg="slate gray", font='Helvetica 16').place(anchor='nw', relx=0.37, rely=0.28)
    except :
        print("Error Message : UserGUI Frame5 Bug")
    return None

def Click_CloseServer():
    global stop_threads, threads
    stop_threads.set()
    if threads :
        for each_threads in threads :
            each_threads.join()
        print("Message : threads killed")
        threads = []
        Change_status("OFF")
    return None

def Click_CreateServer():
    ## Managing input
    try :
        SerIPAddr = [int((vIPAddr[0].get()).replace(" ","")),\
                     int((vIPAddr[1].get()).replace(" ","")),\
                     int((vIPAddr[2].get()).replace(" ","")),\
                     int((vIPAddr[3].get()).replace(" ",""))]
        for each_num in SerIPAddr :
            if each_num>255 or each_num<0 :
                raise ValueError("IP address is out of range")
        PortAddr = int((vPortServer.get()).replace(" ",""))
        if PortAddr>65535 or PortAddr<0 :
            raise ValueError("Port address is out of range")
    except ValueError as ve:
        print("Error Message :", end =" ")
        print(ve)
        return None
    except :
        print("Error Message : There're some invalid IP address inputs\
        or Invalid port address")
        return None
    else :
        strIPAddr = ".".join(str(each) for each in SerIPAddr)
        intPortAddr = int(PortAddr)

        ## Start server : Testing
        stop_threads.clear()
        if not threads :
            threads.append(ServerSock.ServerThrend(q, stop_threads, args=(strIPAddr, intPortAddr,)))
            threads[0].start()
        Change_status("ON")

        return None

def Click_RTCmessage():
    ## Managing input
    try :
        SenderIPAddr = [int((vIPAddr[0].get()).replace(" ","")),\
                        int((vIPAddr[1].get()).replace(" ","")),\
                        int((vIPAddr[2].get()).replace(" ","")),\
                        int((vIPAddr[3].get()).replace(" ",""))]
        for each_num in SenderIPAddr :
            if each_num>255 or each_num<0 :
                raise ValueError("Sender IP address is out of range")

        TargetIPAddr = [int((vDesIPAddr[0].get()).replace(" ","")),\
                        int((vDesIPAddr[1].get()).replace(" ","")),\
                        int((vDesIPAddr[2].get()).replace(" ","")),\
                        int((vDesIPAddr[3].get()).replace(" ",""))]
        for each_num in TargetIPAddr :
            if each_num>255 or each_num<0 :
                raise ValueError("Target IP address is out of range")

        SenderPortAddr = int((vPortRTC[0].get()).replace(" ",""))
        TargetPortAddr = int((vPortRTC[1].get()).replace(" ",""))
        if SenderPortAddr>65535 or SenderPortAddr<0 \
            or TargetPortAddr>65535 or TargetPortAddr<0:
            raise ValueError("Port addresses are out of range")
    except ValueError as ve:
        print("Error Message :", end =" ")
        print(ve)
        return None
    except :
        print("Error Message : There're some invalid IP address inputs "+\
        "or Invalid port address")
        return None
    else :
        strSenderIPAddr     = ".".join(str(each) for each in SenderIPAddr)
        strTargetIPAddr     = ".".join(str(each) for each in TargetIPAddr)
        strSenderPortAddr   = int(SenderPortAddr)
        strTargetPortAddr   = int(TargetPortAddr)
        Send_message = RTCTimeGen.main()

        # Send Message
        MessageOverUDP.main(Send_message, strSenderIPAddr, strTargetIPAddr, \
        strSenderPortAddr, strTargetPortAddr)
        return None


def Click_Fixmessage():
    # Hadling subdetail of Fix meesage
    # Checking whether FIX message inputs are correct or not
    try :

        ## Message Header Handler
        # For HeaderRec :
        # Index 0: Contain string of BeginString field
        # Index 1: Contain string of MsgType
        # Index 2: Contain string of Sequence number
        # Index 3: Contain string of Sender computer ID
        # Index 4: Contain string of Target computer ID
        # Index 5: Contain string of PossDupFlag
        Sel = var.get()
        if Sel==0 :
            raise ValueError("Select some message type before sending")
        MsgType = ['A', '0', '1', '2', '3', '4', '5', 'W']
        HeaderRec = [FixHeader_Entry[0].get(), MsgType[Sel-1], FixHeader_Entry[1].get(),
                     FixHeader_Entry[2].get(), FixHeader_Entry[3].get(), FixHeader_Entry[4].get()]
        HeaderRec = [each.replace(" ","") for each in HeaderRec] # Delete all the spacing

        # Checking BeginStr
        if not HeaderRec[0] :
            raise ValueError("BeginString field needed input")
        # Checking SeqNum
        if IsInt(HeaderRec[2]) :
            if int(HeaderRec[2])<1 :
                raise ValueError("Sequnce number field must larger than zero")
        else :
            raise ValueError("Sequnce number field must be integer")
        # Checking Sender com ID
        if not HeaderRec[3] :
            raise ValueError("SenderCompID field needed input")
        # Checking target com ID
        if not HeaderRec[4] :
            raise ValueError("TargetCompID field needed input")
        # Checking PossDupFlag
        if HeaderRec[5]!="Y" and HeaderRec[5]  :
            raise ValueError("PossDupFlag field has invalid input")

        ErrorOp = (vErrorOp.get()).replace(" ","")
        if IsInt(ErrorOp) :
            if int(ErrorOp)<0 or int(ErrorOp)>3  :
                raise ValueError("Error option must be integer between 0-3")
        else :
            raise ValueError("Error option must be integer between 0-3")

        ## Message Detail
        # Index      0          1           2           3           4
        # Detail: HeaderRec, LogonRec, ResentReqRec, RejectRec, SeqRstRec,
        #            5                  6
        #         SnapShotFullRec, TestReq_HB
        #
        # In LogonRec : EncryptMet, HeartBtInt, RstSeqNumFlag, AppVerID (0 - 3)
        # In ResentReqRec : BeginSeqNum, EndSeqNum (0 - 1)
        # In Reject : RefSeqNum, RefTagID, RefMsgType, ReajectReaon (0 - 3)
        # In SeqReset : GapFillFlag, NewSeqNum (0 - 1)
        # In Snapshot : MDReqID, Symbol, SecID, SecIDSrc, NoEntries, (0 - 4)
        #               EntryType0, Price0, Size0, EntryTime0 (5 -8)
        #               EntryType1, Price1, Size1, EntryTime1 (9 -12)

        LogonRec = [vDef_val[0][0].get(), vDef_val[0][1].get(),
                    vDef_val[0][2].get(), vDef_val[0][3].get()]
        LogonRec = [each.replace(" ","") for each in LogonRec]

        ResentReqRec = [vDef_val[2][0].get(), vDef_val[2][1].get()]
        ResentReqRec = [each.replace(" ","") for each in ResentReqRec]

        RejectRec = [vDef_val[3][0].get(), vDef_val[3][1].get(), vDef_val[3][2].get(),
                     vDef_val[3][3].get(), vDef_val[3][4].get()]
        RejectRec = [each.replace(" ","") for each in RejectRec]

        SeqRstRec = [vDef_val[4][0].get(), vDef_val[4][1].get()]
        SeqRstRec = [each.replace(" ","") for each in SeqRstRec]

        SnapShotFullRec = [vDef_val[5][0].get(), vDef_val[5][1].get(), vDef_val[5][2].get(),
                           vDef_val[5][3].get(), vDef_val[5][4].get(), vDef_val[5][5].get(),
                           vDef_val[5][6].get(), vDef_val[5][7].get(), vDef_val[5][8].get(),
                           vDef_val[5][9].get(), vDef_val[5][10].get(), vDef_val[5][11].get(),
                           vDef_val[5][12].get()]
        SnapShotFullRec = [each.replace(" ","") for each in SnapShotFullRec]

        TestReq_HB = [(vDef_val[1][0].get()).replace(" ","")]

        ## Each type
        if Sel==1 :
            # Logon
            if IsInt(LogonRec[0]) :
                if not (int(LogonRec[0])==1 or int(LogonRec[0])==0) :
                    raise ValueError("EncryptMethod must be zero or one")
            else :
                raise ValueError("EncryptMethod must be zero or one")

            if IsInt(LogonRec[1]) :
                if int(LogonRec[1])<0 :
                    raise ValueError("Heartbeat Interval must be positive integer")
            else :
                raise ValueError("Heartbeat Interval must be positive integer")

            if LogonRec[2]!="Y" and LogonRec[2]!="N" :
                raise ValueError("ResetSeqNumFlag must be Y or N")

            if not IsInt(LogonRec[3]) :
                raise ValueError("AppVerID must be integer")

        elif Sel==2 or Sel==3 :
            # Heartbeat&TestReq
            if len(TestReq_HB[0])>8 :
                print("Warning Message : Length of Tag112 field longer than 8 bytes")

        elif Sel==4 :
            # ResendReq
            if IsInt(ResentReqRec[0]) :
                if int(ResentReqRec[0])<0:
                    raise ValueError("BeginSeqNum must be positive value")
            else :
                raise ValueError("BeginSeqNum must be integer")

            if IsInt(ResentReqRec[1]) :
                if int(ResentReqRec[1])<0:
                    raise ValueError("EndSeqNum must be positive value")
            else :
                raise ValueError("EndSeqNum must be integer")

        elif Sel==5 :
            # Reject
            if IsInt(RejectRec[0]) :
                if int(RejectRec[0])<0:
                    raise ValueError("RefSeqNum must be positive value")
            else :
                raise ValueError("RefSeqNum must be integer")

            if IsInt(RejectRec[1]) :
                if int(RejectRec[1])<0:
                    raise ValueError("RefTagID must be positive value")
            else :
                raise ValueError("RefTagID must be integer")

            if not RejectRec[2] :
                raise ValueError("RefMsgType needed input")

            if IsInt(RejectRec[3]) :
                if int(RejectRec[3])<0 :
                    raise ValueError("RejectReason must be positive value")
            else :
                raise ValueError("RejectReason must be integer")

        elif Sel==6 :
            # SeqReset
            if SeqRstRec[0]!="Y" and SeqRstRec[0]!="N":
                raise ValueError("ResetSeqNumFlag must be Y or N")

            if IsInt(SeqRstRec[1]) :
                if int(SeqRstRec[1])<1:
                    raise ValueError("BeginSeqNum must larger than zero")
            else :
                raise ValueError("BeginSeqNum must be integer")

        elif Sel==8 :
            # Snapshot
            if not SnapShotFullRec[0] :
                raise ValueError("MDReqID field needed input")

            if not SnapShotFullRec[1] :
                raise ValueError("Symbol field needed input")

            if not SnapShotFullRec[2] :
                raise ValueError("SecID field needed input")

            if not SnapShotFullRec[3] :
                raise ValueError("SecIDSrc field needed input")

            if IsInt(SnapShotFullRec[4]) :
                if int(SnapShotFullRec[4])<1 or int(SnapShotFullRec[4])>2:
                    raise ValueError("NoEntries must be the positive number between 1-2")
            else :
                raise ValueError("NoEntries must be positive value")

            if SnapShotFullRec[5]!='1' and SnapShotFullRec[5]!='0' :
                raise ValueError("EntryType0 must be zero or one")

            if not Isfloat(SnapShotFullRec[6]) :
                raise ValueError("Price0 must be float")

            if not IsInt(SnapShotFullRec[7]) :
                raise ValueError("Size0 must be integer")

            if not SnapShotFullRec[8] :
                raise ValueError("EntryTime0 field needed input")

            if SnapShotFullRec[9]!='1' and SnapShotFullRec[9]!='0' :
                raise ValueError("EntryType1 must be zero or one")

            if not Isfloat(SnapShotFullRec[10]) :
                raise ValueError("Price1 must be float")

            if not IsInt(SnapShotFullRec[11]) :
                raise ValueError("Size1 must be integer")

            if not SnapShotFullRec[12] :
                raise ValueError("EntryTime1 field needed input")

        DataRec = [HeaderRec, LogonRec, ResentReqRec, RejectRec,
                   SeqRstRec, SnapShotFullRec, TestReq_HB]
    except ValueError as ve:
        print("Error Message :", end =" ")
        print(ve)
        return None
    except :
        print("Error Message : There's some invalid input")
        return None

    else :
        Message = FixMessageGen.main(DataRec, int(ErrorOp))
        q.put(Message)
        print("Message : Fix Message has been generated")
        return None

def sel_change():
    Msgtype = var.get()
    for widget in frame4.winfo_children():
        widget.place_forget()
    if Msgtype==1 :
        # Display Logon detail
        EncryptMethod = tk.Label(frame4, text="EncryptMethod :", bg="slate gray", font='Helvetica 14')
        EncryptMethod.place(anchor='nw', relx=0.05, rely=0.05)

        HeartBtInt = tk.Label(frame4, text="HeartBtInt :", bg="slate gray", font='Helvetica 14')
        HeartBtInt.place(anchor='nw', relx=0.34, rely=0.05)

        RstSeqNumFlag = tk.Label(frame4, text="RstSeqNumFlag :", bg="slate gray", font='Helvetica 14')
        RstSeqNumFlag.place(anchor='nw', relx=0.57, rely=0.05)

        AppVerID = tk.Label(frame4, text="AppVerID :", bg="slate gray", font='Helvetica 14')
        AppVerID.place(anchor='nw', relx=0.05, rely=0.30)

        Logon_Entry0 = tk.Entry(frame4, width=3, borderwidth=2, font="Calibri 12", textvariable=vDef_val[0][0])
        Logon_Entry0.place(anchor='nw', relx=0.28, rely=0.05)

        Logon_Entry1 = tk.Entry(frame4, width=3, borderwidth=2, font="Calibri 12", textvariable=vDef_val[0][1])
        Logon_Entry1.place(anchor='nw', relx=0.5, rely=0.05)

        Logon_Entry2 = tk.Entry(frame4, width=3, borderwidth=2, font="Calibri 12", textvariable=vDef_val[0][2])
        Logon_Entry2.place(anchor='nw', relx=0.82, rely=0.05)

        Logon_Entry3 = tk.Entry(frame4, width=3, borderwidth=2, font="Calibri 12", textvariable=vDef_val[0][3])
        Logon_Entry3.place(anchor='nw', relx=0.22, rely=0.30)
    elif Msgtype==2 or Msgtype==3:
        # Display HeartBeat detail
        Heartbeat = tk.Label(frame4, text="TestReqID :", bg="slate gray", font='Helvetica 14')
        Heartbeat.place(anchor='nw', relx=0.05, rely=0.05)

        text112_Entry0 = tk.Entry(frame4, width=15, borderwidth=2, font="Calibri 12", textvariable=vDef_val[1][0])
        text112_Entry0.place(anchor='nw', relx=0.24, rely=0.05)
    elif Msgtype==4:
        # Display ResendReq detail
        BeginSeqNum = tk.Label(frame4, text="BeginSeqNum :", bg="slate gray", font='Helvetica 14')
        BeginSeqNum.place(anchor='nw', relx=0.05, rely=0.05)

        EndSeqNum = tk.Label(frame4, text="EndSeqNum :", bg="slate gray", font='Helvetica 14')
        EndSeqNum.place(anchor='nw', relx=0.4, rely=0.05)

        ResentReq_Entry0 = tk.Entry(frame4, width=5, borderwidth=2, font="Calibri 12", textvariable=vDef_val[2][0])
        ResentReq_Entry0.place(anchor='nw', relx=0.3, rely=0.05)

        ResentReq_Entry1 = tk.Entry(frame4, width=5, borderwidth=2, font="Calibri 12", textvariable=vDef_val[2][1])
        ResentReq_Entry1.place(anchor='nw', relx=0.63, rely=0.05)

    elif Msgtype==5:
        # Display Reject detail
        RefSeqNum = tk.Label(frame4, text="RefSeqNum :", bg="slate gray", font='Helvetica 14')
        RefSeqNum.place(anchor='nw', relx=0.05, rely=0.05)

        RefTagID = tk.Label(frame4, text="RefTagID :", bg="slate gray", font='Helvetica 14')
        RefTagID.place(anchor='nw', relx=0.35, rely=0.05)

        RefMsgType = tk.Label(frame4, text="RefMsgType :", bg="slate gray", font='Helvetica 14')
        RefMsgType.place(anchor='nw', relx=0.62, rely=0.05)

        RejectReason = tk.Label(frame4, text="RejectReason :", bg="slate gray", font='Helvetica 14')
        RejectReason.place(anchor='nw', relx=0.05, rely=0.30)

        EncodedText = tk.Label(frame4, text="EncodedText :", bg="slate gray", font='Helvetica 14')
        EncodedText.place(anchor='nw', relx=0.38, rely=0.30)

        Reject_Entry0 = tk.Entry(frame4, width=5, borderwidth=2, font="Calibri 12", textvariable=vDef_val[3][0])
        Reject_Entry0.place(anchor='nw', relx=0.25, rely=0.05)

        Reject_Entry1 = tk.Entry(frame4, width=5, borderwidth=2, font="Calibri 12", textvariable=vDef_val[3][1])
        Reject_Entry1.place(anchor='nw', relx=0.52, rely=0.05)

        Reject_Entry2 = tk.Entry(frame4, width=5, borderwidth=2, font="Calibri 12", textvariable=vDef_val[3][2])
        Reject_Entry2.place(anchor='nw', relx=0.83, rely=0.05)

        Reject_Entry3 = tk.Entry(frame4, width=5, borderwidth=2, font="Calibri 12", textvariable=vDef_val[3][3])
        Reject_Entry3.place(anchor='nw', relx=0.28, rely=0.30)

        Reject_Entry4 = tk.Entry(frame4, width=15, borderwidth=2, font="Calibri 12", textvariable=vDef_val[3][4])
        Reject_Entry4.place(anchor='nw', relx=0.6, rely=0.30)

    elif Msgtype==6:
        # Display SeqReset detail
        GapFillFlag = tk.Label(frame4, text="GapFillFlag :", bg="slate gray", font='Helvetica 14')
        GapFillFlag.place(anchor='nw', relx=0.05, rely=0.05)

        NewSeqNum = tk.Label(frame4, text="NewSeqNum :", bg="slate gray", font='Helvetica 14')
        NewSeqNum.place(anchor='nw', relx=0.35, rely=0.05)

        SeqRst_Entry0 = tk.Entry(frame4, width=2, borderwidth=2, font="Calibri 12", textvariable=vDef_val[4][0])
        SeqRst_Entry0.place(anchor='nw', relx=0.25, rely=0.05)

        SeqRst_Entry1 = tk.Entry(frame4, width=5, borderwidth=2, font="Calibri 12", textvariable=vDef_val[4][1])
        SeqRst_Entry1.place(anchor='nw', relx=0.58, rely=0.05)

    elif Msgtype==8:
        #Display SnapShotFull detail
        MDReqID = tk.Label(frame4, text="MDReqID :", bg="slate gray", font='Helvetica 14')
        MDReqID.place(anchor='nw', relx=0.05, rely=0.05)

        Symbol = tk.Label(frame4, text="Symbol :", bg="slate gray", font='Helvetica 14')
        Symbol.place(anchor='nw', relx=0.32, rely=0.05)

        SecID = tk.Label(frame4, text="SecID :", bg="slate gray", font='Helvetica 14')
        SecID.place(anchor='nw', relx=0.63, rely=0.05)

        SecIDSrc = tk.Label(frame4, text="SecIDSrc :", bg="slate gray", font='Helvetica 14')
        SecIDSrc.place(anchor='nw', relx=0.05, rely=0.25)

        NoEntries = tk.Label(frame4, text="NoEntries :", bg="slate gray", font='Helvetica 14')
        NoEntries.place(anchor='nw', relx=0.32, rely=0.25)

        EntryType0 = tk.Label(frame4, text="EntryType0 :", bg="slate gray", font='Helvetica 14')
        EntryType0.place(anchor='nw', relx=0.63, rely=0.25)

        Price0 = tk.Label(frame4, text="Price0 :", bg="slate gray", font='Helvetica 14')
        Price0.place(anchor='nw', relx=0.05, rely=0.45)

        Size0 = tk.Label(frame4, text="Size0 :", bg="slate gray", font='Helvetica 14')
        Size0.place(anchor='nw', relx=0.32, rely=0.45)

        EntryTime0 = tk.Label(frame4, text="EntryTime0 :", bg="slate gray", font='Helvetica 14')
        EntryTime0.place(anchor='nw', relx=0.63, rely=0.45)

        EntryType1 = tk.Label(frame4, text="EntryType1 :", bg="slate gray", font='Helvetica 14')
        EntryType1.place(anchor='nw', relx=0.05, rely=0.65)

        Price1 = tk.Label(frame4, text="Price1 :", bg="slate gray", font='Helvetica 14')
        Price1.place(anchor='nw', relx=0.32, rely=0.65)

        Size1 = tk.Label(frame4, text="Size1 :", bg="slate gray", font='Helvetica 14')
        Size1.place(anchor='nw', relx=0.63, rely=0.65)

        EntryTime1 = tk.Label(frame4, text="EntryTime1 :", bg="slate gray", font='Helvetica 14')
        EntryTime1.place(anchor='nw', relx=0.05, rely=0.85)

        SnapShot_Entry0 = tk.Entry(frame4, width=5, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][0])
        SnapShot_Entry0.place(anchor='nw', relx=0.23, rely=0.05)

        SnapShot_Entry1 = tk.Entry(frame4, width=10, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][1])
        SnapShot_Entry1.place(anchor='nw', relx=0.47, rely=0.05)

        SnapShot_Entry2 = tk.Entry(frame4, width=10, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][2])
        SnapShot_Entry2.place(anchor='nw', relx=0.77, rely=0.05)

        SnapShot_Entry3 = tk.Entry(frame4, width=3, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][3])
        SnapShot_Entry3.place(anchor='nw', relx=0.23, rely=0.25)

        SnapShot_Entry4 = tk.Entry(frame4, width=3, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][4])
        SnapShot_Entry4.place(anchor='nw', relx=0.5, rely=0.25)

        SnapShot_Entry5 = tk.Entry(frame4, width=3, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][5])
        SnapShot_Entry5.place(anchor='nw', relx=0.83, rely=0.25)

        SnapShot_Entry6 = tk.Entry(frame4, width=10, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][6])
        SnapShot_Entry6.place(anchor='nw', relx=0.17, rely=0.45)

        SnapShot_Entry7 = tk.Entry(frame4, width=5, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][7])
        SnapShot_Entry7.place(anchor='nw', relx=0.45, rely=0.45)

        SnapShot_Entry8 = tk.Entry(frame4, width=10, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][8])
        SnapShot_Entry8.place(anchor='nw', relx=0.83, rely=0.45)

        SnapShot_Entry9 = tk.Entry(frame4, width=3, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][9])
        SnapShot_Entry9.place(anchor='nw', relx=0.23, rely=0.65)

        SnapShot_Entry10 = tk.Entry(frame4, width=12, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][10])
        SnapShot_Entry10.place(anchor='nw', relx=0.45, rely=0.65)

        SnapShot_Entry11 = tk.Entry(frame4, width=10, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][11])
        SnapShot_Entry11.place(anchor='nw', relx=0.77, rely=0.65)

        SnapShot_Entry11 = tk.Entry(frame4, width=10, borderwidth=2, font="Calibri 12", textvariable=vDef_val[5][12])
        SnapShot_Entry11.place(anchor='nw', relx=0.23, rely=0.85)
    return None


def main():
    global root, canvas, frame1, frame2, frame3, frame4, frame5, vIPAddr, vPortServer,\
    vPortRTC, vDesIPAddr, var, vDef_val, FixHeader_Entry, vErrorOp, stop_threads, \
    threads, q

    stop_threads = threading.Event()
    stop_threads.clear()
    threads = []
    q = Queue(maxsize = 5)

    root = tk.Tk()

    canvas = tk.Canvas(root, height=1000, width=700, bg="gray80")
    canvas.pack()

    frame1 = tk.Frame(root, bg="slate gray")
    frame1.place(relwidth=0.9, relheight=0.4, relx=0.05, rely=0.05)

    frame5 = tk.Frame(frame1, bg="slate gray")
    frame5.place(relwidth=0.2, relheight=0.2, relx=0.8, rely=0)

    Label_Header_f1 = tk.Label(frame1, text="Network Interface", bg="slate gray", \
    font='Helvetica 18 bold')
    Label_Header_f1.place(anchor='nw', relx=0.05)

    # Create IP Addr Input
    vIPAddr = [tk.StringVar(frame1, value='192'), tk.StringVar(frame1, value='168'),\
               tk.StringVar(frame1, value='7'), tk.StringVar(frame1, value='25')]
    IPAddr_label = tk.Label(frame1, text="Input your IP Address :          .         .          .",\
    bg="slate gray", font='Helvetica 16')
    IPAddr_label.place(anchor='nw', relx=0.05, rely=0.15)

    IPAddr_Entry1 = tk.Entry(frame1, width=4, borderwidth=2, font="Calibri 14", textvariable=vIPAddr[0])
    IPAddr_Entry1.place(anchor='nw', relx=0.4, rely=0.15)

    IPAddr_Entry2 = tk.Entry(frame1, width=4, borderwidth=2, font="Calibri 14", textvariable=vIPAddr[1])
    IPAddr_Entry2.place(anchor='nw', relx=0.5, rely=0.15)

    IPAddr_Entry3 = tk.Entry(frame1, width=4, borderwidth=2, font="Calibri 14", textvariable=vIPAddr[2])
    IPAddr_Entry3.place(anchor='nw', relx=0.6, rely=0.15)

    IPAddr_Entry4 = tk.Entry(frame1, width=4, borderwidth=2, font="Calibri 14", textvariable=vIPAddr[3])
    IPAddr_Entry4.place(anchor='nw', relx=0.7, rely=0.15)

    # Create Server Port Addr Input
    vPortServer = tk.StringVar(frame1, value='25123')
    PortServerAddr_label = tk.Label(frame1, text="Input your Server Port Address :",\
    bg="slate gray", font='Helvetica 16')
    PortServerAddr_label.place(anchor='nw', relx=0.05, rely=0.3)

    PortServerAddr_Entry = tk.Entry(frame1, width=14, borderwidth=2, \
    font="Calibri 14", textvariable=vPortServer)
    PortServerAddr_Entry.place(anchor='nw', relx=0.543, rely=0.3)

    # Create RTC Message Port Addr Input
    vPortRTC = [tk.StringVar(frame1, value='1024'), tk.StringVar(frame1, value='63')]
    PortRTCAddr_label1 = tk.Label(frame1, text="Input your RTC Port Address",\
    bg="slate gray", font='Helvetica 16')
    PortRTCAddr_label1.place(anchor='nw', relx=0.05, rely=0.5)

    PortRTCAddr_label2 = tk.Label(frame1, text="Source :",\
    bg="slate gray", font='Helvetica 16')
    PortRTCAddr_label2.place(anchor='nw', relx=0.05, rely=0.65)

    PortRTCAddr_label3 = tk.Label(frame1, text="Destination :",\
    bg="slate gray", font='Helvetica 16')
    PortRTCAddr_label3.place(anchor='nw', relx=0.4, rely=0.65)

    RTCSouPort_Entry = tk.Entry(frame1, width=10, borderwidth=2, font="Calibri 14", textvariable=vPortRTC[0])
    RTCSouPort_Entry.place(anchor='nw', relx=0.2, rely=0.65)

    RTCDesPort_Entry = tk.Entry(frame1, width=10, borderwidth=2, font="Calibri 14", textvariable=vPortRTC[1])
    RTCDesPort_Entry.place(anchor='nw', relx=0.605, rely=0.65)

    # Create Target RTC IP Addr Input
    vDesIPAddr = [tk.StringVar(frame1, value='192'), tk.StringVar(frame1, value='168'),\
               tk.StringVar(frame1, value='7'), tk.StringVar(frame1, value='1')]
    DestIPAddr_label = tk.Label(frame1, text="Input Dest IP Address :         .         .          .",\
    bg="slate gray", font='Helvetica 16')
    DestIPAddr_label.place(anchor='nw', relx=0.05, rely=0.8)

    DestIPAddr_Entry1 = tk.Entry(frame1, width=4, borderwidth=2, font="Calibri 14", textvariable=vDesIPAddr[0])
    DestIPAddr_Entry1.place(anchor='nw', relx=0.4, rely=0.8)

    DestIPAddr_Entry2 = tk.Entry(frame1, width=4, borderwidth=2, font="Calibri 14", textvariable=vDesIPAddr[1])
    DestIPAddr_Entry2.place(anchor='nw', relx=0.5, rely=0.8)

    DestIPAddr_Entry3 = tk.Entry(frame1, width=4, borderwidth=2, font="Calibri 14", textvariable=vDesIPAddr[2])
    DestIPAddr_Entry3.place(anchor='nw', relx=0.6, rely=0.8)

    DestIPAddr_Entry4 = tk.Entry(frame1, width=4, borderwidth=2, font="Calibri 14", textvariable=vDesIPAddr[3])
    DestIPAddr_Entry4.place(anchor='nw', relx=0.7, rely=0.8)

    # Status
    serverStatus = tk.Label(frame1, text="ServerStatus :", bg="slate gray", font='Helvetica 16')
    serverStatus.place(anchor='nw', relx=0.65, rely=0.05)

    tk.Label(frame5, text="OFF", bg="slate gray", font='Helvetica 16').place(anchor='nw', relx=0.37, rely=0.28)

    CreateServer_button = tk.Button(frame1, text="Create\nServer", font='Helvetica 16 bold',\
    bd=5, command=Click_CreateServer)
    CreateServer_button.place(anchor='nw', relx=0.82, rely=0.16)

    CloseServer_button = tk.Button(frame1, text="Close\nServer", font='Helvetica 16 bold',\
    bd=5, command=Click_CloseServer)
    CloseServer_button.place(anchor='nw', relx=0.82, rely=0.4)

    RTCmessage_button = tk.Button(frame1, text="RTC\nPacket", font='Helvetica 16 bold',\
    bd=7, command=Click_RTCmessage)
    RTCmessage_button.place(anchor='nw', relx=0.815, rely=0.64)

    ###########################
    ## FIX Message
    frame2 = tk.Frame(root, bg="slate gray")
    frame2.place(relwidth=0.9, relheight=0.45, relx=0.05, rely=0.5)

    Label_Header_f2 = tk.Label(frame2, text="FIX Message Interface", bg="slate gray", \
    font='Helvetica 18 bold')
    Label_Header_f2.place(anchor='nw', relx=0.05)

    ## Header
    FixHeader = tk.Label(frame2, text="FIX Header", bg="slate gray", font='Helvetica 14 bold')
    FixHeader.place(anchor='nw', relx=0.05, rely=0.08)

    BeginStr = tk.Label(frame2, text="BeginStr :", bg="slate gray", font='Helvetica 14')
    BeginStr.place(anchor='nw', relx=0.05, rely=0.14)

    SeqNum = tk.Label(frame2, text="SeqNum :", bg="slate gray", font='Helvetica 14')
    SeqNum.place(anchor='nw', relx=0.30, rely=0.14)

    SendComID = tk.Label(frame2, text="SendComID :", bg="slate gray", font='Helvetica 14')
    SendComID.place(anchor='nw', relx=0.53, rely=0.14)

    TargComID = tk.Label(frame2, text="TargComID :", bg="slate gray", font='Helvetica 14')
    TargComID.place(anchor='nw', relx=0.05, rely=0.21)

    PossDup = tk.Label(frame2, text="PossDup :", bg="slate gray", font='Helvetica 14')
    PossDup.place(anchor='nw', relx=0.47, rely=0.21)

    ErrorOp = tk.Label(frame2, text="ErrorOp :", bg="slate gray", font='Helvetica 14')
    ErrorOp.place(anchor='nw', relx=0.69, rely=0.21)

    FixHeader_Entry = [tk.StringVar(frame2, value='FIXT.1.1'), tk.StringVar(frame2, value=''),
    tk.StringVar(frame2, value='SET'), tk.StringVar(frame2, value='15_FIX_MD50'), tk.StringVar(frame2, value='')]

    FixHeader_Entry0 = tk.Entry(frame2, width=7, borderwidth=2, font="Calibri 12", textvariable=FixHeader_Entry[0])
    FixHeader_Entry0.place(anchor='nw', relx=0.19, rely=0.14)

    FixHeader_Entry1 = tk.Entry(frame2, width=5, borderwidth=2, font="Calibri 12", textvariable=FixHeader_Entry[1])
    FixHeader_Entry1.place(anchor='nw', relx=0.45, rely=0.14)

    FixHeader_Entry2 = tk.Entry(frame2, width=13, borderwidth=2, font="Calibri 12", textvariable=FixHeader_Entry[2])
    FixHeader_Entry2.place(anchor='nw', relx=0.73, rely=0.14)

    FixHeader_Entry3 = tk.Entry(frame2, width=15, borderwidth=2, font="Calibri 12", textvariable=FixHeader_Entry[3])
    FixHeader_Entry3.place(anchor='nw', relx=0.24, rely=0.21)

    FixHeader_Entry4 = tk.Entry(frame2, width=3, borderwidth=2, font="Calibri 12", textvariable=FixHeader_Entry[4])
    FixHeader_Entry4.place(anchor='nw', relx=0.62, rely=0.21)

    vErrorOp = tk.StringVar(frame2, value='0')
    ErrorOp_Entry = tk.Entry(frame2, width=3, borderwidth=2, font="Calibri 12", textvariable=vErrorOp)
    ErrorOp_Entry.place(anchor='nw', relx=0.83, rely=0.21)

    ## frame 3 for selecting message type
    frame3 = tk.Frame(frame2, bg="dim gray")
    frame3.place(relwidth=0.9, relheight=0.1, relx=0.05, rely=0.3)


    # Logon => 4, HeartB or TestRq => 1, ResReq => 2
    # Reject => 5, SeqRst => 2, SnapShot => 13
    MessageType = ["Logon", "HeartB", "TestRq", "ResReq", \
                   "Reject", "SeqRst", "Logout", "Snapsh"]
    var = tk.IntVar()
    for value, text in enumerate(MessageType, start=1):
        tk.Radiobutton(frame3, text = text, variable = var, font='Helvetica 10', selectcolor="gray60",\
        value = value, indicator = 0, command=sel_change).place(anchor='nw', relx=0.05+0.12*(value-1), rely=0.22)

    # Creating Default text value of meesage
    # Index 0 =>        EncryptMethod                               HeartBtInt
    vDef_val = [[tk.StringVar(frame2, value='0'), tk.StringVar(frame2, value='30'),\
    #                   RstSeqNumFlag                               AppVerID
                tk.StringVar(frame2, value='Y'), tk.StringVar(frame2, value='9')],\
    # Index 1 =>        Text112
                [tk.StringVar(frame2, value='')],\
    # Index 2 =>        BeginSeqNum                 EndSeqNum
                [tk.StringVar(frame2, value=''), tk.StringVar(frame2, value='')],\
    # Index 3 =>        RefSeqNum                   RefTagID
                [tk.StringVar(frame2, value=''), tk.StringVar(frame2, value=''),\
    #                   RefMsgType                  ReajectReaon
                tk.StringVar(frame2, value=''), tk.StringVar(frame2, value=''),\
    #                   EncodedText
                tk.StringVar(frame2, value='ERROR')],\
    # Index 4 =>        GapFillFlag                 NewSeqNum
                [tk.StringVar(frame2, value='Y'), tk.StringVar(frame2, value='')],\
    # Index 5 =>        MDReqID                     Symbol
                [tk.StringVar(frame2, value='MA'), tk.StringVar(frame2, value='GULF'),\
    #                   SecID                       SecIDSrc
                 tk.StringVar(frame2, value='30037'), tk.StringVar(frame2, value='8'),\
    #                   NoEntries                   EntryType0
                 tk.StringVar(frame2, value='2'), tk.StringVar(frame2, value='0'),\
    #                   Price0                      Size0
                 tk.StringVar(frame2, value='9223372036854.775807'), tk.StringVar(frame2, value='1500'),\
    #                   EntryTime0                  EntryType1
                 tk.StringVar(frame2, value='04:55:21.029'), tk.StringVar(frame2, value='1'),\
    #                   Price1                      Size1
                 tk.StringVar(frame2, value='0.000001'), tk.StringVar(frame2, value='12000'),\
    #                   EntryTime1
                 tk.StringVar(frame2, value='04:45:00.000')]]

    ## frame 4 for each Message Type detail
    frame4 = tk.Frame(frame2, bg="slate gray")
    frame4.place(relwidth=1, relheight=0.4, relx=0, rely=0.42)

    FixMessage_button = tk.Button(frame2, text="Message Generating button", \
    font='Helvetica 16 bold', bd=5, command=Click_Fixmessage)
    FixMessage_button.place(anchor='nw', relx=0.27, rely=0.85)

    root.protocol("WM_DELETE_WINDOW", on_closing)
    root.mainloop()

if __name__ == "__main__" :
    main()
