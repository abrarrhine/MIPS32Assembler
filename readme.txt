Warning:  modifying this script would very likely defeat the purpose of having
          it supplied to you.

This script can be used to test and grade your solution for the MIPS assembler
assignment.  This is the script we will use to do that, so if your tar file
does not work for you with this script, it won't work for us either.
That would be unfortunate.

Invoke as:  ./gradeC02.sh [ -m1 | -m2 | -final | -ec ] <name of submission tar file>
            -m1 selects the tests for milestone 1
            -m2 selects the tests for milestone 2
            -final selects the tests for the final submission
            -ec selects the tests for the extra-credit option (only) 
            We suggest you name your tar file PID.tar, where PID is
            your VT email pid (e.g., wmcquain.tar).


Last modified:  Sept 26, 2021

To use this test script:
   - Untar the distributed testing tar file into a directory; that should
     create the following directory structure:

        ./gradeC03.sh              - this script file
        ./compare                  - 64-bit CentOS 8 utility for checking results
        ./milestone1/m1testxx.asm  - MIPS files to be assembled
        ./milestone1/m1testxx.o    - reference translations 
        ./milestone2/m2testxx.asm  - MIPS files to be assembled
        ./milestone2/m2testxx.o    - reference translations 
        ./final/ftestxx.asm        - MIPS files to be assembled
        ./final/ftestxx.o          - reference translations
        ./final/ecTest.asm         - MIPS file for extra-credit test 
        ./final/ecTest.o           - reference translation for extra-credit test 

     We will refer to the extraction directory as the test directory.
   - Set execute permissions for grade.sh.
   - Prepare the tar file you intend to submit and place it into the same
     directory as gradeC02.sh.
   - Execute the grading script command as described above.

   gradeC02.sh will create a subdirectory, ./build, unpack your submission tar
   file into it, and use your makefile to build the specified target,
   "assemble".

   If there is no makefile, the script will emit with an error message, and attempt
   to perform a build with default settings.  If that fails, the script will exit;
   if the default build succeeds, a penalty of 20% will be applied.

   The script will then check for the existence of the specified executable,
   "assemble".  If there is no such file, the script will exit with an error
   message.  Otherwise, the  script will move the executable "assemble" into
   the test directory, and execute it on each of the asm files in the
   appropriate directory.  For each test case, the script will use the compare
   utility to compare your translation to the reference translation, producing
   a score for each test case.

   If -final is selected, there is additional testing:
      -  symbol table generation is tested
      -  Valgrind analysis is run on a single test case
      -  a test is run for the extra-credit option

Exit codes:
   0   -  normal execution; no major errors were detected
   1   -  wrong number of command-line parameters
   2   -  invalid switch used on command-line
   3   -  something is missing from test file directory
   4   -  file named on command line does not exist
   5   -  file named on command line is not a tar file
   6   -  tar file does not contain a makefile
   7   -  build failed
   8   -  build produced nonexecutable file (unlikely)
