class DecklinkSdk < Formula
  desc "BlackMagic Design DeckLink Software Development Kit headers"
  homepage "https://www.blackmagicdesign.com/support/family/capture-and-playback"
  url "https://github.com/Noctem/DeckLink-SDK/releases/download/v11.4/decklinksdk-11.4.tar.xz"
  sha256 "015ee778365256a47bfd3913aaeccf1fecaeb7b16f2794b73dea6ed8022a01bf"

  def install
    include.install Dir["include/*"]
  end
end
