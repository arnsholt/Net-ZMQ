use NativeCall;
class Net::ZMQ::Socket is repr('CPointer');

use Net::ZMQ::Context;
use Net::ZMQ::Message;

# Socket types. These are all #defines.
my constant ZMQ_PAIR   = 0;
my constant ZMQ_PUB    = 1;
my constant ZMQ_SUB    = 2;
my constant ZMQ_REQ    = 3;
my constant ZMQ_REP    = 4;
my constant ZMQ_DEALER = 5;
my constant ZMQ_ROUTER = 6;
my constant ZMQ_PULL   = 7;
my constant ZMQ_PUSH   = 8;
my constant ZMQ_XPUB   = 9;
my constant ZMQ_XSUB   = 10;

# Socket options, likewise.
my constant ZMQ_HWM               = 1;
my constant ZMQ_SWAP              = 3;
my constant ZMQ_AFFINITY          = 4;
my constant ZMQ_IDENTITY          = 5;
my constant ZMQ_SUBSCRIBE         = 6;
my constant ZMQ_UNSUBSCRIBE       = 7;
my constant ZMQ_RATE              = 8;
my constant ZMQ_RECOVERY_IVL      = 9;
my constant ZMQ_MCAST_LOOP        = 10;
my constant ZMQ_SNDBUF            = 11;
my constant ZMQ_RCVBUF            = 12;
my constant ZMQ_RCVMORE           = 13;
my constant ZMQ_FD                = 14;
my constant ZMQ_EVENTS            = 15;
my constant ZMQ_TYPE              = 16;
my constant ZMQ_LINGER            = 17;
my constant ZMQ_RECONNECT_IVL     = 18;
my constant ZMQ_BACKLOG           = 19;
my constant ZMQ_RECOVERY_IVL_MSEC = 20;
my constant ZMQ_RECONNECT_IVL_MAX = 21;

# And send/receive options.
my constant ZMQ_NOBLOCK = 1;
my constant ZMQ_SNDMORE = 2;

# ZMQ_EXPORT void *zmq_socket (void *context, int type);
my sub zmq_socket(Net::ZMQ::Context, int --> Net::ZMQ::Socket) is native('libzmq') { * }
# ZMQ_EXPORT int zmq_close (void *s);
my sub zmq_close(Net::ZMQ::Socket --> int) is native('libzmq') { * }
# ZMQ_EXPORT int zmq_setsockopt (void *s, int option, const void *optval,
#     size_t optvallen); 
my sub zmq_setsockopt(Net::ZMQ::Socket, int, OpaquePointer, int --> int) is native('libzmq') { * }
# ZMQ_EXPORT int zmq_getsockopt (void *s, int option, void *optval,
#     size_t *optvallen);
my sub zmq_getsockopt(Net::ZMQ::Socket, int, OpaquePointer, int --> int) is native('libzmq') { * }
# ZMQ_EXPORT int zmq_bind (void *s, const char *addr);
my sub zmq_bind(Net::ZMQ::Socket, Str --> int) is native('libzmq') { * }
# ZMQ_EXPORT int zmq_connect (void *s, const char *addr);
my sub zmq_connect(Net::ZMQ::Socket, Str --> int) is native('libzmq') { * }
# ZMQ_EXPORT int zmq_send (void *s, zmq_msg_t *msg, int flags);
my sub zmq_send(Net::ZMQ::Socket, Net::ZMQ::Message, int --> int) is native('libzmq') { * }
# ZMQ_EXPORT int zmq_recv (void *s, zmq_msg_t *msg, int flags);
my sub zmq_recv(Net::ZMQ::Socket, Net::ZMQ::Message, int --> int) is native('libzmq') { * }

method new(Net::ZMQ::Context $context, int $type) {
    my $sock = zmq_socket($context, $type);
    # TODO: Check return value and throw exception if it's the type object
    # (aka. a null pointer).
    return $sock;
}

method bind(Str $address) {
    my $ret = zmq_bind(self, $address);
    # TODO: Check return value and throw exception on error.
}

# TODO: setsockopt/getsockopt. Best way to expose them might be separate
# accessors for each property?

method connect(Str $address) {
    my $ret = zmq_connect(self, $address);
    # TODO: Check return value and throw exception on error.
}

# TODO: There's probably a more Perlish way to handle the flags.
multi method send(Str $message, int $flags) {
    self.send(Net::ZMQ::Message.new(:message($message)));
}

multi method send(Net::ZMQ::Message $message, int $flags) {
    my $ret = zmq_send(self, $message, $flags);
    # TODO: Check return value and throw exception on error.
}

method receive(int $flags) {
    my $msg = Net::ZMQ::Message.new;
    my $ret = zmq_recv(self, $msg, $flags);
    # TODO: Check return value and throw exception on error.
    return $msg;
}

# vim: ft=perl6
