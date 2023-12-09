import pandas
import time
import sys
import random

class DataManaging:
  def __init__(self, IndLen, args=(), kwargs=None):
    self.IndLen = IndLen
    self.RdFilepath = args[0]
    self.RdFilename = args[1]
    self.RdFile1stNum = int(args[2])
    self.RdFileLastNum = int(args[3])
    self.HeaderName = args[4] # Index (Read file), Value (Read file), Value (Write file)

  def run(self):
    ValWithCorrectIndex = list()
    # randomly open file
    RandNumber = [i for i in range (self.RdFile1stNum, self.RdFileLastNum+1)]
    random.shuffle(RandNumber)
    for FileNum in RandNumber:
      #open csv file with pandas to DataFrame
      try :
        DataFromFile = pandas.read_csv(self.RdFilepath+self.RdFilename+str(FileNum)+'.csv')
      except :
        print('Error Message : Cannot read file')
        sys.exit()
      ValList = [DataFromFile[self.HeaderName[1]][i] for i,Value in \
              enumerate(DataFromFile[self.HeaderName[0]]) if self.IndLen==Value]
      ValWithCorrectIndex.extend(ValList)
      # Checking if len >= 100
      if len(ValWithCorrectIndex)>500:
          return ValWithCorrectIndex
    #ValWithCorrectIndex.sort()
    return ValWithCorrectIndex

class DataIntegrate:
    def __init__(self, args=(), kwargs=None):
        self.RdFilepath = args[0]
        self.RdFilename = args[1]
        self.RdFile1stNum = int(args[2])
        self.RdFileLastNum = int(args[3])
        self.WrFilePath = args[4]
        self.WrFileName = args[5]

    def run(self):
        # Correct data every file
        FileNum = self.RdFile1stNum
        # 1st create file
        DataFromFile = pandas.read_csv(self.RdFilepath+self.RdFilename+str(FileNum)+'.csv')
        DataFromFile = DataFromFile.loc[:, ~DataFromFile.columns.str.contains('^Unnamed')]
        DataFromFile.to_csv(self.WrFilePath+self.WrFileName+'.csv')
        for FileNum in range (self.RdFile1stNum+1, self.RdFileLastNum+1):
            DataFromFile = pandas.read_csv(self.RdFilepath+self.RdFilename+str(FileNum)+'.csv')
            DataFromFile = DataFromFile.loc[:, ~DataFromFile.columns.str.contains('^Unnamed')]
            DataFromFile.to_csv(self.WrFilePath+self.WrFileName+'.csv', mode='a', header=False)
        print("Message : File write completed!")
        return None

def main(RdFilePath, RdFileName, RdFileStartNum, RdFileEndNum, WrFilePath,\
       WrTempFileName, WrResultFileName, StartIndex, EndIndex, Head_name, NumberofSample, SeedNum):
  ListNum = list()
  Verify = True

  startnum = 1
  # ## Integrated file !!
  # for FileNum in range (startnum, (RdFileEndNum//100)+1):
  #     EndNum = FileNum*100 if FileNum!=RdFileEndNum//100 else RdFileEndNum
  #     Process = DataIntegrate(args=(RdFilePath, RdFileName, ((FileNum-1)*100)+1, EndNum,\
  #                               WrFilePath, WrTempFileName+str(FileNum)))
  #     Process.run()
  #     print('Message : running through file number :', EndNum)
  EndNum = 16

  # Initate output buffer
  DataTable = {i:[] for i in range (StartIndex, EndIndex+1)}
  random.seed(SeedNum)
  for Index in range (StartIndex, EndIndex+1):
    start_time = time.process_time()
    Process = DataManaging(Index, args=(WrFilePath, WrTempFileName, startnum,\
                           EndNum, Head_name))
    # randomly selected 100 sample from the list
    ValList = Process.run()
    random.shuffle(ValList)
    DataTable[Index] = ValList[:NumberofSample]
    print('Message : Sampling index number', Index, 'Completed')
    end_time = time.process_time()
    print("Process time each loop:", end_time - start_time)
  # Writing output file
  df = pandas.DataFrame(data=DataTable)
  df.to_csv(WrFilePath+WrResultFileName+'.csv')
  print('Message : completed successfully')
  return None

if __name__=="__main__":
  RdFilePath = ''
  RdFileName = 'RxTCPLT_2_'
  RdFileStartNum = 1
  RdFileEndNum = 1638 #1638
  WrFilePath = '' 
  WrTempFileName = 'RxTCPLT_Integrated_' # RxTCPLT_Integrated_
  WrResultFileName = 'RxTCPLT_Result'
  StartIndex = 1
  EndIndex = 8960 #8960
  Head_name = ['Payload Length', 'Clk cycle', 'Time (ClkCycle)']
  NumberofSample = 100
  SeedNum = 543
  start_time = time.process_time()
  main(RdFilePath, RdFileName, RdFileStartNum, RdFileEndNum, WrFilePath,\
       WrTempFileName, WrResultFileName, StartIndex, EndIndex, Head_name, NumberofSample, SeedNum)
  end_time = time.process_time()
  print("Process time :", end_time - start_time)
  print('Closed!!')
