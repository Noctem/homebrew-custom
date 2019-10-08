class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  url "https://static.rust-lang.org/dist/rustc-1.38.0-src.tar.gz"
  sha256 "644263ca7c7106f8ee8fcde6bb16910d246b30668a74be20b8c7e0e9f4a52d80"
  head "https://github.com/rust-lang/rust.git"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  def install
    mv "config.toml.example", "config.toml"
    inreplace "config.toml" do |s|
      s.gsub! '#prefix = "/usr/local"', "prefix = \"#{prefix}\""
      s.gsub! '#sysconfdir = "/etc"', "sysconfdir = \"#{etc}\""
      s.gsub! "#extended = false", "extended = true"
      s.gsub! '#channel = "dev"', 'channel = "stable"'
      s.gsub! '[target.x86_64-unknown-linux-gnu]', '[target.x86_64-apple-darwin]'
      s.gsub! '#cc = "cc"', 'cc = "/usr/local/opt/llvm/bin/clang"'
      s.gsub! '#ar = "ar"', 'ar = "/usr/local/opt/llvm/bin/llvm-ar"'
      s.gsub! '#ranlib = "ranlib"', 'ranlib = "/usr/local/opt/llvm/bin/llvm-ranlib"'
      s.gsub! '#llvm-config = "../path/to/llvm/root/bin/llvm-config"', 'llvm-config = "/usr/local/opt/llvm/bin/llvm-config"'
    end

    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["CC"] = "/usr/local/opt/llvm/bin/clang"
    ENV["CXX"] = "/usr/local/opt/llvm/bin/clang++"

    # Fix build failure for cmake v0.1.24 "error: internal compiler error:
    # src/librustc/ty/subst.rs:127: impossible case reached" on 10.11, and for
    # libgit2-sys-0.6.12 "fatal error: 'os/availability.h' file not found
    # #include <os/availability.h>" on 10.11 and "SecTrust.h:170:67: error:
    # expected ';' after top level declarator" among other errors on 10.12
    ENV["SDKROOT"] = MacOS.sdk_path

    system "./x.py", "build"
    system "./x.py", "install"

    # Remove any binary files; as Homebrew will run ranlib on them and barf.
    rm_rf Dir["src/{llvm-project,llvm-emscripten,test,librustdoc,etc/snapshot.pyc}"]
    (pkgshare/"rust_src").install Dir["src/*"]

    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      chmod 0444, dylib
    end
  end

  test do
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end
