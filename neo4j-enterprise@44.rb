class Neo4jEnterpriseAT44 < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "dist.neo4j.org/neo4j-enterprise-4.4.16-unix.tar.gz"
  sha256 "c4db0c4625e4c56a74140560601524bd6dd44e00de9b61b6c23cda71aaaf18c3"

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

  test do
    ENV["NEO4J_HOME"] = libexec
    ENV["NEO4J_LOG"] = testpath/"libexec/data/log/neo4j.log"
    ENV["NEO4J_PIDFILE"] = testpath/"libexec/data/neo4j-service.pid"
    mkpath testpath/"libexec/data/log"
    assert_match /Neo4j .*is not running/i, shell_output("#{bin}/neo4j status", 3)
  end
end
