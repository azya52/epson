#include <iostream>
#include <stdlib.h>
#include <unistd.h>
#include "SerialPort.h"

bool send(SerialPort *comPort, FILE *source){
	fseek(source, 0, SEEK_END);
	uint16_t fileSize = ftell(source);
	rewind(source);

	char *buffer = new char[fileSize];
    if (fread (buffer,1,fileSize,source) != fileSize) {
        std::cout << "File read error";
        delete [] buffer;
        return false;
    }
    
	int headerSize = 22;
	int rcFileSize = headerSize + fileSize;
	char *rcData = new char[rcFileSize];
	char headerData[22] = {0x01, 0x00, 0x00, rcFileSize & 0xFF, rcFileSize >> 8, 0x16, 0x00, 0x00, 0x00, 0x00,
							 0x02, 0x16, 0x00, rcFileSize & 0xFF, rcFileSize >> 8, 0x00,};
							 
 

	memcpy(rcData, headerData, headerSize);
	memcpy(rcData+headerSize, buffer, fileSize);

	for(int i=0; i<rcFileSize; i++){
	    if(comPort->writeSerialPort(rcData+i, 1)) {
	        std::cout << (int)(i/(double)rcFileSize*100) << "%\r";
	    } else {
	        std::cout << "Data send error";
	        delete [] buffer;
	        delete [] rcData;
	        return false;
	    }
		Sleep(5);
    }
    
    delete [] buffer;
    delete [] rcData;
    return true;
}

int main(int argc, char *argv[]) {
	if (argc <= 1) {
		printf("Usage: \n\t rc20dt [-p <port name>] <file name>\n");
		return 0;
	}

	int boudRate = 2400;
	char portName[13] = "\\\\.\\COM1";

	char *opts = (char *)"p:";
	int opt;
	while ((opt = getopt(argc, argv, opts)) != -1) {
		switch (opt) {
			case 'p': 
				strncpy(portName+4, optarg, 5);
				break;
		}
	}
	
	char **inputFiles = argv + optind;
	int inputFilesCount = argc - optind;

	std::cout << "Connect to RC20 on port " << portName << " with " << boudRate << " boud rate...\n";

	SerialPort *comPort = new SerialPort(portName, boudRate);
	if (comPort->isConnected()) {
		std::cout << "Connection Established\n";
	} else {
		std::cout << "Check port name\n";
		exit(EXIT_FAILURE);
	}
	
	if(inputFilesCount>0){
		FILE *source;
		if (inputFiles[0] == NULL || (source = fopen(inputFiles[0], "rb")) == NULL) {
			std::cout << "Could not open file \"" << inputFiles[0] << "\"";
			comPort->~SerialPort();
			exit(EXIT_FAILURE);
		}
		if(send(comPort, source)){
			std::cout << "Send complete";
		}
		fclose(source);
	}	
	
	comPort->~SerialPort();
	return 0;
}