require 'formula'

class Kettle < Formula
  homepage 'http://community.pentaho.com/projects/data-integration/'
  url 'https://sourceforge.net/projects/pentaho/files/Data%20Integration/5.0.1-stable/pdi-ce-5.0.1-stable.zip'
  sha1 'c34fa3dbe8b75280fd3f7ddcaf609acbcdd2ed78'

  def install
    rm Dir['*.{bat}']
    libexec.install Dir['*']

    (var + 'log/kettle').mkpath
    (etc + 'kettle/simple-jndi').mkpath

    carte_password_config_file = etc + 'kettle/pwd/kettle.pwd'
    carte_password_config_file.write carte_password_config_content unless carte_password_config_file.exist?

    carte_server_config_file = etc + 'kettle/carte.xml'
    carte_server_config_file.write carte_server_config_content unless carte_server_config_file.exist?
  end

  def carte_password_config_content; <<-EOS.undent
    cluster:cluster
    EOS
  end

  def carte_server_config_content; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <slave_config>
      <!-- Uncomment to specify a local repository -->
      <!--
      <repository>
        <name>FOO</name>
      </repository>
      -->
      <slaveserver>
        <name>localhost</name>
        <hostname>localhost</hostname>
        <port>8080</port>
        <username>cluster</username>
        <password>cluster</password>
        <master>N</master>
      </slaveserver>
    </slave_config>
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_libexec}/carte.sh</string>
          <string>#{etc}/kettle/carte.xml</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{etc}/kettle</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>KETTLE_HOME</key>
          <string>#{etc}/kettle</string>
        </dict>
        <key>StandardOutPath</key>
        <string>#{var}/log/kettle/carte.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kettle/carte.log</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
