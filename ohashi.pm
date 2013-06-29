use warnings;
use strict;

package ohashi;
use Tie::Hash;  # contains Tie::StdHash
use base 'Tie::StdHash';

use ohash;


sub new
{
    my $hash = {};
    my $pkg = shift;
    tie %$hash, $pkg, @_;
    return $hash;
}

sub TIEHASH
{
    my ($class) = shift;
    tie(my (%initial), 'ohash', @_);
    tie(my (%oc), 'ohash');
    my $this = {lc=>{}, oc=>\%oc};

    while (my ($key, $value) = each(%initial)) {
        STORE($this, $key, $value);
    }

    return bless($this, $class);
}

sub STORE
{
    my ($this, $key, $value) = @_;
    $this->{lc}{lc($key)} = $value;
    $this->{oc}{lc($key)} = $key if (!exists $this->{oc}{lc($key)});
}

sub FETCH
{
    my ($this, $key) = @_;
    return $this->{lc}{lc($key)};
}

sub FIRSTKEY
{
    my ($this) = @_;
    my $keys = keys %{$this->{oc}};
    my ($lc, $oc) = each %{$this->{oc}};
    return $oc;
}

sub NEXTKEY
{
    my ($this, $lastkey) = @_;
    my ($lc, $oc) = each %{$this->{oc}};
    return $oc;
}

sub EXISTS
{
    my ($this, $key) = @_;
    return exists $this->{lc}{lc($key)};
}

sub DELETE
{
    my ($this, $key) = @_;
    delete $this->{lc}{lc($key)};
    delete $this->{oc}{lc($key)};
}

sub CLEAR
{
    my ($this) = @_;
    %{$this->{lc}} = ();
    %{$this->{oc}} = ();
}

1;
