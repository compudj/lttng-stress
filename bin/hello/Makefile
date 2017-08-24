hello: *.c *.h
	 ${CC} -O2 -c -I. tp.c
	 ${CC} -O2 -c -I. hello.c
	 ${CC} -O2 -I. -o hello hello.o tp.o -llttng-ust -ldl

.PHONY: clean
clean:
	rm -f *.o
	rm -f hello
