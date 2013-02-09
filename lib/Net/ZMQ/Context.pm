use NativeCall;
class Net::ZMQ::Context is repr('CPointer');

# ZMQ_EXPORT void *zmq_init (int io_threads);
my sub zmq_init(int --> Net::ZMQ::Context) is native('libzmq') { * }
# ZMQ_EXPORT int zmq_term (void *context);
my sub zmq_term(Net::ZMQ::Context) is native('libzmq') { * }

# TODO: What's a sane default number of threads?
method new(:$threads = 3) { return zmq_init($threads); }

method terminate() { zmq_term(self); }

# vim: ft=perl6
