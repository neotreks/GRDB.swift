import XCTest

@testable import ATGRDB

class SQLExpressionLiteralTests: GRDBTestCase {
    
    func testWithArguments() throws {
        try DatabaseQueue().inDatabase { db in
            let expression = Column("foo").collating(.nocase) == "'fooéı👨👨🏿🇫🇷🇨🇮'" && Column("baz") >= 1
            let context = SQLGenerationContext(db)
            let sql = try expression.sql(context, wrappedInParenthesis: true)
            XCTAssertEqual(sql, "((\"foo\" = ? COLLATE NOCASE) AND (\"baz\" >= ?))")
            let values = context.arguments.values
            XCTAssertEqual(values.count, 2)
            XCTAssertEqual(values[0], "'fooéı👨👨🏿🇫🇷🇨🇮'".databaseValue)
            XCTAssertEqual(values[1], 1.databaseValue)
        }
    }
    
    func testWithoutArguments() throws {
        try DatabaseQueue().inDatabase { db in
            let expression = Column("foo").collating(.nocase) == "'fooéı👨👨🏿🇫🇷🇨🇮'" && Column("baz") >= 1
            let context = SQLGenerationContext(db, argumentsSink: .literalValues)
            let sql = try expression.sql(context, wrappedInParenthesis: true)
            XCTAssert(context.arguments.isEmpty)
            XCTAssertEqual(sql, "((\"foo\" = '''fooéı👨👨🏿🇫🇷🇨🇮''' COLLATE NOCASE) AND (\"baz\" >= 1))")
        }
    }
}
