class FfmpegIina < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.4.tar.xz"
  sha256 "06b10a183ce5371f915c6bb15b7b1fffbe046e8275099c96affc29e17645d909"
  license "GPL-2.0-or-later"
  head "https://github.com/FFmpeg/FFmpeg.git"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  keg_only "This formula is intended to only be used for building IINA. It is not recommended for daily use."

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

  depends_on "dav1d"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gnutls"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libsoxr"
  depends_on "rtmpdump"
  depends_on "rubberband"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zeromq"
  depends_on "zimg"

  def install
    args = %W[
      --prefix=#{prefix}
      --cpu=native
      --enable-shared
      --enable-pthreads
      --enable-version3
      --enable-hardcoded-tables
      --enable-avresample
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-gnutls
      --enable-nonfree
      --enable-gpl
      --enable-gray
      --enable-lto
      --enable-libbluray
      --enable-libdav1d
      --enable-librubberband
      --enable-libsnappy
      --enable-libfontconfig
      --enable-libfreetype
      --enable-libass
      --enable-librtmp
      --enable-videotoolbox
      --enable-libzmq
      --enable-libzimg
      --disable-libjack
      --disable-indev=jack
      --enable-libsoxr
      --disable-doc
      --disable-encoders
      --disable-programs
      --disable-muxers
    ]

    system "./configure", *args
    system "make", "install"
  end
end
