java -Xmx640M -Xms128M -Xverify:none -Doracle.ide.util.AddinPolicyUtils.OVERRIDE_FLAG=true -Dsun.java2d.ddoffscreen=false -Dwindows.shell.font.languages= -XX:MaxPermSize=128M -Dide.AssertTracingDisabled=true -Doracle.ide.util.AddinPolicyUtils.OVERRIDE_FLAG=true -Djava.util.logging.config.file=logging.conf -Dsqldev.debug=false -Dide.conf="./sqldeveloper.conf" -Dide.startingcwd="." -classpath ../../ide/lib/ide-boot.jar oracle.ide.boot.Launcher