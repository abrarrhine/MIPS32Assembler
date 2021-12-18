#! /bin/bash
#
#  Warning:  modifying this script would very likely defeat the purpose of having
#            it supplied to you.
#
#  This script can be used to test and grade your solution for the MIPS assembler
#  assignment.  This is the script we will use to do that, so if your tar file
#  does not work for you with this script, it won't work for us either.
#  That would be unfortunate.
#
#  Invoke as:  ./gradeC02.sh [ -m1 | -m2 | -final ] <name of submission tar file>
#              -m1 selects the tests for milestone 1
#              -m2 selects the tests for milestone 2
#              -final selects the tests for the final submission
#              -ec selects the tests for the extra-credit option (only) 
#              We suggest you name your tar file PID.tar, where PID is
#              your VT email pid (e.g., wmcquain.tar).
#
#
#  Last modified:  Sept 26, 2021
#
#  To use this test script:
#     - Untar the distributed testing tar file into a directory; that should
#       create the following directory structure:
#
#          ./gradeC02.sh              - this script file
#          ./compare                  - 64-bit CentOS 8 utility for checking results
#          ./milestone1/m1testxx.asm  - MIPS files to be assembled
#          ./milestone1/m1testxx.o    - reference translations 
#          ./milestone2/m2testxx.asm  - MIPS files to be assembled
#          ./milestone2/m2testxx.o    - reference translations 
#          ./final/ftestxx.asm        - MIPS files to be assembled
#          ./final/ftestxx.o          - reference translations
#
#       We will refer to the extraction directory as the test directory.
#     - Set execute permissions for grade.sh.
#     - Prepare the tar file you intend to submit and place it into the same
#       directory as gradeC02.sh.
#     - Execute the grading script command as described above.
#
#     gradeC03.sh will create a subdirectory, ./build, unpack your submission tar
#     file into it, and use your makefile to build the specified target,
#     "assemble".
#
#     If there is no makefile, the script will exit with an error message.
#
#     The script will then check for the existence of the specified executable,
#     "assemble".  If there is no such file, the script will exit with an error
#     message.  Otherwise, the  script will move the executable "assemble" into
#     the test directory, and execute it on each of the asm files in the
#     appropriate directory.  For each test case, the script will use the compare
#     utility to compare your translation to the reference translation, producing
#     a score for each test case.
#
#     If -final is selected, there is additional testing:
#        -  symbol table generation is tested
#        -  Valgrind analysis is run on a single test case
#        -  a test is run for the extra-credit option
#
#  Exit codes:
#     0   -  normal execution; no major errors were detected
#     1   -  wrong number of command-line parameters
#     2   -  invalid switch used on command-line
#     3   -  something is missing from test file directory
#     4   -  file named on command line does not exist
#     5   -  file named on command line is not a tar file
#     6   -  tar file does not contain a makefile
#     7   -  build failed
#     8   -  build produced nonexecutable file (unlikely)
#
# Configuration variables:
#
#   Names for directories
buildDir="build"

#   Flag for testing control
runEC="no"

#   Names for log files created by this script:
buildLog="buildLog.txt"
testLog="testLog.txt"

#   Name for the specified make target and executable
makeTarget="assembler"
exeName="assemble"

#   Delimiter to separate sections of report file:
Separator="============================================================"

#   Set results file names
testLog=testing_details.txt
summaryLog=testing_summary.txt

##################################### fn to check existence of test data
#                 param1:  -m1 or -m2 or -final or -ec
testsOK() {
	
	if [[ $1 == "-m1" ]]; then
	   nCases=3
	   testDataDir="milestone1"
      #   Set array of names of test input files
      asmFileNames=("m1test01.asm" "m1test02.asm" "m1test03.asm")
      #   Set array of names of reference object files
      refFileNames=("m1test01.o" "m1test02.o" "m1test03.o")
      #    Set array of names of assembler-produced student object files
      stuFileNames=("m1stu01.o" "m1stu02.o" "m1stu03.o")
	elif [[ $1 == "-m2" ]]; then
	   nCases=5
	   testDataDir="milestone2"
      #   Set array of names of test input files
      asmFileNames=("m2test01.asm" "m2test02.asm" "m2test03.asm" "m2test04.asm" "m2test05.asm")
      #   Set array of names of reference object files
      refFileNames=("m2test01.o" "m2test02.o" "m2test03.o" "m2test04.o" "m2test05.o")
      #    Set array of names of assembler-produced student object files
      stuFileNames=("m2stu01.o" "m2stu02.o" "m2stu03.o" "m2stu04.o" "m2stu05.o")
	elif [[ $1 == "-final" ]]; then
	   nCases=10
	   testDataDir="final"
      #   Set array of names of test input files
      asmFileNames=("ftest01.asm" "ftest02.asm" "ftest03.asm" "ftest04.asm" "ftest05.asm" "ftest06.asm" "ftest07.asm" "ftest08.asm" "ftest09.asm" "ftest10.asm")
      #   Set array of names of reference object files
      refFileNames=("ftest01.o" "ftest02.o" "ftest03.o" "ftest04.o" "ftest05.o" "ftest06.o" "ftest07.o" "ftest08.o" "ftest09.o" "ftest10.o")
      #    Set array of names of assembler-produced student object files
      stuFileNames=("fstu01.o" "fstu02.o" "fstu03.o" "fstu04.o" "fstu05.o" "fstu06.o" "fstu07.o" "fstu08.o" "fstu09.o" "fstu10.o")
   else
      echo "Unknown option: $1"
      return 1 
   fi
	
	if [[ ! -d ./$testDataDir ]]; then
	   echo "Test data directory does not exist!"
	   echo "Download a fresh copy of the tar file and try again."
	   return 1
	fi
	
	for fName in ${asmFileNames[@]}
	do
	   if [[ ! -e "./$testDataDir/$fName" ]]; then
	      echo "$fName is not in the test data directory!"
	      echo "Download a fresh copy of the tar file and try again."
	      return 2
	   fi
	done
	
	for fName in ${refFileNames[@]}
	do
	   if [[ ! -e "./$testDataDir/$fName" ]]; then
	      echo "$fName is not in the test data directory!"
	      echo "Download a fresh copy of the tar file and try again."
	      return 2
	   fi
	done
	return 0
}

############################################# fn to check for tar file
#                 param1:  name of file to be checked
isTar() {

   mimeType=`file -b --mime-type $1`
   if [[ $mimeType == "application/x-tar" ]]; then
     return 0
   fi
   if [[ $mimeType == "application/x-gzip" ]]; then
     return 0
   fi
   return 1
}

##################################### fn to extract token from file name
#                 param1: (possibly fully-qualified) name of file
#  Note:  in production use, the first part of the file name will be the
#         student's PID
#
getPID() { 

   fname=$1
   # strip off any leading path info
   fname=${fname##*/}
   # extract first token of file name
   spid=${fname%%.*}
}

###################################### clean up old test files
clean() {
   rm -Rf build         # delete build directory
   rm -f *.o            # delete old student object files, or stray ones
   rm -f *.txt          # delete any old report files
   rm -f assemble       # delete old assembler executable
   
   exit 0
}

############################################################ Choose test data directory
   
   # Check number of command-line parameters
   if [[ $# -eq 1 && $1 == "-clean" ]]; then
      clean
   fi
   
   if [[ $# -ne 2 ]]; then
      echo "Invocations:  gradeC02.sh [-m1 | -m2 | -final] [name of submitted tar file]"
      echo "              gradeC02.sh -clean"
      exit 1
   fi
   
   if [[ $1 == "-m1" ]]; then
      echo "Running tests for milestone 1."
      testDataDir="./milestone1"
   elif [[ $1 == "-m2" ]]; then
      echo "Running tests for milestone 2."
      testDataDir="./milestone2"
   elif [[ $1 == "-final" ]]; then
      echo "Running tests for final submission."
      testDataDir="./final"
   else
      echo "Unknown option: $1"
      exit 2
   fi

############################################################ Validate environment

   # Check for valid test data subdirectory:
   testsOK $1
   if [[ ! $? -eq 0 ]]; then
      echo "The test data directory does not exist, or its contents are not valid."
      echo "Fix this error."
      exit 3
   fi
   
############################################################ Validate command line

   # Verify presence of named file
   tarFile="$2"
   tarFile=${tarFile##*/}
   if [ ! -e $tarFile ]; then
      echo "The file $tarFile does not exist."      exit 4
   fi

   # Verify parameter is really a tar file
   isTar "$tarFile"
   if [[ ! $? -eq 0 ]]; then
      echo "The file $tarFile is not a valid tar file."
      exit 5
   fi
   
############################################################ Get student's PID
   
   # Extract first token of tar file name (student PID when we run this)
   getPID $tarFile
   
   # Initiate header for grading log
   headerLog="header.txt"
   echo "Grading:  $2" > $headerLog
   echo -n "Time:     " >> $headerLog
   echo `date` >> $headerLog
   echo "Option:   $1" >> $headerLog
   echo >> $headerLog
   
################################################### Clean up the test directory

   # Remove pre-existing assembler executable from test directory
   if [[ -e assemble ]]; then
      rm -f assemble
   fi
   
   # Remove any old student object files and assembler executable
   rm -f ./*.o
   rm -f ./$exeName
   
############################################################ Prepare for build
  
   # Create log file:
   echo "Executing grade.sh..." > $buildLog
   echo >> $buildLog
   
   # Create build directory:
   echo "Creating build subdirectory" >> $buildLog
   echo >> $buildLog
   # Create build directory if needed; empty it if it already exists
   if [[ -d $buildDir ]]; then
      rm -Rf ./$buildDir/*
   else
      mkdir $buildDir
   fi
   
   # Extract student's tar file to the build directory
   echo "Extracting student's files to the build directory:" >> $buildLog
   tar xvf $tarFile -C ./$buildDir >> $buildLog
   echo >> $buildLog

   # Move to build directory
   cd ./build
   # Verify we have a makefile
   gotMakefile="yes"
   if [[ ! -e makefile ]] && [[ ! -e Makefile ]] && [[ ! -e GNUmakefile ]]; then
      echo "There is no makefile in the build directory" >> ../$buildLog
      gotMakefile="no"
      #echo $Separator >> ../$buildLog
      #mv ../$buildLog ../$spid.txt
      #exit 6
   fi
   # Verify we have a pledge file
   if [[ ! -e pledge.txt ]]; then
      echo "Missing pledge file" >> ../$buildLog
   fi
   # Remove extraneous files from build directory
   if [[ -e assemble ]]; then
      echo "Deleting prebuilt assembler" >> ../$buildLog
      rm -f assemble
   fi
   if [[ -e *.o ]]; then
      echo "Deleting extraneous object files" >> ../$buildLog
      rm -f *.o
   fi
   
############################################################ Build the assembler

   # build the assembler; save output in build log
   if [[ $gotMakefile == "yes" ]]; then
      echo "Invoking:  make $makeTarget" >> ../$buildLog
      make $makeTarget >> ../$buildLog 2>&1
      echo >> ../$buildLog
      if [[ ! -e $exeName ]]; then
         echo "$exeName was not found... trying make with default target..." >> ../$buildLog
         # try to make a default target
         make
         if [[ ! -e $exeName ]]; then
            echo "That failed; the file $exeName does not exist" >> ../$buildLog
            echo $Separator >> ../$buildLog
         else
            echo "Attempting to build w/o a makefile; penalty will be 20%." >> ../$buildLog
            gcc -o $exeName -std=c99 -Wall -ggdb3 *.c >> ../$buildLog 2>&1
         fi
      fi
   else
      echo "ERROR:  no makefile found! " >> ../$buildLog
      echo "Attempting to build w/o a makefile; penalty will be 20%." >> ../$buildLog
      gcc -o $exeName -std=c11 -Wall -ggdb3 *.c >> ../$buildLog 2>&1
   fi

   # Verify existence of executable
   if [[ ! -e $exeName ]]; then
      echo "I give up... cannot build $exeName..." >> ../$buildLog
      mv ../$buildLog ../$spid.txt
      exit 7
   fi
   
   if [[ ! -x assemble ]]; then
      echo "Permissions error; the file $exeName is not executable" >> ../$buildLog
      echo $Separator >> ../$buildLog
      mv ../$buildLog ../$spid.txt
      exit 8
   fi

   echo "Build succeeded..." >> $buildLog
   
   # Check for 32-bit executable and issue warning
   file ./$exeName | grep "32-bit"
   if [[ $? -eq 0 ]]; then
      warningLog="warningLog.txt"
      echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $warningLog
      echo "Warning:  $exeName apears to be a 32-bit executable." >> $warningLog
      echo "This will interfere with the valgrind checks, and affect your score." >> $warningLog
      echo "We strongly suggest you remove -m32 from your makefile." >> $warningLog
      echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $warningLog
      echo >> $warningLog
      cat $warningLog >> ../$headerLog
      echo
      cat $warningLog
      rm -f $warningLog
   fi
   
   # Move executable up to test directory and return there
   echo "Moving the executable $exeName to the test directory." >> $buildLog
   mv ./$exeName .. >> $buildLog
   cd .. >> $buildLog
   
   # Delimit this section of the report file:
   echo $Separator >> $buildLog

############################################################ Perform testing

   # Initiate test Log
   echo "Begin running test cases..." > $testLog
   echo >> $testLog

   # perform testing
   index=0
   
   ############################## run the assemble test cases
   while [ "$index" -lt "$nCases" ]
   do
      asmToProcess=$testDataDir/${asmFileNames[$index]}
      refObjectFile=$testDataDir/${refFileNames[$index]}
      stuObjectFile=${stuFileNames[$index]}

      ((index +=1))
      echo "Beginning test case $index" >> $testLog

      # verify existence of current test file and reference file
      if [ ! -e $asmToProcess ]; then
         echo "The test file $asmToProcess is not present" >> $testLog
         continue
      fi
      if [ ! -e $refObjectFile ]; then
         echo "The reference file $refObjectFile is not present" >> $testLog
         continue
      fi
      # write-protect test files
      chmod a-w $asmToProcess
      chmod a-w $refObjectFile

      # run assembler on current test file
      echo "Running assembler on $asmToProcess" >> $testLog
      timeout -s SIGKILL 30 ./$exeName $asmToProcess $stuObjectFile >> $testLog
		if [[ $timeoutStatus -eq 124 || $timeoutStatus -eq 137 ]]; then
			echo "The test of your solution timed out after 30 seconds." >> $testLog
			echo "Valgrind testing will NOT be done." >> $testLog
			killed="yes"
		elif [[ $timeoutStatus -eq 134 ]]; then
			echo "The test of your solution was killed by a SIGABRT signal." >> $testLog
			echo "Possible reasons include:" >> $testLog
			echo "    - a segfault error" >> $testLog
			echo "    - a serious memory access error" >> $testLog
			echo "Valgrind testing will NOT be done." >> $testLog
			killed="yes"
		fi

      # remove write-protection from test files
      chmod u+w $asmToProcess
      chmod u+w $refObjectFile

      # verify existence of a nonempty student object file
      if [ ! -s $stuObjectFile ]; then
         echo "The object file $stuObjectFile was not produced or is empty" >> $testLog
         echo >> $testLog
         continue
      fi

      # run comparator
      echo "Running compare on $stuObjectFile and $refObjectFile" >> $testLog
      ./compare $index $stuObjectFile $refObjectFile >> $testLog
      echo >> $testLog
   done

############################################################ Run valgrind check

   if [[ $1 == "-final" ]]; then
      
      #echo "Running valgrind test"
      
	   # run test 7 on valgrind
	   #   full valgrind output is in $vgrindLog
	   #   extracted counts are in $vgrindIssues
	   vgrindLog="vgrindLog.txt"
	   echo "Running valgrind test..." >> $vgrindLog
	   vgrindSwitches=" --leak-check=full --show-leak-kinds=all --log-file=$vgrindLog --track-origins=yes -v"
	   scoreResultsLog2="ScoresValgrind.txt"
	   timeout -s SIGKILL 30 valgrind $vgrindSwitches ./assemble ./final/ftest07.asm ./fstu07.o
		if [[ $timeoutStatus -eq 124 || $timeoutStatus -eq 137 ]]; then
			echo "The test of your solution timed out after 30 seconds." >> $testLog
			echo "Valgrind testing will NOT be done." >> $testLog
			killed="yes"
		elif [[ $timeoutStatus -eq 134 ]]; then
			echo "The test of your solution was killed by a SIGABRT signal." >> $testLog
			echo "Possible reasons include:" >> $testLog
			echo "    - a segfault error" >> $testLog
			echo "    - a serious memory access error" >> $testLog
			echo "Valgrind testing will NOT be done." >> $testLog
			killed="yes"
		fi
	   
	   # accumulate valgrind error counts
	   if [[ -e $vgrindLog ]]; then
	      vgrindIssues="vgrind_issues.txt"
	      echo "Valgrind issues:" > $vgrindIssues
	      grep "in use at exit" $vgrindLog >> $vgrindIssues
	      grep "total heap usage" $vgrindLog >> $vgrindIssues
	      grep "definitely lost" $vgrindLog >> $vgrindIssues
	      echo "Invalid reads: `grep -c "Invalid read" $vgrindLog`" >> $vgrindIssues
	      echo "Invalid writes: `grep -c "Invalid write" $vgrindLog`" >> $vgrindIssues
	      echo "Uses of uninitialized values: `grep -c "uninitialised" $vgrindLog`" >> $vgrindIssues
	   else
	      echo "Error running Valgrind test." >> $testLog
	   fi

   fi
   
############################################################ Run symbol table tests

   if [[ $1 == "-final" ]]; then
	   symbolsLog="symbolsLog.txt"

      echo "Details from symbol table generation tests:" > $symbolsLog
      echo >> $symbolsLog
      
	   timeout -s SIGKILL 30 ./assemble ./final/ftest01.asm ./symstu01.txt -symbols
		if [[ $timeoutStatus -eq 124 || $timeoutStatus -eq 137 ]]; then
			echo "The test of your solution timed out after 30 seconds." >> $testLog
			echo "Valgrind testing will NOT be done." >> $testLog
			killed="yes"
		elif [[ $timeoutStatus -eq 134 ]]; then
			echo "The test of your solution was killed by a SIGABRT signal." >> $testLog
			echo "Possible reasons include:" >> $testLog
			echo "    - a segfault error" >> $testLog
			echo "    - a serious memory access error" >> $testLog
			echo "Valgrind testing will NOT be done." >> $testLog
			killed="yes"
		fi
	   if [[ -e "./symstu01.txt" ]]; then
	      sort -k2 ./symstu01.txt > sortedsyms01.txt
	      echo "Sorted symbol table for ftest01.asm:" >> $symbolsLog
	      cat sortedsyms01.txt >> $symbolsLog
	      echo >> $symbolsLog
	      ./symcompare 11 sortedsyms01.txt ./symtabs/refsyms01.txt >> $symbolsLog
	      echo >> $symbolsLog
	   else
	      echo "   File not found:  symstu01.txt" >> $symbolsLog
	   fi

	   timeout -s SIGKILL 30 ./assemble ./final/ftest04.asm ./symstu04.txt -symbols
		if [[ $timeoutStatus -eq 124 || $timeoutStatus -eq 137 ]]; then
			echo "The test of your solution timed out after 30 seconds." >> $testLog
			echo "Valgrind testing will NOT be done." >> $testLog
			killed="yes"
		elif [[ $timeoutStatus -eq 134 ]]; then
			echo "The test of your solution was killed by a SIGABRT signal." >> $testLog
			echo "Possible reasons include:" >> $testLog
			echo "    - a segfault error" >> $testLog
			echo "    - a serious memory access error" >> $testLog
			echo "Valgrind testing will NOT be done." >> $testLog
			killed="yes"
		fi
	   if [[ -e "./symstu04.txt" ]]; then
	      sort -k2 ./symstu04.txt > sortedsyms04.txt
	      echo "Sorted symbol table for ftest04.asm:" >> $symbolsLog
	      cat sortedsyms04.txt >> $symbolsLog
	      echo >> $symbolsLog
	      ./symcompare 12 sortedsyms04.txt ./symtabs/refsyms04.txt >> $symbolsLog
	      echo >> $symbolsLog
	   else
	      echo "   File not found:  symstu04.txt" >> $symbolsLog
	   fi

	   timeout -s SIGKILL 30 ./assemble ./final/ftest07.asm ./symstu07.txt -symbols
		if [[ $timeoutStatus -eq 124 || $timeoutStatus -eq 137 ]]; then
			echo "The test of your solution timed out after 30 seconds." >> $testLog
			echo "Valgrind testing will NOT be done." >> $testLog
			killed="yes"
		elif [[ $timeoutStatus -eq 134 ]]; then
			echo "The test of your solution was killed by a SIGABRT signal." >> $testLog
			echo "Possible reasons include:" >> $testLog
			echo "    - a segfault error" >> $testLog
			echo "    - a serious memory access error" >> $testLog
			echo "Valgrind testing will NOT be done." >> $testLog
			killed="yes"
		fi
	   if [[ -e "./symstu07.txt" ]]; then
	      sort -k2 ./symstu07.txt > sortedsyms07.txt
	      echo "Sorted symbol table for ftest07.asm:" >> $symbolsLog
	      cat sortedsyms07.txt >> $symbolsLog
	      echo >> $symbolsLog
	      ./symcompare 13 sortedsyms07.txt ./symtabs/refsyms07.txt >> $symbolsLog
         echo $Separator >> $summaryLog
	   else
	      echo "   File not found:  symstu07.txt" >> $symbolsLog
	   fi
	   echo >> $symbolsLog
   fi
   
############################################################ File report
# complete summary file

   # write header to summary log
   cat "$headerLog" > $summaryLog
   
   echo ">>Scores from testing<<" >> $summaryLog
   # write scores to summary file
   #echo >> $summaryLog
   grep Score $testLog >> $summaryLog
   
   if [[ $1 == "-final" ]]; then
      grep symbols $symbolsLog >> $summaryLog
   fi
      
   echo $Separator >> $summaryLog
   echo >> $summaryLog
   
   # write Valgrind summary into log
   if [[ $1 == "-final" ]]; then
      cat $vgrindIssues >> $summaryLog
      echo $Separator >> $summaryLog
   fi
   
   # write symbol tables test results into log
   if [[ $1 == "-final" ]]; then
      cat $symbolsLog >> $summaryLog
      echo $Separator >> $summaryLog
   fi
   
   # write testing details into summary
   cat $testLog >> $summaryLog
   echo $Separator >> $summaryLog
   
   # write Valgrind details into log
   if [[ $1 == "-final" ]]; then
      cat $vgrindLog >> $summaryLog
      echo $Separator >> $summaryLog
   fi

   # write build log into summary
   echo "Results from $buildLog" >> $summaryLog
   cat $buildLog >> $summaryLog
   echo >> $summaryLog

   # rename summary log using student's PID
   mv $summaryLog $spid.txt

exit 0
