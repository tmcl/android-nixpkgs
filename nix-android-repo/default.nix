{ stdenv, makeWrapper, gradle, jdk }:

stdenv.mkDerivation rec {
  name = "nix-android-repo-${version}";
  version = "0.0.1";

  src = ./.;

  nativeBuildInputs = [ makeWrapper gradle ];

  buildInputs = [ jdk ];

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --no-daemon --offline --stacktrace installDist
  '';

  installPhase = ''
    mkdir -p $out
    cp -r build/install/nix-android-repo/* $out
  '';

  postFixup = ''
    wrapProgram $out/bin/nix-android-repo --set JAVA_HOME ${jdk.home}
  '';
}
