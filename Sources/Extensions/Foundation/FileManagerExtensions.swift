//
//  FileManagerExtensions.swift
//  SwifterSwift
//
//  Created by Jason Jon E. Carreos on 05/02/2018.
//  Copyright © 2018 SwifterSwift
//

#if canImport(Foundation)
import Foundation

public extension FileManager {

    /// SwifterSwift: Read from a JSON file at a given path.
    ///
    /// - Parameters:
    ///   - path: JSON file path.
    ///   - options: JSONSerialization reading options.
    /// - Returns: Optional dictionary.
    /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
    public func jsonFromFile(
        atPath path: String,
        readingOptions: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {

        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)

        return json as? [String: Any]
    }

    /// SwifterSwift: Read from a JSON file with a given filename.
    ///
    /// - Parameters:
    ///   - filename: File to read.
    ///   - bundleClass: Bundle where the file is associated.
    ///   - readingOptions: JSONSerialization reading options.
    /// - Returns: Optional dictionary.
    /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
    public func jsonFromFile(
        withFilename filename: String,
        at bundleClass: AnyClass? = nil,
        readingOptions: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
        // https://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift

        // To handle cases that provided filename has an extension
        let name = filename.components(separatedBy: ".")[0]
        let bundle = bundleClass != nil ? Bundle(for: bundleClass!) : Bundle.main

        if let path = bundle.path(forResource: name, ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)

            return json as? [String: Any]
        }

        return nil
    }

    /// SwifterSwift: Save Encodable object to a given URL.
    ///
    /// - Parameters:
    ///   - object: Object of type T that conforms to Encodable protocol.
    ///   - encoder: JSONEncoder.
    ///   - url: URL to save object to.
    ///   - attributes: A dictionary containing the attributes to associate with the new file. You can use these attributes to set the owner and group numbers, file permissions, and modification date. For a list of keys, see FileAttributeKey. Set to nil by default.
    /// - Throws: Throws any errors thrown by JSONEncoder or FileManager.
    public func encodeJSON<T: Encodable>(_ object: T, using encoder: JSONEncoder = JSONEncoder(), to url: URL, attributes: [FileAttributeKey: Any]? = nil) throws -> Bool {
        let data = try encoder.encode(object)
        return createFile(atPath: url.path, contents: data, attributes: attributes)
    }

    /// Creates a unique directory for saving temporary files.
    ///
    /// The directory can be used to create multiple temporary files used for a common purpose.
    ///
    ///     let tempDirectory = try fileManager.createTemporaryDirectory()
    ///     let tempFile1URL = tempDirectory.appendingPathComponent(ProcessInfo().globallyUniqueString)
    ///     let tempFile2URL = tempDirectory.appendingPathComponent(ProcessInfo().globallyUniqueString)
    ///
    /// - Returns: A URL to a new directory for saving temporary files.
    /// - Throws: An error if a temporary directory cannot be found or created.
    public func createTemporaryDirectory() throws -> URL {
        let temporaryDirectoryURL: URL
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            temporaryDirectoryURL = temporaryDirectory
        } else {
            temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
        return try url(for: .itemReplacementDirectory,
                       in: .userDomainMask,
                       appropriateFor: temporaryDirectoryURL,
                       create: true)
    }

}
#endif
