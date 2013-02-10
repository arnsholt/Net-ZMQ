use NativeCall;
class Net::ZMQ::Context is repr('CPointer');

use Net::ZMQ::Util;

# ZMQ_EXPORT void *zmq_init (int io_threads);
my sub zmq_init(int --> Net::ZMQ::Context) is native('libzmq') { * }
# ZMQ_EXPORT int zmq_term (void *context);
my sub zmq_term(Net::ZMQ::Context --> int) is native('libzmq') { * }

# TODO: What's a sane default number of threads?
method new(:$threads = 1) {
    my $ctx = zmq_init($threads);
    zmq_die() if not $ctx;
}

method terminate() {
    my $ret = zmq_term(self);
    zmq_die() if $ret != 0;
}

method socket(int $type) {
    return Net::ZMQ::Socket.new(self, $type);
}

# vim: ft=perl6
