requires "App::Cmd::Setup" => "0";
requires "CPAN::Meta::Requirements" => "0";
requires "Class::Load" => "0";
requires "Config::INI::Reader" => "0";
requires "Config::MVP::Assembler" => "0";
requires "Config::MVP::Assembler::WithBundles" => "0";
requires "Config::MVP::Reader::Finder" => "0";
requires "Config::MVP::Reader::INI" => "2";
requires "File::Basename" => "0";
requires "File::Spec::Functions" => "0";
requires "List::MoreUtils" => "0";
requires "Log::Any" => "0";
requires "Log::Any::Adapter" => "0";
requires "Method::Signatures" => "0";
requires "Moo" => "0";
requires "Moo::Role" => "0";
requires "Path::Class" => "0";
requires "Path::Class::Dir" => "0";
requires "String::RewritePrefix" => "0";
requires "Template" => "0";
requires "Text::Markdown" => "0";
requires "Try::Tiny" => "0";
requires "YAML::XS" => "0";
requires "overload" => "0";
requires "perl" => "5.010";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Config::MVP::Reader::Hash" => "0";
  requires "List::Util" => "0";
  requires "Role::Tiny" => "0";
  requires "Test::Exception" => "0";
  requires "Test::Roo" => "0";
  requires "Test::Roo::Role" => "0";
  requires "lib" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";

  requires "Pod::Elemental::Transformer::List" => "0";
  requires "Dist::Zilla::Plugin::GithubMeta" => "0";
  requires "Dist::Zilla::Plugin::AutoPrereqs" => "0";
  requires "Dist::Zilla::Plugin::CheckChangesHasContent" => "0";
  requires "Dist::Zilla::Plugin::CopyFilesFromBuild" => "0";
  requires "Dist::Zilla::Plugin::Git::GatherDir" => "0";
  requires "Dist::Zilla::Plugin::Git::NextVersion" => "0";
  requires "Dist::Zilla::Plugin::Git::Tag" => "0";
  requires "Dist::Zilla::Plugin::NextRelease" => "0";
  requires "Dist::Zilla::Plugin::PkgVersion" => "0";
  requires "Dist::Zilla::Plugin::PodCoverageTests" => "0";
  requires "Dist::Zilla::Plugin::PodSyntaxTests" => "0";
  requires "Dist::Zilla::Plugin::PodWeaver" => "0";
  requires "Dist::Zilla::Plugin::Prereqs::FromCPANfile" => "0";
  requires "Dist::Zilla::Plugin::Run" => "0";
  requires "Dist::Zilla::Plugin::Test::Perl::Critic" => "0";
  requires "Dist::Zilla::PluginBundle::Basic" => "0";
  requires "Dist::Zilla::PluginBundle::Filter" => "0";
}
