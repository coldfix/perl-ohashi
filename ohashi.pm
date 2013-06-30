package ohashi;
use 5.010;
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
    my $this = [
        {},     # lowercase key => data
        \%oc    # lowercase key => original case key
    ];

    while (my ($key, $value) = each(%initial)) {
        STORE($this, $key, $value);
    }

    return bless($this, $class);
}

sub STORE
{
    my ($this, $key, $value) = @_;
    $this->[0]{lc($key)} = $value;
    $this->[1]{lc($key)} = $key if (!exists $this->[1]{lc($key)});
}

sub FETCH
{
    my ($this, $key) = @_;
    return $this->[0]{lc($key)};
}

sub FIRSTKEY
{
    my ($this) = @_;
    my $keys = keys %{$this->[1]};
    my ($lc, $oc) = each %{$this->[1]};
    return $oc;
}

sub NEXTKEY
{
    my ($this, $lastkey) = @_;
    my ($lc, $oc) = each %{$this->[1]};
    return $oc;
}

sub EXISTS
{
    my ($this, $key) = @_;
    return exists $this->[0]{lc($key)};
}

sub DELETE
{
    my ($this, $key) = @_;
    delete $this->[0]{lc($key)};
    delete $this->[1]{lc($key)};
}

sub CLEAR
{
    my ($this) = @_;
    %{$this->[0]} = ();
    %{$this->[1]} = ();
}

1;
