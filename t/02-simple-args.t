#!perl

use lib 't';

use POSIX;

use FFI::Raw;
use CompileTest;

my $test   = '02-simple-args';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

my $tests = 24;

# integers

use bigint;

my $min_int64  = -2**63;
my $max_uint64 = 2**64-1;

SKIP: {
eval "use Math::Int64";

if ($@) {
	print "Math::Int64 required for int64 tests\n";
	$tests -= 2;
	last SKIP;
}

my $take_one_int64 = eval { FFI::Raw -> new(
	$shared, 'take_one_int64',
	FFI::Raw::void, FFI::Raw::int64
) };

if ($@) {
	print "# LLONG_MIN and ULLONG_MAX required for int64 tests\n";
	$tests -= 2;
	last SKIP;
}

$take_one_int64 -> call($min_int64);

my $take_one_uint64 = FFI::Raw -> new(
	$shared, 'take_one_uint64',
	FFI::Raw::void, FFI::Raw::uint64
);

$take_one_uint64 -> call($max_uint64);
}

no bigint;

my $take_one_long = FFI::Raw -> new(
	$shared, 'take_one_long',
	FFI::Raw::void, FFI::Raw::long
);

$take_one_long -> call(LONG_MIN);

my $take_one_ulong = FFI::Raw -> new(
	$shared, 'take_one_ulong',
	FFI::Raw::void, FFI::Raw::ulong
);

$take_one_ulong -> call(ULONG_MAX);

my $take_one_int = FFI::Raw -> new(
	$shared, 'take_one_int',
	FFI::Raw::void, FFI::Raw::int
);

$take_one_int -> call(INT_MIN);

my $take_one_uint = FFI::Raw -> new(
	$shared, 'take_one_uint',
	FFI::Raw::void, FFI::Raw::uint
);

$take_one_uint -> call(UINT_MAX);

my $take_one_short = FFI::Raw -> new(
	$shared, 'take_one_short',
	FFI::Raw::void, FFI::Raw::short
);

$take_one_short -> call(SHRT_MIN);

my $take_one_ushort = FFI::Raw -> new(
	$shared, 'take_one_ushort',
	FFI::Raw::void, FFI::Raw::ushort
);

$take_one_ushort -> call(USHRT_MAX);

my $take_one_char = FFI::Raw -> new(
	$shared, 'take_one_char',
	FFI::Raw::void, FFI::Raw::char
);

$take_one_char -> call(CHAR_MIN);

my $take_one_uchar = FFI::Raw -> new(
	$shared, 'take_one_uchar',
	FFI::Raw::void, FFI::Raw::uchar
);

$take_one_uchar -> call(UCHAR_MAX);

my $take_two_shorts = FFI::Raw -> new(
	$shared, 'take_two_shorts',
	FFI::Raw::void, FFI::Raw::short, FFI::Raw::short
);

$take_two_shorts -> call(10, 20);

my $take_misc_ints = FFI::Raw -> new(
	$shared, 'take_misc_ints',
	FFI::Raw::void, FFI::Raw::int, FFI::Raw::short, FFI::Raw::char
);

$take_misc_ints -> call(101, 102, 103);
$take_misc_ints -> (101, 102, 103);

# floats
my $take_one_double = FFI::Raw -> new(
	$shared, 'take_one_double',
	FFI::Raw::void, FFI::Raw::double
);

$take_one_double -> call(-6.9e0);
$take_one_double -> (-6.9e0);

my $take_one_float = FFI::Raw -> new(
	$shared, 'take_one_float',
	FFI::Raw::void, FFI::Raw::float
);

$take_one_float -> call(4.2e0);
$take_one_float -> (4.2e0);

# strings
my $take_one_string = FFI::Raw -> new(
	$shared, 'take_one_string',
	FFI::Raw::void, FFI::Raw::str
);

$take_one_string -> call('ok - passed a string');
$take_one_string -> ('ok - passed a string');

print "1..$tests\n";
