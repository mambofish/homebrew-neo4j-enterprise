class Neo4jEnterprise < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "dist.neo4j.org/neo4j-enterprise-5.3.0-unix.tar.gz"
  sha256 "078aaf4da22ed43eae8164d8446b52c6d3751476db9000b83daa163dcf634bc2"

  depends_on "openjdk@11"

  def install
    ENV["NEO4J_HOME"] = libexec
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Symlink binaries
    bin.install Dir["#{libexec}/bin/neo4j{,-shell,-import,-shared.sh,-admin}", "#{libexec}/bin/cypher-shell"]
    bin.env_script_all_files(libexec/"bin", :NEO4J_HOME => ENV["NEO4J_HOME"])

    # Adjust UDC props
    # Suppress the empty, focus-stealing java gui. And don't call home to mama.
    (libexec/"conf/neo4j.conf").append_lines <<~EOS
      wrapper.java.additional=-Djava.awt.headless=true
      wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew
      dbms.udc.enabled=false 
    EOS
  end

  def post_install
    (var/"log").mkpath
  end

  service.require_root :manual => "neo4j start"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/neo4j</string>
          <string>console</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/neo4j.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/neo4j.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    ENV["NEO4J_HOME"] = libexec
    ENV["NEO4J_LOG"] = testpath/"libexec/data/log/neo4j.log"
    ENV["NEO4J_PIDFILE"] = testpath/"libexec/data/neo4j-service.pid"
    mkpath testpath/"libexec/data/log"
    assert_match /Neo4j .*is not running/i, shell_output("#{bin}/neo4j status", 3)
  end
end
