#!perl -T

use strict;
use warnings;
use Test::More;

BEGIN
{
    eval {
        require MooseX::ConfigFromFile;
        require YAML;
    };
    if ($@) {
        plan( skip_all => "These tests require MooseX::ConfigFromFile and YAML" );
    } else {
        plan( tests => 7 );
    }
}

use lib 't/lib';
use Test::ConfigFromFile;

my $cmd = Test::ConfigFromFile->new;

{
  local @ARGV = qw(moo);
  eval { $cmd->run };
  
  like(
    $@,
    qr/Required option missing/,
    "command died with the correct string",
  );
}

my $success = qr/cows go moo1 moo2 moo3/;
my @configfile_args = qw(--configfile=t/lib/Test/ConfigFromFile/config.yaml);
{
  local @ARGV = (qw(moo), @configfile_args);
  eval { $cmd->run };
  
  like(
    $@,
    $success,
    "command succeeded",
  );
}

{
  local @ARGV = (qw(moo --check 19), @configfile_args);
  eval { $cmd->run };
  
  like(
    $@,
    $success,
    "command succeeded with long c-option",
  );
}

{
  local @ARGV = (qw(moo -c 19), @configfile_args);
  eval { $cmd->run };
  
  like(
    $@,
    $success,
    "command succeeded with -c option followed by configfile option",
  );
}

{
  local @ARGV = ('moo', @configfile_args, qw(-c 19));
  eval { $cmd->run };
  
  like(
    $@,
    $success,
    "command succeeded with -c option preceded by configfile option",
  );
}

{
  local @ARGV = (qw(moo -C 19), @configfile_args);
  eval { $cmd->run };
  
  like(
    $@,
    $success,
    "command succeeded with -C option followed by configfile option",
  );
}

{
  local @ARGV = ('moo', @configfile_args, qw(-C 19));
  eval { $cmd->run };
  
  like(
    $@,
    $success,
    "command succeeded with -c option followed by configfile option",
  );
}
