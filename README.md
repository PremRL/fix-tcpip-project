# Design and Implementation of a FIX and TCP/IP protocol offload engines for SET Market Data on FPGA
 
This is a final-year project of an electrical engineering program (EE2102499) at Chulalongkorn university in the academic year 2020. We were interested in hardware design, specifically FPGA, with the focus on optimising network protocols. In this project, we present a FIX processor for SET Market Data and a TCP/IP offload engine for 1Gpbs Ethernet, and if you are interested in our publication, it can be found using this hyperlink [“Design and Implementation of a FIX Protocol Offload Engine for SET Market Data”](https://ieeexplore.ieee.org/abstract/document/10127033). 

### Contributors  
1. Norawit Kietthanakorn <br />
   Department of Electrical Engineering, Chulalongkorn University, Bangkok, Thailand <br />
   Email: Norawit.m@gmail.com

2. Ratchanon Leung-on <br />
   Department of Electrical Engineering, Chulalongkorn University, Bangkok, Thailand <br />
   Email: ratchanonleung.on@gmail.com

4. Boonchuay Supmonchai (Project advisor) <br />
   Department of Electrical Engineering, Chulalongkorn University, Bangkok, Thailand <br />
   Email: boonchuay.s@chula.ac.th 
 
We would like to thank “Design Gateway (Thailand)” for providing test environment and giving technical support. You can find them in the following link. 
[DesignGateway Co., Ltd.](https://dgway.com/index_E.html)
 
___
### DISCLAIMER  
WE MAKE NO CLAIMS, PROMISES OR GUARANTEES ABOUT THE ACCURACY, COMPLETENESS, OR ADEQUACY OF THE CONTENTS IN THIS PROJECT AND EXPRESSLY DISCLAIM LIABILITY FOR ERRORS AND OMISSIONS IN THE CONTENTS OF THIS PROJECT. NO WARANTY OF ANY KIND IS GIVEN WITH RESPECT TO THE CONTENTS IN THIS PROJECT AND OF THIS WEBSITE. ALL THE SOURCE CODE AND GUIDELINE PROVIDED IN THIS PROJECT ARE TO BE USED AT YOUR OWN RISK. <br /> <br />
YOU CAN USE THE CODES GIVEN IN THIS PROJECT FOR NON-COMMERCIAL PURPOSES WITHOUT OUR PERMISSION. BUT IF YOU ARE USING IT FOR COMMERCIAL PURPOSES THEN CONTACT US WITH THE DETAILS OF YOUR PROJECT FOR OUR PERMISSION. 
___
  
### Information about this project  
1. We are expecting people who will take part in this project to have basic knowledge in TCP/IP mechanism, ARP protocol, FIX specifications (FIXT 1.1 and FIX 5.0SP2), and hardware design (FPGA). 
2. Although the TCP/IP protocol can be easily found on the internet, we cannot provide the FIX specifications and their test sets due to a confidential issue. 
3. Our simulation tool is “ModelSim - INTEL FPGA STARTER EDITION 10.5b” with the additional requirement of “altera_mf” library. 
4. This project has been successfully compiled by “Quartus Prime Lite Edition 17.1” and tested on MAX10 FPGA Development Kit. 
5. This provided project contains only the hardware cores of our TCP/IP and FIX engines without their test system because their peripherals such as an Ethernet module are intellectual properties of Design Gateway (Thailand).
6. In this repository, we provide HDL codes for a FIX protocol processor and TCP/IP offload engine as well as Python codes as test software. 

#### HDL file structure
```
├───IP - IP cores used in an HDL project such as RAM and FIFO
├───Package - HDL files containing packages, singals and components for simulation
├───sim - ModelSim scripts for compling sources and adding waveform
├───source - HDL files of the project and may contain subdirectories
└───Testbench - Simulation HDL files for testing  
```


## FIX processor 



## TCP/IP offload engine


## Guideline for software testing


## Ending
