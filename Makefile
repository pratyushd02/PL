default : compile

compile : src/*.java
	javac -d bin src/*.java 

run : compile
	java -cp bin src.Main