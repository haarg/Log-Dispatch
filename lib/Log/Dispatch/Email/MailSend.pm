package Log::Dispatch::Email::MailSend;

use strict;
use warnings;

our $VERSION = '2.69';

use Mail::Send;
use Try::Tiny;

use base qw( Log::Dispatch::Email );

sub send_email {
    my $self = shift;
    my %p    = @_;

    my $msg = Mail::Send->new;

    $msg->to( join ',', @{ $self->{to} } );
    $msg->subject( $self->{subject} );

    # Does this ever work for this module?
    $msg->set( 'From', $self->{from} ) if $self->{from};

    local $? = 0;
    return
        if try {
        my $fh = $msg->open
            or die 'Cannot open handle to mail program';

        $fh->print( $p{message} )
            or die 'Cannot print message to mail program handle';

        $fh->close
            or die 'Cannot close handle to mail program';

        1;
        };

    warn $@ if $@;
}

1;

# ABSTRACT: Subclass of Log::Dispatch::Email that uses the Mail::Send module

__END__

=head1 SYNOPSIS

  use Log::Dispatch;

  my $log = Log::Dispatch->new(
      outputs => [
          [
              'Email::MailSend',
              min_level => 'emerg',
              to        => [qw( foo@example.com bar@example.org )],
              subject   => 'Big error!'
          ]
      ],
  );

  $log->emerg('Something bad is happening');

=head1 DESCRIPTION

This is a subclass of L<Log::Dispatch::Email> that implements the send_email
method using the L<Mail::Send> module.

=head1 CHANGING HOW MAIL IS SENT

Since L<Mail::Send> is a subclass of L<Mail::Mailer>, you can change
how mail is sent from this module by simply C<use>ing L<Mail::Mailer>
in your code before mail is sent. For example, to send mail via smtp,
you could do:

  use Mail::Mailer 'smtp', Server => 'foo.example.com';

For more details, see the L<Mail::Mailer> docs.

=cut
