// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class BroadcastConfigurationPlistReaderTests: UnitTestCase {

    private var sut: BroadcastConfigurationPlistReader!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = .init()
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testReadShouldThrowAnErrorWhenTheURLProvidedIsNotAPlistFile() throws {
        let fileURL = fileResource(named: "text", extension: "txt")

        assertThrows(try sut.read(fileURL: fileURL))
    }

    func testReadShouldReturnAnErrorWhenTheURLProvidedIsNotAFileURL() {
        let fileURL = URL(string: "https://www.kaleyra.com")!

        assertThrows(try sut.read(fileURL: fileURL))
    }

    func testReadShouldReturnAConfigObjectWithValuesTakenFromAValidPlist() throws {
        let fileURL = fileResource(named: "valid_config")

        let config = try sut.read(fileURL: fileURL)

        assertThat(config.appGroupID, equalTo("group.com.kaleyraVideo.AppName"))
        assertThat(config.extensionBundleID, equalTo("com.kaleyraVideo.AppName.Extension"))
    }

    func testReadShouldThrowAnErrorWhenThePlistDoesNotContainAnAppGroupId() throws {
        let fileURL = fileResource(named: "missing_group")

        assertThrows(try sut.read(fileURL: fileURL), equalTo(BroadcastConfigurationPlistReader.ReaderError.appGroupIdentifierMissing))
    }

    func testReadShouldThrowAnErrorWhenThePlistDoesNotContainTheExtensionBundleId() throws {
        let fileURL = fileResource(named: "missing_extension_identifier")

        assertThrows(try sut.read(fileURL: fileURL), equalTo(BroadcastConfigurationPlistReader.ReaderError.extensionBundleIdMissing))
    }

    func testReadShouldThrowAnErrorWhenThePlistDoesNotContainBroadcastKey() throws {
        let fileURL = fileResource(named: "missing_broadcast")

        assertThrows(try sut.read(fileURL: fileURL), equalTo(BroadcastConfigurationPlistReader.ReaderError.appGroupIdentifierMissing))
    }

    func testReadShouldThrowAnErrorWhenThePlistContainsANonStringValueAsTheAppGroupId() throws {
        let fileURL = fileResource(named: "mismatched_group")

        assertThrows(try sut.read(fileURL: fileURL), equalTo(BroadcastConfigurationPlistReader.ReaderError.appGroupIdentifierMissing))
    }

    func testReadShouldThrowAnErrorWhenThePlistContainsANonStringValueAsTheExtensionBundleId() throws {
        let fileURL = fileResource(named: "mismatched_extension_identifier")

        assertThrows(try sut.read(fileURL: fileURL), equalTo(BroadcastConfigurationPlistReader.ReaderError.extensionBundleIdMissing))
    }

    func testReadShouldThrowAnErrorWhenThePlistContainsAnEmptyStringAsTheAppGroupId() throws {
        let fileURL = fileResource(named: "empty_group")

        assertThrows(try sut.read(fileURL: fileURL), equalTo(BroadcastConfigurationPlistReader.ReaderError.appGroupIdentifierMissing))
    }

    func testReadShouldThrowAnErrorWhenThePlistContainsAnEmptyStringAsTheExtensionBundleId() throws {
        let fileURL = fileResource(named: "empty_extension_identifier")

        assertThrows(try sut.read(fileURL: fileURL), equalTo(BroadcastConfigurationPlistReader.ReaderError.extensionBundleIdMissing))
    }

    func testReadShouldThrowAnErrorWhenThePlistContainsTheDefaultValueAsTheAppGroupId() throws {
        let fileURL = fileResource(named: "not_available_group_identifier")

        assertThrows(try sut.read(fileURL: fileURL), equalTo(BroadcastConfigurationPlistReader.ReaderError.appGroupIdentifierMissing))
    }

    func testReadShouldThrowAnErrorWhenThePlistContainsTheDefaultValueAsTheExtensionBundleId() throws {
        let fileURL = fileResource(named: "not_available_extension_identifier")

        assertThrows(try sut.read(fileURL: fileURL), equalTo(BroadcastConfigurationPlistReader.ReaderError.extensionBundleIdMissing))
    }

    // MARK: - Helpers

    private func fileResource(named name: String, extension: String = "plist") -> URL {
        Bundle(for: Self.self).url(forResource: name, withExtension: `extension`)!
    }

}
