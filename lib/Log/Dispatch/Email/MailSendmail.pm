package Log::Dispatch::Email::MailSendmail;

use strict;
use warnings;

our $VERSION = '2.69';

use Mail::Sendmail ();

use base qw( Log::Dispatch::Email );

sub send_email {
    my $self = shift;
    my %p    = @_;

    my %mail = (
        To      => ( join ',', @{ $self->{to} } ),
        Subject => $self->{subject},
        Message => $p{message},

        # Mail::Sendmail insists on having this parameter.
        From => $self->{from} || 'LogDispatch@foo.bar',
    );

    local $? = 0;
    unless ( Mail::Sendmail::sendmail(%mail) ) {
        warn "Error sending mail: $Mail::Sendmail::error";
    }
}

1;

# ABSTRACT: Subclass of Log::Dispatch::Email that uses the Mail::Sendmail module

__END__

=head1 SYNOPSIS

  use Log::Dispatch;

  my $log = Log::Dispatch->new(
      outputs => [
          [
              'Email::MailSendmail',
              min_level => 'emerg',
              to        => [qw( foo@example.com bar@example.org )],
              subject   => 'Big error!'
          ]
      ],
  );

  $log->emerg("Something bad is happening");

=head1 DESCRIPTION

This is a subclass of L<Log::Dispatch::Email> that implements the
send_email method using the L<Mail::Sendmail> module.

=cut
