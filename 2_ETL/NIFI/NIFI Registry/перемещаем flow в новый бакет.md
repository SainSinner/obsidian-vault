перемещаем flow в новый бакет  
команды:  
`registry create-bucket -bn "Chicago - 1C" -u http://nifi1-dtln:18080   registry create-flow -b 7b8de4c8-6821-49f9-a972-a1c102557759 -fn "Chicago - 1C | Orders" -u http://nifi1-dtln:18080   registry sync-flow-versions -sf 405562c9-0cfa-47a1-8848-c117d295f3c9 -f 52bb159b-3473-4199-a703-3bc5dd352fd6 -u http://nifi1-dtln:18080`  
путь:  
`/usr/lib/nifi-toolkit/bin/cli.sh`