class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++ (with symbols)"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.11.0.tar.xz"
  sha256 "f7874da2aeb8c018fd77df40b2137879bf90b66f5589490c991e83fb3e8094be"
  revision 1
  head "https://github.com/randombit/botan.git"

  bottle do
  end

  depends_on "pkg-config" => :build
  depends_on "balena/with-dsym/openssl@1.1"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cpu=#{MacOS.preferred_arch}
      --cc=#{ENV.compiler}
      --os=darwin
      --with-openssl
      --with-zlib
      --with-bzip2
      --extra-cxxflags=-g3\\ -gdwarf-4
      --with-external-includedir=#{Formula["balena/with-dsym/openssl@1.1"].opt_include}
      --with-external-libdir=#{Formula["balena/with-dsym/openssl@1.1"].opt_lib}
    ]

    system "./configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write Utils.popen_read("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
