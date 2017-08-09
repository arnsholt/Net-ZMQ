use NativeCall;

unit class Net::ZMQ::Context is repr('CPointer');

use Net::ZMQ::Util;

# ZMQ_EXPORT void *zmq_ctx_new (void);
my sub zmq_ctx_new() is native('zmq', v5) { * }
# ZMQ_EXPORT int zmq_ctx_term (void *context);
my sub zmq_ctx_term(Net::ZMQ::Context --> int32) is native('zmq', v5) { * }
# ZMQ_EXPORT int zmq_ctx_shutdown (void *context);
my sub zmq_ctx_shutdown(Net::ZMQ::Context --> int32) is native('zmq', v5) { * }
# ZMQ_EXPORT int zmq_ctx_set (void *context, int option, int optval);
my sub zmq_ctx_set(Net::ZMQ::Context, int32, int32 --> int32) is native('zmq', v5) { * }
# ZMQ_EXPORT int zmq_ctx_get (void *context, int option);
my sub zmq_ctx_get(Net::ZMQ::Context, int32 --> int32) is native('zmq', v5) { * }

method new() {
    my $ctx = zmq_ctx_new();
    zmq_die() if not $ctx;
    $ctx;
}

method get($option) {
    my $value = zmq_ctx_get(self, $option)
    zmq_die if $value < 0;
    $value
}

method set($option, $value) {
    zmq_die if zmq_ctx_set(self, $option, $value) != 0;
}

method term() {
    zmq_die() if zmq_term(self) != 0;
}

method shutdown() {
   zmq_die() if zmq_shutdown(self) != 0;
}
