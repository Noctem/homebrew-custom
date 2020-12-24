class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  url "https://static.rust-lang.org/dist/rustc-1.48.0-src.tar.gz"
  sha256 "0e763e6db47d5d6f91583284d2f989eacc49b84794d1443355b85c58d67ae43b"
  head "https://github.com/rust-lang/rust.git"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.9" => :build
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # fix compilation with `-Ctarget-cpu=native`
  patch :DATA

  def install
    mv "config.toml.example", "config.toml"
    inreplace "config.toml" do |s|
      s.gsub! '#prefix = "/usr/local"', "prefix = \"#{prefix}\""
      s.gsub! '#sysconfdir = "/etc"', "sysconfdir = \"#{etc}\""
      s.gsub! "#extended = false", "extended = true"
      s.gsub! '#channel = "dev"', 'channel = "stable"'
      s.gsub! '[target.x86_64-unknown-linux-gnu]', '[target.x86_64-apple-darwin]'
    end

    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    # Fix build failure for cmake v0.1.24 "error: internal compiler error:
    # src/librustc/ty/subst.rs:127: impossible case reached" on 10.11, and for
    # libgit2-sys-0.6.12 "fatal error: 'os/availability.h' file not found
    # #include <os/availability.h>" on 10.11 and "SecTrust.h:170:67: error:
    # expected ';' after top level declarator" among other errors on 10.12
    ENV["SDKROOT"] = MacOS.sdk_path

    system Formula["python@3.9"].bin/"python3", "x.py", "build"
    system Formula["python@3.9"].bin/"python3", "x.py", "install"

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
__END__
diff --git a/compiler/rustc_codegen_llvm/src/type_of.rs b/compiler/rustc_codegen_llvm/src/type_of.rs
index 8ea4768f77dbd..0876907e1194b 100644
--- a/compiler/rustc_codegen_llvm/src/type_of.rs
+++ b/compiler/rustc_codegen_llvm/src/type_of.rs
@@ -40,9 +40,7 @@ fn uncached_llvm_type<'a, 'tcx>(
         // FIXME(eddyb) producing readable type names for trait objects can result
         // in problematically distinct types due to HRTB and subtyping (see #47638).
         // ty::Dynamic(..) |
-        ty::Adt(..) | ty::Closure(..) | ty::Foreign(..) | ty::Generator(..) | ty::Str
-            if !cx.sess().fewer_names() =>
-        {
+        ty::Adt(..) | ty::Closure(..) | ty::Foreign(..) | ty::Generator(..) | ty::Str => {
             let mut name = with_no_trimmed_paths(|| layout.ty.to_string());
             if let (&ty::Adt(def, _), &Variants::Single { index }) =
                 (layout.ty.kind(), &layout.variants)
@@ -58,12 +56,6 @@ fn uncached_llvm_type<'a, 'tcx>(
             }
             Some(name)
         }
-        ty::Adt(..) => {
-            // If `Some` is returned then a named struct is created in LLVM. Name collisions are
-            // avoided by LLVM (with increasing suffixes). If rustc doesn't generate names then that
-            // can improve perf.
-            Some(String::new())
-        }
         _ => None,
     };
 