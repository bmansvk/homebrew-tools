class Tsocks < Formula
  desc "Library for intercepting network connections and redirecting them through SOCKS"
  homepage "https://github.com/pc/tsocks"
  head "https://github.com/pc/tsocks.git"

  depends_on "autoconf" => :build

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-conf=#{etc}/tsocks.conf"

    # Flexible pattern to set library directory
    inreplace "tsocks" do |s|
      s.gsub! /^LIBDIR=.*$/, "LIBDIR=\"#{lib}\""
    end

    system "make"
    system "make", "install"

    etc.install "tsocks.conf.simple.example" => "tsocks.conf"
  end

  def caveats
    <<~EOS
      tsocks configuration file installed to:
        #{etc}/tsocks.conf

      Edit this file to configure your SOCKS proxy settings.
    EOS
  end

  test do
    # Test that the binary exists and can be invoked
    system "#{bin}/tsocks", "-h"
  end
end
