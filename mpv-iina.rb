class MpvIina < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.30.0.tar.gz"
  sha256 "33a1bcb7e74ff17f070e754c15c52228cf44f2cefbfd8f34886ae81df214ca35"
  head "https://github.com/mpv-player/mpv.git"

  keg_only "this formula is only used for building IINA, not recommended for daily use"

  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "noctem/custom/ffmpeg-iina"
  depends_on "noctem/custom/lua@5.2"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "libbluray"
  depends_on "mujs"
  depends_on "uchardet"
  depends_on "youtube-dl"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    args = %W[
      --prefix=#{prefix}
      --enable-javascript
      --enable-libmpv-shared
      --enable-lua
      --enable-libarchive
      --enable-uchardet
      --enable-libbluray
      --disable-debug-build
      --disable-macos-touchbar
      --disable-manpage-build
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
    ]

    system "./bootstrap.py"
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
