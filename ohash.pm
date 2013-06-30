package ohash;
use 5.010;

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
    my ($this) = [];
    CLEAR($this);

    while (@_) {
        STORE($this, shift, shift);
    }

    return bless($this, $class);
}

sub STORE
{
    my ($this, $key, $value) = @_;
    # TODO: assert(defined($key));
    ${$this->[0]{$key} // _append($this, $key)}[2] = $value;
}


sub FETCH
{
    my ($this, $key) = @_;
    # TODO: assert(defined($key));
    return $this->[0]{$key}[2] // undef;
}

sub FIRSTKEY
{
    my ($this) = @_;
    return $this->[1][1];
}

sub NEXTKEY
{
    my ($this, $lastkey) = @_;
    return $this->[0]{$lastkey}[1];
}

sub EXISTS
{
    my ($this, $key) = @_;
    return exists($this->[0]{$key});
}

sub DELETE
{
    my ($this, $key) = @_;
    my ($data, $root) = @$this;
    my $node = $data->{$key};
    ${_get($this, $node->[0])}[1] = $node->[1];
    ${_get($this, $node->[1])}[0] = $node->[0];
    delete $data->{$key};
}

sub CLEAR
{
    my ($this) = @_;
    $this->[0] = {};    # key => node
    $this->[1] = [      # root node
        undef,      # key of last element
        undef,      # key of first element
        undef,      # value
    ];
}


sub _get
{
    my ($this, $key) = @_;
    return defined($key) ? $this->[0]{$key} : $this->[1];
}

sub _append
{
    my ($this, $key) = @_;
    # TODO: assert(defined($key));
    my ($data, $root) = @$this;
    my $node = [
        $root->[0],     # key of previous element
        undef,          # key of next element
        undef,          # value
    ];
    $root->[0] = $key;
    ${_get($this, $node->[0])}[1] = $key;
    $data->{$key} = $node;
    return $node;
}

1;
