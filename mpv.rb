class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.33.1.tar.gz"
  sha256 "100a116b9f23bdcda3a596e9f26be3a69f166a4f1d00910d1789b6571c46f3a9"
  license :cannot_represent
  head "https://github.com/mpv-player/mpv.git"

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on xcode: :build

  depends_on "vapoursynth" => :recommended

  depends_on "noctem/custom/ffmpeg"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "luajit-openresty"
  depends_on "mujs"
  depends_on "uchardet"
  depends_on "youtube-dl"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"
    
    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    # luajit-openresty is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["luajit-openresty"].opt_lib/"pkgconfig"

    args = %W[
      --prefix=#{prefix}
      --enable-html-build
      --enable-javascript
      --enable-libmpv-shared
      --enable-lua
      --enable-libarchive
      --enable-uchardet
      --disable-macos-touchbar
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --zshdir=#{zsh_completion}
      --lua=luajit
    ]

    system Formula["python@3.9"].opt_bin/"python3", "bootstrap.py"
    system Formula["python@3.9"].opt_bin/"python3", "waf", "configure", *args
    system Formula["python@3.9"].opt_bin/"python3", "waf", "install"

    system Formula["python@3.9"].opt_bin/"python3", "TOOLS/osxbundle.py", "build/mpv"
    prefix.install "build/mpv.app"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
