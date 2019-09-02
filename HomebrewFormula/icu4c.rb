class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization (with symbols)"
  homepage "https://ssl.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/64.2/icu4c-64_2-src.tgz"
  mirror "https://github.com/unicode-org/icu/releases/download/release-64-2/icu4c-64_2-src.tgz"
  version "64.2"
  sha256 "627d5d8478e6d96fc8c90fed4851239079a561a6a8b9e48b0892f24e82d31d6c"

  bottle do
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    ENV.prepend "CFLAGS", "-g -gdwarf"
    ENV.prepend "CXXFLAGS", "-g -gdwarf"

    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"

      "post_install.sh".write <<-EOS
        set -e
        for lib in #{lib}/lib*.dylib do
          if [ -L ${lib} ]; then continue; fi
          dsymutil ${lib} -o ${lib}.dSYM
          strip -x ${lib}
        done
      EOS
      system "bash", "./post_install.sh"
    end
  end

  test do
    system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
  end
end
