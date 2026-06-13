import XCTest
@testable import ZenApplication

final class ApplicationVersionComparatorTests: XCTestCase {

	// MARK: - Stored Properties

	private let comparator = ApplicationVersionComparator()

	// MARK: - Tests

	func testCompareOrdersDifferentNumericComponents() {
		assertCompare("1.2.3", "1.2.4", .orderedAscending)
		assertCompare("1.3.0", "1.2.9", .orderedDescending)
		assertCompare("2.0", "10.0", .orderedAscending)
	}

	func testCompareTreatsMissingComponentsAsZeroes() {
		assertCompare("1.2", "1.2.0", .orderedSame)
		assertCompare("1", "1.0.0", .orderedSame)
		assertCompare("1.0.1", "1", .orderedDescending)
	}

	func testCompareIgnoresLeadingZeroes() {
		assertCompare("1.02.003", "1.2.3", .orderedSame)
		assertCompare("1.00000010", "1.2", .orderedDescending)
	}

	func testCompareUsesOnlyNumericPrefixOfComponent() {
		assertCompare("1.2-beta", "1.2", .orderedSame)
		assertCompare("1.2.3-rc1", "1.2.4", .orderedAscending)
		assertCompare("1.beta.1", "1.0.0", .orderedDescending)
	}

	func testComparePreservesEmptyComponentsAsZeroes() {
		assertCompare("1..2", "1.0.2", .orderedSame)
		assertCompare("1..2", "1.2", .orderedAscending)
		assertCompare(".1", "0.1", .orderedSame)
	}

	func testCompareHandlesComponentsLargerThanIntMax() {
		assertCompare(
			"1.999999999999999999999999999999",
			"1.2",
			.orderedDescending
		)
		assertCompare(
			"1.100000000000000000000000000000",
			"1.99999999999999999999999999999",
			.orderedDescending
		)
	}

	// MARK: - Assertions

	private func assertCompare(
		_ lhsVersion: String,
		_ rhsVersion: String,
		_ expectedResult: ApplicationVersionComparator.ComparisonResult,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		XCTAssertEqual(
			comparator.compare(lhsVersion, rhsVersion),
			expectedResult,
			file: file,
			line: line
		)
	}

}
