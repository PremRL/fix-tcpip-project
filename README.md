# Design and Implementation of a FIX and TCP/IP protocol offload engines for SET Market Data on FPGA
 
This project, undertaken as part of the final-year requirements for the electrical engineering program (EE2102499) at Chulalongkorn University in the academic year 2020, concentrates on digital hardware design, specifically FPGA, with a keen focus on optimising network protocols. Our efforts resulted in the development of a FIX processor for SET Market Data and a TCP/IP offload engine for 1Gbps Ethernet. If you are intrigued by our work and intend to explore further, our publication titled ['Design and Implementation of a FIX Protocol Offload Engine for SET Market Data'](https://ieeexplore.ieee.org/abstract/document/10127033) is available through the hyperlink.

### Contributors  
1. Mr. Norawit Kietthanakorn <br />
   Department of Electrical Engineering, Chulalongkorn University, Bangkok, Thailand <br />
   Email: Norawit.m@gmail.com

2. Mr. Ratchanon Leung-on <br />
   Department of Electrical Engineering, Chulalongkorn University, Bangkok, Thailand <br />
   Email: ratchanonleung.on@gmail.com

4. Mr. Boonchuay Supmonchai (Project advisor) <br />
   Department of Electrical Engineering, Chulalongkorn University, Bangkok, Thailand <br />
   Email: boonchuay.s@chula.ac.th 
 
We would like to extend our gratitude to “Design Gateway (Thailand)” for generously providing the test environment and offering technical support throughout our project. More information about them can be found at the following link. 
[DesignGateway Co., Ltd.](https://dgway.com/index_E.html)
 
___
### DISCLAIMER  
WE MAKE NO CLAIMS, PROMISES, OR GUARANTEES ABOUT THE ACCURACY, COMPLETENESS, OR ADEQUACY OF THE CONTENTS IN THIS PROJECT. WE EXPRESSLY DISCLAIM LIABILITY FOR ERRORS AND OMISSIONS IN THE CONTENTS OF THIS PROJECT. NO WARRANTY OF ANY KIND IS GIVEN WITH RESPECT TO THE CONTENTS IN THIS PROJECT AND OF THIS WEBSITE. ALL THE SOURCE CODE AND GUIDELINES PROVIDED IN THIS PROJECT ARE TO BE USED AT YOUR OWN RISK. <br /> <br />
YOU CAN USE THE CODES GIVEN IN THIS PROJECT FOR NON-COMMERCIAL PURPOSES WITHOUT OUR PERMISSION. BUT IF YOU ARE USING IT FOR COMMERCIAL PURPOSES, THEN CONTACT US WITH THE DETAILS OF YOUR PROJECT FOR OUR PERMISSION. 
___
  
### Information about this project  
1. Participation in this project requires a foundational understanding of TCP/IP mechanisms, ARP protocol, FIX specifications (FIXT 1.1 and FIX 5.0SP2), and hardware design (FPGA). 
2. While the TCP/IP protocol details are readily available on the internet, we regret to inform you that we cannot provide the FIX specifications and their test sets due to confidentiality reasons. 
3. For simulation purposes, we used “ModelSim - INTEL FPGA STARTER EDITION 10.5b” with the additional requirement of the “altera_mf” library. 
4. This project was successfully compiled by “Quartus Prime Lite Edition 17.1” and tested on MAX10 FPGA Development Kit. 
5. The provided project includes only the hardware cores of our TCP/IP and FIX engines. The test system is not included as their peripherals, such as the Ethernet module, are intellectual properties of Design Gateway (Thailand).
6. The repository includes HDL codes for a FIX protocol processor and TCP/IP offload engine, along with Python codes for testing. 

#### HDL file structure
```
├───IP - IP cores used in an HDL project (e.g., RAM and FIFO)
├───Package - HDL files containing packages, singals and components for simulation
├───sim - ModelSim scripts for compling sources and adding waveform
├───source - HDL files of the project and may contain subdirectories
└───Testbench - Simulation HDL files for testing
```


## FIX processor 



## TCP/IP offload engine


## Guideline for software testing


## Ending
