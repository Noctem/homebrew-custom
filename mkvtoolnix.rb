class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-31.0.0.tar.xz"
  sha256 "f98a8c3a00e48ceb9a56ec5cb1f89b7663bbc5ace88713f9f087fdaaa2501b35"

  bottle do
    cellar :any
    sha256 "0709bb1a2c0fe4f897a6dfdc20a14e3b98dbe324d83d04b0aaf7a41f0e995dff" => :mojave
    sha256 "4a3e05604e716d16a638ad9afd0733c35b29dcd4fc6f3aa13f60877e55a6dc36" => :high_sierra
    sha256 "d9df1172b5b51eaf1dffcc82eae86245777acb3fd195cb5fea943c12640ad56b" => :sierra
  end

  head do
    url "https://gitlab.com/mbunkus/mkvtoolnix.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "fmt" => :build
  depends_on "pkg-config" => :build
  depends_on "pugixml" => :build
  depends_on "boost"
  depends_on "cmark"
  depends_on "flac"
  depends_on "gettext"
  depends_on "libebml"
  depends_on "libmagic"
  depends_on "libmatroska"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "qt"

  patch do
    url "https://gitlab.com/mbunkus/mkvtoolnix/commit/71865d9081c2a9f65039012abd3a7ff8676d642a.diff"
    sha256 "851a2be9a29d2d1f65ab7536f6cd0c212170376bb59526897df636aad38b8cad"
  end


  def install
    ENV.cxx11

    features = %w[flac libebml libmagic libmatroska libogg libvorbis]
    extra_includes = ""
    extra_libs = ""
    features.each do |feature|
      extra_includes << "#{Formula[feature].opt_include};"
      extra_libs << "#{Formula[feature].opt_lib};"
    end
    extra_includes.chop!
    extra_libs.chop!

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--with-docbook-xsl-root=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl",
                          "--with-extra-includes=#{extra_includes}",
                          "--with-extra-libs=#{extra_libs}",
                          "--with-qt=#{Formula["qt"].opt_prefix}"
    system "rake", "-j#{ENV.make_jobs}"
    system "rake", "install"
  end

  test do
    mkv_path = testpath/"Great.Movie.mkv"
    sub_path = testpath/"subtitles.srt"
    sub_path.write <<~EOS
      1
      00:00:10,500 --> 00:00:13,000
      Homebrew
    EOS

    system "#{bin}/mkvmerge", "-o", mkv_path, sub_path
    system "#{bin}/mkvinfo", mkv_path
    system "#{bin}/mkvextract", "tracks", mkv_path, "0:#{sub_path}"
  end
end
