import XCTest
import GRDB

class RecordWithoutPersistenceConflictPolicy : Record {
}

class RecordWithPersistenceConflictPolicy : Record {
    override class var persistenceConflictPolicy: PersistenceConflictPolicy {
        PersistenceConflictPolicy(insert: .fail, update: .ignore)
    }
}

class RecordPersistenceConflictPolicyTests: GRDBTestCase {
    
    func testDefaultPersistenceConflictPolicy() {
        let record = RecordWithoutPersistenceConflictPolicy()
        let policy = type(of: record).persistenceConflictPolicy
        XCTAssertEqual(policy.conflictResolutionForInsert, .abort)
        XCTAssertEqual(policy.conflictResolutionForUpdate, .abort)
    }
    
    func testConfigurablePersistenceConflictPolicy() {
        let record = RecordWithPersistenceConflictPolicy()
        let policy = type(of: record).persistenceConflictPolicy
        XCTAssertEqual(policy.conflictResolutionForInsert, .fail)
        XCTAssertEqual(policy.conflictResolutionForUpdate, .ignore)
    }

}
