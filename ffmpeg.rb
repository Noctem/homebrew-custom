class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.2.2.tar.xz"
  sha256 "cb754255ab0ee2ea5f66f8850e1bd6ad5cac1cd855d0a2f4990fb8c668b0d29c"
  head "https://github.com/FFmpeg/FFmpeg.git"
  revision 2

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build

  depends_on "aom" => :recommended
  depends_on "fdk-aac" => :recommended
  depends_on "gnutls" => :recommended
  depends_on "libass" => :recommended
  depends_on "libbluray" => :recommended
  depends_on "rtmpdump" => :recommended
  depends_on "wavpack" => :recommended
  depends_on "webp" => :recommended
  depends_on "zimg" => :recommended
  depends_on "chromaprint" => :optional
  depends_on "noctem/custom/decklink-sdk" => :optional
  depends_on "frei0r" => :optional
  depends_on "libsoxr" => :optional
  depends_on "libvidstab" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "openh264" => :optional
  depends_on "openjpeg" => :optional
  depends_on "rubberband" => :optional
  depends_on "speex" => :optional
  depends_on "tesseract" => :optional
  depends_on "xvid" => :optional
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "lame"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "theora"
  depends_on "x264"
  depends_on "x265"
  depends_on "xz"

  def install
    ENV.append "CFLAGS", "-fno-stack-check"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --cpu=native
      --enable-ffplay
      --enable-gpl
      --enable-lto
      --enable-pthreads
      --enable-shared
      --enable-version3
      --enable-libfontconfig
      --enable-libfreetype
      --enable-libmp3lame
      --enable-libopus
      --enable-libsnappy
      --enable-libtheora
      --enable-libvorbis
      --enable-libvpx
      --enable-libx264
      --enable-libx265
      --enable-lzma
      --enable-videotoolbox
      --disable-libjack
      --disable-indev=jack
    ]

    args << "--enable-chromaprint" if build.with? "chromaprint"
    args << "--enable-decklink" if build.with? "decklink-sdk"
    args << "--enable-frei0r" if build.with? "frei0r"
    args << "--enable-gnutls" if build.with? "gnutls"
    args << "--enable-libaom" if build.with? "aom"
    args << "--enable-libass" if build.with? "libass"
    args << "--enable-libbluray" if build.with? "libbluray"
    args << "--enable-libfdk-aac" << "--enable-nonfree" if build.with? "fdk-aac"
    args << "--enable-libopencore-amrnb" << "--enable-libopencore-amrwb" if build.with? "opencore-amr"
    args << "--enable-libopenh264" if build.with? "openh264"
    args << "--enable-libopenjpeg" if build.with? "openjpeg"
    args << "--enable-librtmp" if build.with? "rtmpdump"
    args << "--enable-librubberband" if build.with? "rubberband"
    args << "--enable-libsoxr" if build.with? "libsoxr"
    args << "--enable-libspeex" if build.with? "speex"
    args << "--enable-libtesseract" if build.with? "tesseract"
    args << "--enable-libvidstab" if build.with? "libvidstab"
    args << "--enable-libwavpack" if build.with? "wavpack"
    args << "--enable-libwebp" if build.with? "webp"
    args << "--enable-libxvid" if build.with? "xvid"
    args << "--enable-libzimg" if build.with? "zimg"

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }

    # Fix for Non-executables that were installed to bin/
    mv bin/"python", pkgshare/"python", :force => true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
