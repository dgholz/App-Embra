use strict;
use warnings;

package App::Embra::MVP::Assembler;

# ABSTRACT: App::Embra-specific subclass of Config::MVP::Assembler

use App::Embra::Util qw< expand_config_package_name >;

use Moo;
use Method::Signatures;
use Params::Util qw(_HASHLIKE _ARRAYLIKE);
extends 'Config::MVP::Assembler';
with 'Config::MVP::Assembler::WithBundles';

=head1 DESCRIPTION

This extends L<Config::MVP::Assembler> and composes L<Config::MVP::Assembler::WithBundles>, to allow plugins composing L<App::Embra::Role::PluginBundle> to add multiple plugins at once.

Its C<L</expand_package>> method delegates to L<App::Embra::Util/expand_config_package_name>.

=cut

=method expand_package

    $assmbler->expand_package( $section_name );

Returns the full package name for a section in F<embra.ini>. This is required by L<Config::MVP::Assembler> and should not be called by any other module; use L<App::Embra::Util/expand_config_package_name> directly instead.

=cut

method expand_package( $pkg_name ) {
    expand_config_package_name( $pkg_name );
}

=method package_bundle_method($pkg) {

    $assembler->package_bundle_method( $pkg );

Returns the method name to invoke on C<$pkg> to get the config for its bundled plugins. This is required by L<Config::MVP::Assembler>. Defaults to C<undef> if C<$pkg> does not consume L<App::Embra::Role::PluginBundle> (i.e. it is not a plugin bundle), C<bundled_plugins_config> otherwise.

=cut

method package_bundle_method( $pkg ) {
    return if not $pkg->DOES('App::Embra::Role::PluginBundle');
    return 'bundled_plugins_config';
}

sub _add_bundle_contents {
  my ($self, $method, $arg) = @_;

  my @bundle_config = $arg->{package}->$method($arg);

  PLUGIN: for my $plugin (@bundle_config) {
    my ($name, $package, $payload) = @$plugin;

    my $section = $self->section_class->new({
      name    => $name,
      package => $package,
    });

    if (my $method = $self->package_bundle_method( $package )) {
      $self->_add_bundle_contents($method, {
        name    => $name,
        package => $package,
        payload => $payload,
      });
    } else {
      if (_HASHLIKE($payload)) {
        # XXX: Clearly this is a hack. -- rjbs, 2009-08-24
        for my $name (keys %$payload) {
          my @v = ref $payload->{$name}
                ? @{$payload->{$name}}
                : $payload->{$name};
          Carp::confess("got impossible zero-value <$name> key")
            unless @v;
          $section->add_value($name => $_) for @v;
        }
      } elsif (_ARRAYLIKE($payload)) {
        for (my $i = 0; $i < @$payload; $i += 2) {
          $section->add_value(@$payload[ $i, $i + 1 ]);
        }
      } else {
        Carp::confess("don't know how to interpret section payload $payload");
      }

      $self->sequence->add_section($section);
      $section->finalize;
    }
  }
}

1;
