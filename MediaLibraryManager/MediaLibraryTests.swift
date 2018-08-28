//
//  MediaLibraryTests.swift
//  MediaLibraryManager
//
//  Created by Nikolah Pearce on 28/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

/**
JSON File for testing has these contents:

[{"fullpath": "/346/to/image1","type": "image","metadata": {"creator": "cre1","resolution": "res1"}},{"fullpath": "/346/to/image2","type": "image","metadata": {"creator": "cre2","resolution": "res2"}},{"fullpath": "/346/to/video3","type": "video","metadata": {"creator": "cre3","resolution": "res3","runtime": "run3"}}]

Located in the working directory and Home Directory of user in order to test.
*/

import Foundation

class MediaLibraryTests {
	
	let numberOfTests: Int = 17
	
	var library: Library
	var f1: MMFile
	var f2: MMFile
	var f3: MMFile
	var m1: [MMMetadata]
	var m2: [MMMetadata]
	var m3: [MMMetadata]
	
	var kv11: Metadata
	var kv12: Metadata
	var kv21: Metadata
	var kv22: Metadata
	var kv31: Metadata
	var kv32: Metadata
	var kv33: Metadata
	
	init() {
		library = Library()
		kv11 = Metadata(keyword: "creator", value: "cre1")
		kv12 = Metadata(keyword: "resolution", value: "res1")
		kv21 = Metadata(keyword: "creator", value: "cre2")
		kv22 = Metadata(keyword: "resolution", value: "res2")
		kv31 = Metadata(keyword: "creator", value: "cre3")
		kv32 = Metadata(keyword: "resolution", value: "res3")
		kv33 = Metadata(keyword: "runtime", value: "run3")
		m1 = [kv11, kv12]
		m2 = [kv21, kv22]
		m3 = [kv31, kv32, kv33]
		f1 = Image(metadata: m1, filename: "image1", path: "/346/to", creator: "cre1", resolution: "res1")
		f2 = Image(metadata: m2, filename: "image2", path: "/346/to", creator: "cre2", resolution: "res2")
		f3 = Video(metadata: m3, filename: "video3", path: "/346/to", creator: "cre3", resolution: "res3", runtime: "run3")
	}
	
	func setUp() {
		library = Library()
		kv11 = Metadata(keyword: "creator", value: "cre1")
		kv12 = Metadata(keyword: "resolution", value: "res1")
		kv21 = Metadata(keyword: "creator", value: "cre2")
		kv22 = Metadata(keyword: "resolution", value: "res2")
		kv31 = Metadata(keyword: "creator", value: "cre3")
		kv32 = Metadata(keyword: "resolution", value: "res3")
		kv33 = Metadata(keyword: "runtime", value: "run3")
		m1 = [kv11, kv12]
		m2 = [kv21,kv22]
		m3 = [kv31, kv32, kv33]
		f1 = Image(metadata: m1, filename: "image1", path: "/346/to", creator: "cre1", resolution: "res1")
		f2 = Image(metadata: m2, filename: "image2", path: "/346/to", creator: "cre2", resolution: "res2")
		f3 = Video(metadata: m3, filename: "video3", path: "/346/to", creator: "cre3", resolution: "res3", runtime: "run3")
	}
	
	func tearDown() {
		m1 = []
		m2 = []
		f1.metadata = m1
		f2.metadata = m2
		library.removeAllFiles()
	}
	
	// Calls all tests and runs them.
	func runAllTests() {
		
		setUp()
		testMetadata()
		print("\t✅ testMetadata() passed")
		tearDown()
		
		setUp()
		testFile()
		print("\t✅ testFile() passed")
		tearDown()

		setUp()
		testAddToLibrary()
		print("\t✅ testAddToLibrary() passed")
		tearDown()
		
		setUp()
		testAddMetadataToFile()
		print("\t✅ testAddMetadataToFile() passed")
		tearDown()
		
		setUp()
		testRemove()
		print("\t✅ testRemove() passed")
		tearDown()
		
		setUp()
		testSearch()
		print("\t✅ testSearch() passed")
		tearDown()

		setUp()
		testAll()
		print("\t✅ testAll() passed")
		tearDown()
		
		setUp()
		testFileValidator()
		print("\t❌ testFileValidator() passed")
		tearDown()

		setUp()
		testFileImporter()
		print("\t✅ testFileImporter() passed")
		tearDown()
		
		setUp()
		testFileExporter()
		print("\t❌ testFileExporter() passed")
		tearDown()
		
		setUp()
		testLoadCommand()
		print("\t❌ testLoadCommand() passed")
		tearDown()
		
		setUp()
		testListCommand()
		print("\t❌ testListCommand() passed")
		tearDown()
		
		setUp()
		testListAllCommand()
		print("\t❌ testListAllCommand() passed")
		tearDown()
		
		setUp()
		testSetCommand()
		print("\t❌ testSetCommand() passed")
		tearDown()
		
		setUp()
		testDeleteCommand()
		print("\t❌ testDeleteCommand() passed")
		tearDown()
		
		setUp()
		testSaveSearchCommand()
		print("\t❌ testSaveSearchCommand() passed")
		tearDown()
		
		setUp()
		testSaveCommand()
		print("\t❌ testSaveCommand() passed")
		tearDown()

	}
	
	func testMetadata() {
		let m3 = Metadata(keyword: "key3", value: "val3")
		assert(m3.keyword == "key3", "Keyword should match")
		assert(m3.value == "val3", "Value should match")
	}
	
	func testFile() {
		let f = Image(metadata: m1, filename: "f1", path: "p1", creator: "cre1", resolution: "res1")
		
		assert(f.type == "image", "File should be of type image")
		assert(f.path == "p1", "File should have correct path")
		assert(f.filename == "f1", "File should have correct filename ")
		assert(f.creator == "cre1", "File should have the same creator ")
		
		var metadata: [MMMetadata] = f.metadata
		var kv = metadata[0]
		var kv2 = metadata[1]
		
		assert(metadata.count == m1.count, "Metadata shold have the same size")
		
		assert(kv as! Metadata == kv11, "File metadata should be the same")
		assert(kv.keyword == "creator", "File m1 kv Keyword should match")
		assert(kv.value == "cre1", "File m1 kv Value should match")
		
		assert(kv2 as! Metadata == kv12, "File metadata should be the same")
		assert(kv2.keyword == "resolution", "File m1 kv2 Keyword should match")
		assert(kv2.value == "res1", "File m1 kv2 Value should match")
	}

	func testAddToLibrary() {
		precondition(library.count == 0, "Library should be empty.")
		
		library.add(file: f1)
		library.add(file: f2)

		var files = library.all()
		assert(library.count == 2, "Library should contain two files.")
		assert(files.count == 2, "Library should contain two files.")
		
		assert(files[0] as! File == f1 as! File,"F1 should exist in library.")
		assert(files[1] as! File == f2 as! File,"F2 should exist in library.")
	}
	
	func testAddMetadataToFile() {
		precondition(library.count == 0, "Library should be empty.")
		
		library.add(file: f1)
		assert(library.count == 1, "Library should contain one file.")
		
		var files = library.all()
		var file1 = files[0]
		var mdata: [MMMetadata] = file1.metadata
		
		assert(mdata[0] as! Metadata == kv11 , "Metadata should match original")
		assert(mdata[1] as! Metadata == kv12 , "Metadata should match original")
		assert(mdata.count == 2, "Metadata should contai only two values")
		
		let newKV: MMMetadata = Metadata(keyword: "newKey", value: "newVal")
		library.add(metadata: newKV, file: file1)
		
		assert(library.count == 1, "Library should contain one file still.")
		var newfiles = library.all()
		var newfile1 = newfiles[0]
		var newmdata: [MMMetadata] = newfile1.metadata
		
		assert(newmdata[0] as! Metadata == kv11 , "Metadata should match original")
		assert(newmdata[1] as! Metadata == kv12 , "Metadata should match original")
		assert(newmdata[2] as! Metadata == newKV , "Metadata should contain new value")
		assert(newmdata.count == 3, "Metadata should contain three values now")
		
		
	}
	
	func testRemove() {
		precondition(library.count == 0, "Library should be empty.")
		precondition(f1.metadata.count == 2, "f1 Metadata 1 should have two kv pairs.")
		precondition(m1.count == 2, "Metadata 1 should have two kv pairs.")
		
		let newKV: Metadata = Metadata(keyword: "test", value: "test1")
		let dummyKV: Metadata = Metadata(keyword: "dummy", value: "dummy1")
		
		m1.append(newKV)
		f1.metadata.append(newKV)
		library.add(file: f1)
		library.add(file: f2)
		
		assert(library.count == 2, "Library should contain two files.")
		assert(f1.metadata.count == 3, "f1 Metadata 1 should have three kv pairs.")
		assert(m1.count == 3, "Metadata 1 should have three kv pairs.")
		
		// remove not existing shouldn't crash
		library.remove(key: dummyKV.keyword, file: f1)
		assert(f1.metadata.count == 3, "f1 Metadata 1 should have three kv pairs still.")
		
		// remove a required should still be there
		// - except this check is never done in Library, only in DeleteCommand.
		//library.remove(key: kv11.keyword, file: f1)
		//assert(f1.metadata.count == 3, "f1 Metadata 1 should have three kv pairs still.")
		
		// remove existing should work
		library.remove(key: newKV.keyword, file: f1)
		assert(library.count == 2, "Library should contain two files.")
		assert(f1.metadata.count == 2, "f1 Metadata 1 should have two kv pairs after removing.")
		assert(m1.count == 3, "Metadata 1 should have three kv pairs.")
	}
	
	func testSearch() {
		precondition(library.count == 0, "Library should be empty.")
		library.add(file: f1)
		library.add(file: f2)
		assert(library.count == 2, "Library should contain two files.")

		// search for value should return 1 file
		var result: [MMFile] = library.search(term: "cre1")
		assert(result.count == 1, "search for value cre1 should return 1 file")
		assert(result[0] as! File == f1, "results should be f1")
		
		//search for requried mdata should return 2 files
		result = library.search(term: "creator")
		assert(result.count == 2, "search for key creator should return 2 files")
		assert(result[0] as! File == f1, "results should be f1")
		assert(result[1] as! File == f2, "results should be f2")
		
		// search for non existing should return nil
		result = library.search(term: "test")
		assert(result.count == 0, "search should be 0 files")
	}
	
	func testAll() {
		precondition(library.count == 0, "Library should be empty.")
		library.add(file: f1)
		library.add(file: f2)
		assert(library.count == 2, "Library should contain two files.")
		
		var result = library.all()
		assert(result.count == 2, "search for key creator should return 2 files")
		assert(result[0] as! File == f1, "results should be f1")
		assert(result[1] as! File == f2, "results should be f2")
		
		library.add(file: f3)
		result = library.all()
		assert(result.count == 3, "search for key creator should return 2 files")
		assert(result[0] as! File == f1, "results should be f1")
		assert(result[1] as! File == f2, "results should be f2")
		assert(result[2] as! File == f3, "results should be f3")
	}
	
	func testFileValidator() {
		
	}
	
	func testFileImporter() {
		let testFilename = "test.json"
		let testHomeFilename = "~/test.json"
		let dummyFilename = "doesntexist.json"
		
		let importer: FileImporter = FileImporter()
		var results: [MMFile] = []
		
		precondition(results.count == 0, "results should be empty.")

		do {
			results = try importer.read(filename: testFilename)
			assert(results.count == 3, "Results should have three files after read.")
			assert(results[0] as! File == f1, "results should be f1")
			assert(results[1] as! File == f2, "results should be f2")
			assert(results[2] as! File == f3, "results should be f3")
			
			results = try importer.read(filename: testHomeFilename)
			assert(results.count == 3, "Results should have three files after read.")
			assert(results[0] as! File == f1, "results should be f1")
			assert(results[1] as! File == f2, "results should be f2")
			assert(results[2] as! File == f3, "results should be f3")
			
			results = try importer.read(filename: dummyFilename)
			assert(results.count == 0, "No files should be returned")
			
		} catch {
			assertionFailure()
		}
	}
	
	func testFileExporter() {
		
	}
	
	func testLoadCommand() {
		
	}
	
	func testListCommand() {
	}
	
	func testListAllCommand() {

	}
	
	func testSetCommand() {
		
	}
	
	func testDeleteCommand() {
		
	}
	
	func testSaveSearchCommand() {
		
	}
	
	func testSaveCommand() {
		
	}
	
}
