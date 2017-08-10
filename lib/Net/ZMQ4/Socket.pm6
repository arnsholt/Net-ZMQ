use NativeCall;
unit class Net::ZMQ4::Socket is repr('CPointer');

use Net::ZMQ4::Constants;
use Net::ZMQ4::Context;
use Net::ZMQ4::Message;
use Net::ZMQ4::Util;

# ZMQ_EXPORT void *zmq_socket (void *context, int type);
my sub zmq_socket(Net::ZMQ4::Context, int32 --> Net::ZMQ4::Socket) is native('zmq',v5) { * }
# ZMQ_EXPORT int zmq_close (void *s);
my sub zmq_close(Net::ZMQ4::Socket --> int32) is native('zmq',v5) { * }
# ZMQ_EXPORT int zmq_setsockopt (void *s, int option, const void *optval,
#     size_t optvallen);
my sub zmq_setsockopt_int(Net::ZMQ4::Socket, int32, CArray[int32], int32 --> int32)
    is native('zmq',v5)
    is symbol('zmq_setsockopt')
    { * }
my sub zmq_setsockopt_int32(Net::ZMQ4::Socket, int32, CArray[int32], int32 --> int32)
    is native('zmq',v5)
    is symbol('zmq_setsockopt')
    { * }
my sub zmq_setsockopt_int64(Net::ZMQ4::Socket, int32, CArray[int64], int32 --> int32)
    is native('zmq',v5)
    is symbol('zmq_setsockopt')
    { * }
my sub zmq_setsockopt_bytes(Net::ZMQ4::Socket, int32, CArray[uint8], int32 --> int32)
    is native('zmq',v5)
    is symbol('zmq_setsockopt')
    { * }
# ZMQ_EXPORT int zmq_getsockopt (void *s, int option, void *optval,
#     size_t *optvallen);
# We have several variants of this function, all with different signatures, to
# circumvent the type-checking (passing a CArray won't work when the sig says
# OpaquePointer). Long-term, this should probably be replaced by better
# functionality for changing pointer types in Zavolaj.
my sub zmq_getsockopt_int(Net::ZMQ4::Socket, int32, CArray[int32], CArray[int32] --> int32)
    is native('zmq',v5)
    is symbol('zmq_getsockopt')
    { * }
my sub zmq_getsockopt_int32(Net::ZMQ4::Socket, int32, CArray[int32], CArray[int32] --> int32)
    is native('zmq',v5)
    is symbol('zmq_getsockopt')
    { * }
my sub zmq_getsockopt_int64(Net::ZMQ4::Socket, int32, CArray[int64], CArray[int32] --> int32)
    is native('zmq',v5)
    is symbol('zmq_getsockopt')
    { * }
my sub zmq_getsockopt_bytes(Net::ZMQ4::Socket, int32, CArray[int8], CArray[int32] --> int32)
    is native('zmq',v5)
    is symbol('zmq_getsockopt')
    { * }
# ZMQ_EXPORT int zmq_bind (void *s, const char *addr);
my sub zmq_bind(Net::ZMQ4::Socket, Str --> int32) is native('zmq',v5) { * }
# ZMQ_EXPORT int zmq_connect (void *s, const char *addr);
my sub zmq_connect(Net::ZMQ4::Socket, Str --> int32) is native('zmq',v5) { * }

# ZMQ_EXPORT int zmq_send (void *s, void *buf, size_t buflen, int flags);
my sub zmq_send(Net::ZMQ4::Socket, Net::ZMQ4::Message, int32 --> int32) is native('zmq',v5) { * }
# ZMQ_EXPORT int zmq_recv (void *s, void *msg, size_t buflen, int flags);
my sub zmq_recv(Net::ZMQ4::Socket, Net::ZMQ4::Message is rw, int32 --> int32) is native('zmq',v5) { * }

# ZMQ_EXPORT int zmq_send_msg (void *s, zmq_msg_t *msg, int flags);
my sub zmq_sendmsg(Net::ZMQ4::Socket, Net::ZMQ4::Message, int32 --> int32) is native('zmq',v5) { * }
# ZMQ_EXPORT int zmq_recv_msg (void *s, zmq_msg_t *msg, int flags);
my sub zmq_recvmsg(Net::ZMQ4::Socket, Net::ZMQ4::Message, int32 --> int32) is native('zmq',v5) { * }

my %opttypes = ZMQ_BACKLOG, int32,
               ZMQ_TYPE, int32,
               ZMQ_LINGER, int32,
               ZMQ_RECONNECT_IVL, int32,
               ZMQ_RECONNECT_IVL_MAX, int32,

               ZMQ_AFFINITY, int64,
               ZMQ_RCVMORE, int64,
               ZMQ_SUBSCRIBE, "bytes",
               ZMQ_UNSUBSCRIBE, "bytes",
               ZMQ_RATE, int64,
               ZMQ_RECOVERY_IVL, int64,
               ZMQ_SNDBUF, int64,
               ZMQ_RCVBUF, int64,
               ZMQ_SNDHWM, int,
               ZMQ_RCVHWM, int,

               ZMQ_IDENTITY, "bytes",
               ZMQ_EVENTS, int32,
               ZMQ_XPUB_MANUAL, int32;

method new(Net::ZMQ4::Context $context, int $type) {
    my $sock = zmq_socket($context, $type);
    zmq_die() if not $sock;
    return $sock;
}

method bind(Str $address) {
    my $ret = zmq_bind(self, $address);
    zmq_die() if $ret != 0;
}

# TODO: setsockopt/getsockopt. Best way to expose them might be separate
# accessors for each property?

method connect(Str $address) {
    my $ret = zmq_connect(self, $address);
    zmq_die() if $ret != 0;
}

method close() {
    my $ret = zmq_close(self);
    zmq_die() if $ret != 0;
}

# TODO: There's probably a more Perlish way to handle the flags.
#multi method send(Str $message, $flags = 0) {
#    return self.send($message.encode("utf8"), $flags);
#}
#
#multi method send(Blob $buf, $flags = 0) {
#    my $carr = CArray[int8].new;
#    for $buf.list.kv -> $idx, $val { $carr[$idx] = $val; }
#    my $ret = zmq_send(self, $carr, $buf.elems, $flags);
#    zmq_die if $ret == -1;
#    return $ret;
#}

multi method send(Net::ZMQ4::Message $message, $flags = 0) {
    my $ret = zmq_sendmsg(self, $message, $flags);
    zmq_die() if $ret == -1;
    return $ret;
}

multi method send(Str $message, $flags = 0) {
    self.send: Net::ZMQ4::Message.new(:$message), $flags;
}

multi method send(Blob[uint8] $message, $flags = 0) {
    self.send: Net::ZMQ4::Message.new(data => $message), $flags;
}

method receive(int $flags = 0) {
    my $msg = Net::ZMQ4::Message.new;
    my $ret = zmq_recvmsg(self, $msg, $flags);
    zmq_die() if $ret == -1;
    return $msg;
}

method getopt($opt) {
    my $optlen = CArray[int32].new;
    my $ret;

    my CArray $val;
    given %opttypes{$opt} {
        when int {
            $val = CArray[int32].new;
            $val[0] = 0;
            $optlen[0] = 4;
            $ret = zmq_getsockopt_int(self, $opt, $val, $optlen);
        }
        when int32 {
            $val = CArray[int32].new;
            $val[0] = 0;
            $optlen[0] = 4;
            $ret = zmq_getsockopt_int32(self, $opt, $val, $optlen);
        }
        when int64 {
            $val = CArray[int64].new;
            $val[0] = 0;
            $optlen[0] = 8;
            $ret = zmq_getsockopt_int64(self, $opt, $val, $optlen);
        }
        # TODO: bytes
        #when "bytes" {
        #    $val = CArray[int8].new;
        #    $val[0] = int8;
        #    $ret = zmq_getsockopt_int8(self, $opt, $val, $optlen);
        #}
        default {
            die "Unknown ZMQ socket option type $opt";
        }
    }

    zmq_die() if $ret != 0;
    return $val[0];
}

method setopt($opt, $value) {
    my size_t $optlen;
    my $ret;

    my CArray $val;
    given %opttypes{$opt} {
        when int {
            $val = CArray[int32].new;
            $val[0] = $value;
            $optlen = 4;
            $ret = zmq_setsockopt_int(self, $opt, $val, $optlen);
        }
        when int32 {
            $val = CArray[int32].new;
            $val[0] = $value;
            $optlen = 4;
            $ret = zmq_setsockopt_int32(self, $opt, $val, $optlen);
        }
        when int64 {
            $val = CArray[int64].new;
            $val[0] = $value;
            $optlen = 8;
            $ret = zmq_setsockopt_int64(self, $opt, $val, $optlen);
        }
        # TODO: bytes
        when "bytes" {
           $val = CArray[uint8].new;
           # Memory allocation
           $val[$value.elems - 1] = 0;
           die "Send Blob to use $opt" unless $value ~~ Blob;
           for @$value.kv -> $i, $_ { $val[$i] = $_ }
           $ret = zmq_setsockopt_bytes(self, $opt, $val, $value.elems);
        }
        default {
            die "Unknown ZMQ socket option type $opt";
        }
    }

    zmq_die() if $ret != 0;
    return;
}

# vim: ft=perl6
