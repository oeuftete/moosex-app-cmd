package Test::ConfigFromFile::Command::moo;
use Moose;
use YAML();

extends qw(MooseX::App::Cmd::Command);
with 'MooseX::ConfigFromFile';

=head1 NAME

Test::MyCmd::Command::moo - reads from config file

=cut

has 'moo' => (
    isa           => "ArrayRef",
    is            => "ro",
    required      => 1,
    auto_deref    => 1,
    documentation => "required option field",
);

has 'check' => (
    traits      => [qw(Getopt)],
    isa         => "Int",
    is          => 'ro',
    cmd_aliases => [qw(c C)],
);

sub execute {
    my ( $self, $opt, $arg ) = @_;

    die( "cows go " . join( ' ', $self->moo ) );
}

sub get_config_from_file {
    my ( $self, $file ) = @_;

    return YAML::LoadFile($file);
}

1;
