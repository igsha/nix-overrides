{ stdenv, lib, perlPackages, fetchurl }:

with perlPackages;
rec {
  Pandoc = buildPerlModule rec {
    pname = "Pandoc";
    version = "0.8.6";

    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VO/VOJ/${pname}-${version}.tar.gz";
      sha256 = "a4dd6a5c283ae2b87b920becd838713ebf75bdc6bbdfd16a8107a29c0948f316";
    };

    buildInputs = [ ModuleBuildTiny TestException ];
    propagatedBuildInputs = [ FileWhich IPCRun3 ];

    meta = {
      homepage = https://github.com/nichtich/Pandoc-Wrapper;
      description = "Wrapper for the mighty Pandoc document converter";
      license = lib.licenses.free;
    };
  };

  PandocElements = buildPerlModule rec {
    pname = "Pandoc-Elements";
    version = "0.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VO/VOJ/${pname}-${version}.tar.gz";
      sha256 = "8483ea4878519d6b33b79be648d6555ad9fb2415202b316c73bc43679d809df4";
    };

    buildInputs = [ ModuleBuildTiny TestException TestOutput TestWarnings ];
    propagatedBuildInputs = [ HashMultiValue IPCRun3 JSON Pandoc ];

    meta = with lib; {
      homepage = https://github.com/nichtich/Pandoc-Elements;
      description = "Create and process Pandoc documents";
      license = licenses.gpl2Plus;
      maintainer = maintainers.igsha;
    };
  };
}
