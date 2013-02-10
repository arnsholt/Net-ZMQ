module Net::ZMQ::Util;

use NativeCall;

use Net::ZMQ::Pollitem;
use X::ZMQ;

my constant ZMQ_HAUSNUMERO  = 156384712;
my constant EFSM            = (ZMQ_HAUSNUMERO + 51);
my constant ENOCOMPATPROTO  = (ZMQ_HAUSNUMERO + 52);
my constant ETERM           = (ZMQ_HAUSNUMERO + 53);
my constant EMTHREAD        = (ZMQ_HAUSNUMERO + 54);

# ZMQ_EXPORT void zmq_version (int *major, int *minor, int *patch);
sub zmq_version(CArray[int], CArray[int], CArray[int]) is native('libzmq') { * }
# ZMQ_EXPORT int zmq_errno (void);
sub zmq_errno() is native('libzmq') { * }
# ZMQ_EXPORT const char *zmq_strerror (int errnum);
sub zmq_strerror(int --> Str) is native('libzmq') { * }

# ZMQ_EXPORT int zmq_poll (zmq_pollitem_t *items, int nitems, long timeout);
my sub zmq_poll(Net::ZMQ::Pollitem, int, Int --> int) is native('libzmq') { * }

# ZMQ device types. All #defined in zmq.h
my constant ZMQ_STREAMER  = 1;
my constant ZMQ_FORWARDER = 2;
my constant ZMQ_QUEUE     = 3;

# ZMQ_EXPORT int zmq_device (int device, void * insocket, void* outsocket);
my sub zmq_device(int, Net::ZMQ::Socket, Net::ZMQ::Socket--> int) is native('libzmq') { * }

my sub zmq_die() is export {
    X::ZMQ.new(:errno(zmq_errno()), :strerror(zmq_strerror())).throw;
}

# vim: ft=perl6
