class X::ZMQ is Exception;

has Int $.errno;
has Str $.strerror;

method message() {
    return "ZMQ error: $.strerror (code $.errno)";
}

# vim: ft=perl6
