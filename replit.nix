# Nix configuration for CodeWiki AI dependencies
{ pkgs }: {
  deps = [
    # Python and Node.js
    pkgs.python311
    pkgs.python311Packages.pip
    pkgs.nodejs_20
    pkgs.npm-check-updates
    
    # System dependencies
    pkgs.curl
    pkgs.git
    pkgs.bash
    pkgs.procps
    pkgs.killall
    
    # For Ollama (if available)
    pkgs.glibc
    pkgs.stdenv.cc.cc.lib
  ];
  
  env = {
    PYTHON_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      pkgs.glibc
    ];
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.glibc
    ];
    PYTHONPATH = ".";
  };
}