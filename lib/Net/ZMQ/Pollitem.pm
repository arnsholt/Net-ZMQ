use NativeCall;
class Net::ZMQ::Pollitem is repr('CStruct');

use Net::ZMQ::Socket;

# ZMQ poll types, all #defines in zmq.h
my constant ZMQ_POLLIN  = 1;
my constant ZMQ_POLLOUT = 2;
my constant ZMQ_POLLERR = 4;

has Net::ZMQ::Socket $!socket;
has int              $!fd;
has int16            $!events;
has int16            $!revents;

# ZMQ_EXPORT int zmq_poll (zmq_pollitem_t *items, int nitems, long timeout);
my sub zmq_poll(Net::ZMQ::Pollitem, int, Int --> int) is native('libzmq') { * }

# vim: ft=perl6
