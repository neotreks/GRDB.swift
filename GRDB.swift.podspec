Pod::Spec.new do |s|
  s.name     = 'AccuTerraGRDB.swift'
  s.version  = '5.6.0'
  
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A toolkit for SQLite databases, with a focus on application development.'
  s.homepage = 'https://github.com/groue/GRDB.swift'
  s.author   = { 'Gwendal Roué' => 'gr@pierlis.com' }
  s.source = {
    "git": "https://github.com/neotreks/GRDB.swift.git",
    "tag": "AccuTerrav5.6.0"
  }
  s.module_name = 'GRDB'
  
  s.swift_versions = ['5.3.2']
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.default_subspec  = 'SQLCipher'
  
  s.subspec 'standard' do |ss|
    ss.source_files = 'GRDB/**/*.swift', 'Support/grdb_config.h'
    ss.framework = 'Foundation'
    ss.library = 'sqlite3'
  end
  
  s.subspec 'SQLCipher' do |ss|
    ss.source_files = 'GRDB/**/*.swift', 'Support/SQLCipher_config.h'
    ss.framework = 'Foundation'
    ss.dependency 'SQLCipher'
    ss.xcconfig = {
      'OTHER_SWIFT_FLAGS' => '$(inherited) -D SQLITE_HAS_CODEC -D GRDBCIPHER -D SQLITE_ENABLE_FTS5',
      'OTHER_CFLAGS' => '$(inherited) -DSQLITE_HAS_CODEC -DGRDBCIPHER -DSQLITE_ENABLE_FTS5',
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) SQLITE_HAS_CODEC=1 GRDBCIPHER=1 SQLITE_ENABLE_FTS5=1'
    }
    ss.subspec 'SQLCipher' do |sss|
      sss.source_files         = 'SQLCipher/sqlite3.{h,c}'
      sss.ios.frameworks       = 'Foundation', 'Security'
      sss.compiler_flags       = '-DNDEBUG', '-DSQLITE_HAS_CODEC', '-DSQLITE_TEMP_STORE=2', '-DSQLITE_SOUNDEX', '-DSQLITE_THREADSAFE', '-DSQLITE_ENABLE_RTREE', '-DSQLITE_ENABLE_STAT3', '-DSQLITE_ENABLE_STAT4', '-DSQLITE_ENABLE_COLUMN_METADATA', '-DSQLITE_ENABLE_MEMORY_MANAGEMENT', '-DSQLITE_ENABLE_LOAD_EXTENSION', '-DSQLITE_ENABLE_FTS4', '-DSQLITE_ENABLE_FTS4_UNICODE61', '-DSQLITE_ENABLE_FTS3_PARENTHESIS', '-DSQLITE_ENABLE_UNLOCK_NOTIFY', '-DSQLITE_ENABLE_JSON1', '-DSQLITE_ENABLE_FTS5', '-DSQLCIPHER_CRYPTO_CC', '-DHAVE_USLEEP=1', '-DSQLITE_MAX_VARIABLE_NUMBER=99999', '-DSQLITE_ENABLE_MATH_FUNCTIONS'
      sss.pod_target_xcconfig  = { 'HEADER_SEARCH_PATHS' => '$(PODS_ROOT)/SQLCipher', 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) SQLITE_HAS_CODEC=1', 'OTHER_CFLAGS' => '$(inherited) -DSQLITE_HAS_CODEC -DSQLITE_TEMP_STORE=2 -DSQLITE_SOUNDEX -DSQLITE_THREADSAFE -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_STAT3 -DSQLITE_ENABLE_STAT4 -DSQLITE_ENABLE_COLUMN_METADATA -DSQLITE_ENABLE_MEMORY_MANAGEMENT -DSQLITE_ENABLE_LOAD_EXTENSION -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_FTS4_UNICODE61 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_UNLOCK_NOTIFY -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_FTS5 -DSQLCIPHER_CRYPTO_CC -DHAVE_USLEEP=1 -DSQLITE_MAX_VARIABLE_NUMBER=99999 -DSQLITE_ENABLE_MATH_FUNCTIONS' }
    end
  end
end
