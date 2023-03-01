CPATH=".;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar"
set +e

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cp TestListExamples.java ~/student-submission
cd student-submission

if [[ -f ListExamples.java ]]
then
    echo 'ListExamples found'
else
    echo 'ListExamples not present, please check your submission'
    exit 1
fi

javac -cp $CPATH *.java
if [[ $? -ne 0 ]]
then
    echo 'Compilation failed'
    exit 2
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > result-output.txt

grepresult=$(grep "Failures: " result-output.txt)
grep "Failures: " result-output.txt > grep-results.txt
cat grep-results.txt

if [[ -n $grepresult ]]
then 
    TEST=$(cut -c 12 grep-results.txt)
    FAIL=$(cut -c 26 grep-results.txt)
    SCORE=$(($TEST-$FAIL))

    echo "Passed $SCORE/$TEST tests"
else    
    echo "Passed all tests"
fi