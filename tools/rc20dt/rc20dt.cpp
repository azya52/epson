#include <iostream>
#include <stdlib.h>
#include <unistd.h>
#include "SerialPort.h"

bool send(SerialPort *comPort, FILE *source, bool header){
	fseek(source, 0, SEEK_END);
	uint16_t fileSize = ftell(source);
	rewind(source);

	char *buffer = new char[fileSize];
    if (fread (buffer,1,fileSize,source) != fileSize) {
        std::cout << "File read error\n";
        delete [] buffer;
        return false;
    }
    
    int headerSize = 0;
	if(header){
		headerSize = 22;
	}
	int rcFileSize = headerSize + fileSize;
    char headerData[22] = {0x01, 0x00, 0x00, rcFileSize & 0xFF, rcFileSize >> 8, 0x16, 0x00, 0x00, 0x00, 0x00,
							0x02, 0x16, 0x00, rcFileSize & 0xFF, rcFileSize >> 8, 0x00,};
							 
	char *rcData = new char[rcFileSize];
	char data;
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

bool read(SerialPort *comPort, FILE *output){
	int bufferSize = 256;
	char *buffer = new char[bufferSize];
	int bytesRead = 0;
	int bytesReadAll = 0;
	std::cout << "Waiting data from RC-20...\n";
	while (bytesReadAll==0 || bytesRead>0) {
        bytesRead = comPort->readSerialPort(buffer, bufferSize);
		if(bytesRead!=0){
			if(fwrite(buffer, 1, bytesRead, output)==0){
				delete [] buffer;
				return false;
			}
			bytesReadAll += bytesRead;
			std::cout << "Received: " << bytesReadAll << "B\r";
		}
	} 
	std::cout << "Received: " << bytesReadAll << "B\n";
	delete [] buffer;
	return true;
}

int main(int argc, char *argv[]) {
	if (argc <= 1) {
		std::cout << "Usage: \n\t rc20dt [-r] [-p <port name>] [-d] <file name>\n\n";
		std::cout << "\t\t -p <port name>\t connect to specified port\n";
		std::cout << "\t\t -d\t\t do not add header\n";
		std::cout << "\t\t -r\t\t receive data from the watch to the <file name>\n";
		return 0;
	}

	int boudRate = 2400;
	char portName[13] = "\\\\.\\COM1";
	bool header = true;
	bool readFile = false;
	
	char *opts = (char *)"rdp:";
	int opt;
	while ((opt = getopt(argc, argv, opts)) != -1) {
		switch (opt) {
			case 'p': 
				strncpy(portName+4, optarg, 5);
				break;
			case 'd':
				header = false;
				break;
			case 'r':
				readFile = true;
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
	
	if((inputFilesCount>0) && (inputFiles[0] != NULL)){
		FILE *file;
		if(!readFile){
			if ((file = fopen(inputFiles[0], "rb")) != NULL) {
				if(send(comPort, file, header)){
					std::cout << "Send complete";
				}
			} else {
				std::cout << "Could not open file \"" << inputFiles[0] << "\"";
				comPort->~SerialPort();
				exit(EXIT_FAILURE);
			}
		} else {
			if ((file = fopen(inputFiles[0], "wb")) != NULL) {
				if(read(comPort, file)){
					std::cout << "Read complete";
				}
			} else {
				std::cout << "Could not create file \"" << inputFiles[0] << "\"";
				comPort->~SerialPort();
				exit(EXIT_FAILURE);
			}
		}
		fclose(file);
	} else {
		std::cout << "<file name> must be specified";
	}
	
	comPort->~SerialPort();
	return 0;
}