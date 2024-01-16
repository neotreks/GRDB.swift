// Export the underlying SQLite library
#if SWIFT_PACKAGE
@_exported import CSQLite
#elseif GRDBCIPHER
@_exported import AccuTerraSQLCipher
#elseif !GRDBCUSTOMSQLITE && !GRDBCIPHER
@_exported import SQLite3
#endif
