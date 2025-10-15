1. необходимо скачать нужную нам версию с ресурса [https://archive.apache.org/dist/nifi/](https://archive.apache.org/dist/nifi/)
2. скачать 8 версию java: JDK 1.8 or higher. Например доступную по ссылке
   https://download.oracle.com/java/22/latest/jdk-22_windows-x64_bin.exe
3. прописать в "переменных средах" () переменную JAVA_HOME со значением расположения папки java, например C:\Program Files\Java\jdk-22
4. прописать в переменную Path и PATH значение %JAVA_HOME%\bin
5. распаковать архив nifi в директории диска C
6. execute bin/run-nifi.bat
7. Obtain the generated username and password from logs/nifi-app.log
8. Direct your browser to https://localhost:8443/nifi/
9. Use the generated username and password to login
Или можно обратиться к гайду по ссылке [https://nifi.apache.org/docs/nifi-docs/html/getting-started.html](https://nifi.apache.org/docs/nifi-docs/html/getting-started.html)