require "formula"

class Ots < Formula
  desc "OpenType font file sanitizer, used in Chrome and Firefox"
  homepage "https://github.com/khaledhosny/ots"
  url "https://github.com/khaledhosny/ots/archive/chrome-42.tar.gz"
  sha256 "95ba45c67ad369b886c9bb7009edc4fb91ba3636ccd6c1a7cad96f18c78418ce"
  version "chrome-42"
  head "https://github.com/khaledhosny/ots.git"

  # Autotools are required to build from source in all releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    if build.head?
      system "./autogen.sh"
      system "./configure"
    else
      system 'git clone https://github.com/google/brotli.git third_party/brotli'
      system "python gyp_ots -f make" # TODO this breaks if svn hasn't been used on code.google.com before
    end
    system "make"
    bin.install "ot-sanitise"
  end

  test do
    system "ot-sanitise /Library/Fonts/Arial.ttf"
  end
end
