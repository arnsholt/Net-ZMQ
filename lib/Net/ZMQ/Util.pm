module Net::ZMQ::Util;

use NativeCall;

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

class X::ZMQ is Exception {
    has Int $.errno;
    has Str $.strerror;

    method message() {
        return "ZMQ error: $.strerror (code $.errno)";
    }
}

my sub zmq_die() is export {
    my $no = zmq_errno();
    X::ZMQ.new(:errno($no), :strerror(zmq_strerror($no))).throw;
}

# vim: ft=perl6
