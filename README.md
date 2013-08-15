
### perl-ohashi

Very lightweight order-preserving case-insensitive hashes for perl.


#### Features

* no dependencies on any non-core modules
* very little code logic
* implemented as linked list to improve lookup speed on iteration


#### Usage

`ohashi`s can be created as references:

```perl
my $x = new ohashi(alpha => 'foo', beta => 'bar');
print $x->{AlpHA};    # prints 'foo'
```

or tied to a new variable:

```perl
tie (my %x, 'ohashi',
    alpha => 1, beta => 2));
```


**Don't** try this:

```perl
my %x = (pi => 3.14);
tie (%x, 'ohashi');
```

