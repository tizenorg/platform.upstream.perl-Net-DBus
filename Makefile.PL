use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

my $DBUS_LIBS = `pkg-config --libs dbus-1`;
my $DBUS_CFLAGS = `pkg-config --cflags dbus-1`;

if (!defined $DBUS_LIBS || !defined DBUS_CFLAGS) {
    die "could not run 'pkg-config' to determine compiler/linker flags for dbus library: $!\n";
}
if (!$DBUS_LIBS || !$DBUS_CFLAGS) {
    die "'pkg-config' didn't report any compiler/linker flags for dbus library\n";
}

my $wall = "";
if ($^O eq "linux") {
    $wall = "-Wall";
}

WriteMakefile(
	      'NAME' => 'Net::DBus',
	      'VERSION_FROM' => 'lib/Net/DBus.pm',
	      'PREREQ_PM' => {
		  'Test::More'  => 0,
		  'Time::HiRes' => 0,
		  'XML::Twig' => 0,
		  },
	      'AUTHOR' => 'Daniel Berrange <dan@berrange.com>',
	      'LIBS' => [$DBUS_LIBS],
	      'DEFINE' => ("-DNET_DBUS_DEBUG=1"),
	      'INC' => "$wall $DBUS_CFLAGS",
              'NO_META' => 1,
	      'depend' => {
		  Net-DBus.spec => '$(VERSION_FROM)',
		  Makefile => '$(VERSION_FROM)',
	      },
	      'realclean' => {
		  FILES => 'Net-DBus.spec',
	      },
);

package MY;

sub libscan
  {
    my ($self, $path) = @_;
    ($path =~ /\~$/ || $path =~ m,/CVS/,) ? undef : $path;
  }

__END__
