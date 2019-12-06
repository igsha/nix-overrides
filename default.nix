self: super:

let
  fetchBranch = user-repo: branch: builtins.fetchTarball "https://api.github.com/repos/${user-repo}/tarball/${branch}";
  fetchMaster = user-repo: fetchBranch user-repo "master";
  youtube-dl-extractor = ./pkgs/youtube-dl/user_extractors.py;

in {
  neovim = (super.neovim.override {
    configure = import ./pkgs/vimrcConfig.nix { inherit (super) vimUtils vimPlugins fetchFromGitHub; };
  }).overrideAttrs (old: rec {
    buildCommand = old.buildCommand + ''
      substitute $out/share/applications/nvim.desktop $out/share/applications/nvim.desktop \
        --replace 'Exec=nvim' "Exec=xst -c editor -e nvim "
    '';
  });

  docx-combine = super.callPackage (fetchMaster "cvlabmiet/docx-combine") { };
  docx-replace = super.callPackage (fetchMaster "cvlabmiet/docx-replace") { };

  panflute = super.callPackage ./pkgs/panflute { };
  pantable = super.callPackage ./pkgs/pantable { };
  cxxopts = super.callPackage ./pkgs/cxxopts { };

  youtube-dl = (super.youtube-dl.overrideAttrs (old: rec {
    postPatch = ''
      cp ${youtube-dl-extractor} youtube_dl/extractor/user_extractors.py
      echo "from .user_extractors import *" >> youtube_dl/extractor/extractors.py
    '';
  })).override { phantomjsSupport = true; };

  inherit (super.callPackage ./pkgs/perl-packages {}) PandocElements;
  docproc = super.callPackage (fetchMaster "igsha/docproc") { };
  pandoc-pipe = super.callPackage (fetchMaster "igsha/pandoc-pipe") { };

  pandoc-release = super.callPackage ./pkgs/pandoc/2.8.1.nix { };
  pandoc-crossref-release = super.callPackage ./pkgs/pandoc-crossref/0.3.5.0b.nix { };
  pandoc = self.pandoc-release;
  pandoc-crossref = self.pandoc-crossref-release;

  iplay = super.callPackage (fetchMaster "igsha/iplay") { };
}
