import datetime

def Enc(Str_in) :
    return Str_in.encode('latin-1')

def GetTimeStamp_str() :
    now = datetime.datetime.now()
    return now.strftime("%Y%m%d-%H:%M:%S.%f")[:-3]

# For HeaderRec :
# Index 0: Contain string of BeginString field
# Index 1: Contain string of MsgType
# Index 2: Contain string of Sequence number
# Index 3: Contain string of Sender computer ID
# Index 4: Contain string of Target computer ID
# Index 5: Contain string of PossDupFlag
def HeaderTrailerFix(Bodymessage, HeaderRec, ErrOp) :
    cAsciiSOH = Enc("\x01")
    Message = Enc("35=") + Enc(HeaderRec[1]) + cAsciiSOH \
                + Enc("34=") + Enc(HeaderRec[2]) + cAsciiSOH \
                + Enc("49=") + Enc(HeaderRec[3]) + cAsciiSOH \
                + Enc("56=") + Enc(HeaderRec[4]) + cAsciiSOH \
                + Enc("52=") + Enc(GetTimeStamp_str()) + cAsciiSOH
    if HeaderRec[5] :
        Message = Message + Enc("43=") + Enc(HeaderRec[5]) + cAsciiSOH
    if Bodymessage :
        Message = Message + Bodymessage

    # Writing BeginString and Bodylength tag
    # If Error op%2=1 : Bodylength error
    Message = Enc("8=") + Enc(HeaderRec[0]) + cAsciiSOH \
                + Enc("9=") + Enc(str(len(Message)+ErrOp%2)) + cAsciiSOH \
                + Message

    # Add Checksum
    # If Error op>=2 : Checksum error
    Checksum = sum([each_byte for each_byte in Message]) % 256
    Message = Message + Enc("10=") + Enc(str(Checksum + ErrOp//2).zfill(3)) + cAsciiSOH
    return Message

# MsgType(String) : 0 => Heartbeat, 1 => TestReq, 2=> ResendReq
#                   3 => Reject,    4 => SeqReset,5=> Logout
#                   A => Logon,     W => Snapshot
# DataRec
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
# In TestReq_HB : Text112 (0)
def main(DataRec, ErrOp) :
    cAsciiSOH = Enc("\x01")
    try :
        Bodymessage = str()
        if (DataRec[0][1]=='0' or DataRec[0][1]=='1') and DataRec[6][0] :
            Bodymessage = Enc("112=") + Enc(DataRec[6][0]) + cAsciiSOH
        elif DataRec[0][1]=="2" :
            Bodymessage = Enc("7=") + Enc(DataRec[2][0]) + cAsciiSOH \
                            + Enc("16=") + Enc(DataRec[2][1]) + cAsciiSOH
        elif DataRec[0][1]=="3" :
            Bodymessage = Enc("45=") + Enc(DataRec[3][0]) + cAsciiSOH \
                            + Enc("371=") + Enc(DataRec[3][1]) + cAsciiSOH \
                            + Enc("372=") + Enc(DataRec[3][2]) + cAsciiSOH \
                            + Enc("373=") + Enc(DataRec[3][3]) + cAsciiSOH
            # EncodedText : For testing Reject error
            if DataRec[3][4] :
                Bodymessage = Bodymessage + Enc("355=") + Enc(DataRec[3][4]) + cAsciiSOH
        elif DataRec[0][1]=="4" :
            Bodymessage = Enc("123=") + Enc(DataRec[4][0]) + cAsciiSOH \
                            + Enc("36=") + Enc(DataRec[4][1]) + cAsciiSOH
        elif DataRec[0][1]=="A" :
            Bodymessage = Enc("98=") + Enc(DataRec[1][0]) + cAsciiSOH \
                            + Enc("108=") + Enc(DataRec[1][1]) + cAsciiSOH \
                            + Enc("141=") + Enc(DataRec[1][2]) + cAsciiSOH \
                            + Enc("1137=") + Enc(DataRec[1][3]) + cAsciiSOH
        elif DataRec[0][1]=="W" :
            Bodymessage = Enc("262=") + Enc(DataRec[5][0]) + cAsciiSOH \
                            + Enc("55=") + Enc(DataRec[5][1]) + cAsciiSOH \
                            + Enc("48=") + Enc(DataRec[5][2]) + cAsciiSOH \
                            + Enc("22=") + Enc(DataRec[5][3]) + cAsciiSOH \
                            + Enc("268=") + Enc(DataRec[5][4]) + cAsciiSOH
            for i in range (int(DataRec[5][4])):
                Bodymessage = Bodymessage + Enc("269=") + Enc(DataRec[5][5+i*4]) + cAsciiSOH \
                                + Enc("270=") + Enc(DataRec[5][6+i*4]) + cAsciiSOH \
                                + Enc("271=") + Enc(DataRec[5][7+i*4]) + cAsciiSOH \
                                + Enc("273=") + Enc(DataRec[5][8+i*4]) + cAsciiSOH
    except :
        print ('Error: BodyMessage Record Incorrect')
        return None
    else :
        return HeaderTrailerFix(Bodymessage, DataRec[0], ErrOp)


if __name__ == "__main__" :
    Bodymessage = ""
    HeaderRec = ["FIXT.1.1", "A", "1", "15_FIX_MD50", "SET", ""]
    LogonRec = ['0', '30', 'Y', '9']
    ResentReqRec = ['2', '0']
    RejectRec = ['4', '355', '3', '0', '']
    SeqRstRec = ['Y', '36']
    SnapShotFullRec = ['MA', 'GULF', '30037', '8', '2', '0', '9223372036854.775807',\
                       '1500', '04:55:21.029', '1', '0.000001', '12000', '04:45:00.000']
    TestReq_HB = ["TestConn"]
    DataRec = [HeaderRec, LogonRec, ResentReqRec, RejectRec,
               SeqRstRec, SnapShotFullRec, TestReq_HB]
    MsgType = ['0', '1', '2', '3', '4', '5', 'A', 'W']
    ErrOp = 0

    for each_type in MsgType :
        DataRec[0][1] = each_type
        print("Message Type = "+each_type+" ==> ", main(DataRec, ErrOp))

    print("\n\n")
    HeaderRec = ["FIXT.1.1", "0", "1", "15_FIX_MD50", "SET", "Y"]
    DataRec = [HeaderRec, LogonRec, ResentReqRec, RejectRec,
               SeqRstRec, SnapShotFullRec, TestReq_HB]
    print("PossDupFlag set ==> ", main(DataRec, ErrOp))

    print("\n\n")
    HeaderRec = ["FIXT.1.1", "0", "1", "15_FIX_MD50", "SET", ""]
    DataRec = [HeaderRec, LogonRec, ResentReqRec, RejectRec,
               SeqRstRec, SnapShotFullRec, TestReq_HB]
    DataRec[6] = []
    print("112 not send ==> ", main(DataRec, ErrOp))

    print("\n\n")
    HeaderRec = ["FIXT.1.1", "W", "1", "15_FIX_MD50", "SET", ""]
    SnapShotFullRec = ['MA', 'GULF', '30037', '8', '1', '0', '9223372036854.775807',\
                       '1500', '04:55:21.029', '1', '0.000001', '12000', '04:45:00.000']
    DataRec = [HeaderRec, LogonRec, ResentReqRec, RejectRec,
               SeqRstRec, SnapShotFullRec, TestReq_HB]
    print("Entries=1 ==> ", main(DataRec, ErrOp))
