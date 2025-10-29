class Ocproxy < Formula
  desc "User-level SOCKS and port forwarding proxy for OpenConnect"
  homepage "https://github.com/bmansvk/ocproxy"
  head "https://github.com/bmansvk/ocproxy.git"

  # Uncomment these lines when you create a stable release:
  # url "https://github.com/bmansvk/ocproxy/archive/refs/tags/v1.60.tar.gz"
  # sha256 "REPLACE_WITH_ACTUAL_SHA256"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent"

  def install
    system "./autogen.sh"
    system "./configure",
           "--prefix=#{prefix}",
           "CPPFLAGS=-I#{Formula["libevent"].opt_include}",
           "LDFLAGS=-L#{Formula["libevent"].opt_lib}"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      ocproxy should be run via OpenConnect using the --script-tun option:

        openconnect --script-tun --script \\
          "ocproxy -D 11080 -L 2222:host:22" \\
          vpn.example.com

      Common options:
        -D port                 SOCKS5 server on PORT
        -H port                 HTTP proxy server on PORT
        -L lport:rhost:rport    Port forwarding
        -l file                 Log requests to FILE
        -g                      Allow non-local clients
        -k interval             TCP keepalive interval

      See 'man ocproxy' or the README for more information.
    EOS
  end

  test do
    # Test that the binary exists and shows help
    assert_match "ocproxy", shell_output("#{bin}/ocproxy --help 2>&1", 1)
  end
end
