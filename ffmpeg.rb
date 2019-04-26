class Ffmpeg < Formula
  desc "ffmpeg with fdk-aac, wavpack, and zimg"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.1.3.tar.xz"
  sha256 "0c3020452880581a8face91595b239198078645e7d7184273b8bcc7758beb63d"
  revision 1
  head "https://github.com/FFmpeg/FFmpeg.git"

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build

  depends_on "aom"
  depends_on "fdk-aac"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "rtmpdump"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "theora"
  depends_on "wavpack"
  depends_on "x264"
  depends_on "x265"
  depends_on "xz"
  depends_on "zimg"

  def install
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-avresample
      --enable-ffplay
      --enable-gpl
      --enable-hardcoded-tables
      --enable-nonfree
      --enable-pthreads
      --enable-shared
      --enable-version3
      --enable-frei0r
      --enable-gnutls
      --enable-libaom
      --enable-libass
      --enable-libbluray
      --enable-libfdk-aac
      --enable-libfontconfig
      --enable-libfreetype
      --enable-libmp3lame
      --enable-libopus
      --enable-librtmp
      --enable-libsnappy
      --enable-libtheora
      --enable-libvorbis
      --enable-libvpx
      --enable-libwavpack
      --enable-libx264
      --enable-libx265
      --enable-libzimg
      --enable-lzma
      --enable-videotoolbox
      --disable-libjack
      --disable-indev=jack
    ]

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
