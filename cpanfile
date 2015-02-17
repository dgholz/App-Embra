requires "App::Cmd::Setup" => "0";
requires "CPAN::Meta::Requirements" => "0";
requires "Class::Inspector" => "0";
requires "Class::Load" => "0";
requires "Config::INI::Reader" => "0";
requires "Config::MVP::Assembler" => "0";
requires "Config::MVP::Assembler::WithBundles" => "0";
requires "Config::MVP::Reader::Finder" => "0";
requires "Config::MVP::Reader::INI" => "2";
requires "Exporter" => "0";
requires "File::Basename" => "0";
requires "File::ShareDir" => "0";
requires "File::Spec::Functions" => "0";
requires "List::MoreUtils" => "0";
requires "Log::Any" => "0";
requires "Log::Any::Adapter" => "0";
requires "Log::Any::Adapter::Dispatch" => "0";
requires "Method::Signatures" => "0";
requires "Module::Runtime" => "0";
requires "Moo" => "0";
requires "Moo::Role" => "0";
requires "Path::Class" => "0";
requires "Path::Class::Dir" => "0";
requires "String::RewritePrefix" => "0";
requires "Template" => "0";
requires "Text::Markdown" => "0";
requires "Try::Tiny" => "0";
requires "YAML::XS" => "0";
requires "base" => "0";
requires "feature" => "0";
requires "overload" => "0";
requires "perl" => "5.010";
requires "strict" => "0";
requires "vars" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Config::MVP::Reader::Hash" => "0";
  requires "List::Util" => "0";
  requires "Test::Exception" => "0";
  requires "Test::Roo" => "0";
  requires "Test::Roo::Role" => "0";
  requires "lib" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::ShareDir::Install" => "0.06";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
};
