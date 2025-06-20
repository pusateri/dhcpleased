#	$OpenBSD: Makefile,v 1.3 2022/08/29 17:00:29 deraadt Exp $

PROG=	dhcpleased
SRCS=	bpf.c checksum.c control.c dhcpleased.c engine.c frontend.c log.c
SRCS+=	parse.c printconf.c
SRCS+=	compat/imsg.c compat/imsg-buffer.c
INCS=   bpf.h checksum.h control.h dhcpleased.h engine.h frontend.h imsg.h log.h parse.h compat/queue.h

MAN=	dhcpleased.8 dhcpleased.conf.5

#DEBUG=	-g -DDEBUG=3 -O0
DEBUG=	-g

CFLAGS+= -Wall -I. -I/usr/local/include

CFLAGS+= -Wstrict-prototypes -Wmissing-prototypes
CFLAGS+= -Wmissing-declarations
CFLAGS+= -Wshadow -Wpointer-arith -Wcast-qual
CFLAGS+= -Wsign-compare
YFLAGS=
LIBS=	-L /usr/local/lib -levent

OBJS := ${SRCS:.c=.o}

${PROG}: ${OBJS}
	${CC} ${CFLAGS} -o ${PROG} ${OBJS} ${LIBS}

parse.c + parse.h: parse.y
	yacc -d parse.y
	mv y.tab.c parse.c
	mv y.tab.h parse.h

clean:
	rm ${OBJS} parse.c parse.h ${PROG}

# Don't compile dhcpleased as static binary by default
#LDSTATIC=       
