//
//  FileImporter.swift
//  MediaLibraryManager
//
//  Created by Nikolah Pearce and Vivian Breda on 14/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

/**
 The list of exceptions that can be thrown by the Validation handler
 */
enum MMValidationError : Error {
    
    // Thrown if there is something wrong with the JSON file
    // e.g. grammar or incorrect file path
    case invalidJSONfile
    
    // Thrown if there is something wrong with the type of media
    case invalidType
    
    // Thrown if there is something wrong with metadata for a specific type
    // e.g. image does not have resolution
    case invalidMetadataForType
    
    // Thrown if a file to be added is already in the library
    case duplicateMedia
}

/**
Support struct for reading JSON data in.
*/
struct Media : Codable {
	let fullpath: String
	let type: String
	let metadata: [String: String]
}

class FileImporter : MMFileImport {
	
	/**
	Support importing the media collection from a file (by name)
	
	- parameters: filename: the full path to the file including file name.
	- returns: [MMFile]: the array of files read successfully
	*/
	func read(filename: String) throws -> [MMFile] {
	
		var filesValidated : [MMFile] = []
		
        do {
			
            let path = URL(fileURLWithPath: filename)
            let decoder = JSONDecoder()
            var mediaArray : [Media] = []
            
            do {
                let data = try Data(contentsOf: path)
                mediaArray = try decoder.decode([Media].self, from: data)
            } catch {
                print("Invalid JSON file... Check your filename, path and/or contents.")
            }
			
			for m in mediaArray {
			
				if let validatedFile = try validateMedia(media: m) {
					filesValidated.append(validatedFile)
				}
			}
        } catch MMValidationError.invalidType {
            print("Invalid file type, expecting image document audio or video.")
        } catch MMValidationError.invalidMetadataForType {
            print("Invalid metadata for provided media type.")
        } catch MMValidationError.duplicateMedia {
            print("File not loaded - identical file already in library.")
        }
		
		return filesValidated
	}
	
	/**
	Designed to validate Files depending upon their type.
	Needs assert statements added.
	
	- returns: File
	*/
	func validateMedia(media: Media) throws -> MMFile? {
		
		let type: String = media.type
		let filename: String = getFilename(fullpath: media.fullpath)
		let path: String = getPath(fullpath: media.fullpath)
		var creator: String? 	//= ""
		var res: String? 		//= ""
		var runtime: String? 	//= ""
		
		var mdata: [Metadata] = []
		
		// File to hold media once validated
		var validatedFile: MMFile? = nil
		
		// Loop through to fill the required values
		for (key, value) in media.metadata {
			if key.lowercased()=="creator" {
				creator = value.lowercased()
			}
			if key.lowercased()=="runtime" {
				runtime = value.lowercased()
			}
			if key.lowercased()=="resolution" {
				res = value.lowercased()
			}
			let tempMetadata : Metadata = Metadata(keyword: key, value: value)
			mdata.append(tempMetadata)
			
		}

		// "No need to validate the media path or media name, we won't
        // be testing with bad data of these" - Paul 22/08/18
     
        if let unwrappedCreator = creator {
            
            // Validate specific data for each type
            switch(type) {
                case "image" :
                    if let imageRes = res {
                        validatedFile = Image(metadata: mdata, filename: filename, path: path, creator: unwrappedCreator, resolution: imageRes)
                    } else {
                        throw MMValidationError.invalidMetadataForType
                    }
                    break
            case "document":
                    validatedFile = Document(metadata: mdata, filename: filename, path: path, creator: unwrappedCreator)
                    break
                case "video":
                    if let videoRes = res, let videoRuntime = runtime {
                        validatedFile = Video(metadata: mdata, filename: filename, path: path, creator: unwrappedCreator, resolution: videoRes, runtime: videoRuntime)
                    } else {
                        throw MMValidationError.invalidMetadataForType
                    }
                    break
                case "audio":
                    if let audioRuntime = runtime {
                        validatedFile = Audio(metadata: mdata, filename: filename, path: path, creator: unwrappedCreator, runtime: audioRuntime)
                    } else {
                        throw MMValidationError.invalidMetadataForType
                    }
                    break
                default:
                    throw MMValidationError.invalidType
                }
            return validatedFile
        } else {
            throw MMValidationError.invalidMetadataForType
        }
	}
    
    /**
     Calculates a filename of a file from the fullpath string.
     
     - parameters: fullpath: the full path to the file including file name.
     - returns: String: the name of the file.
     */
    func getFilename(fullpath: String) -> String {
        
        var parts = fullpath.split(separator: "/")
        let name = String(parts[parts.count-1])
        //print ("Name found: \(name)")
        return name
    }
    
    /**
     Calculates a path to a file from the fullpath string.
     
     - parameters: fullpath: the full path to the file including file name.
     - returns: String: the path to the file.
     */
    func getPath(fullpath: String) -> String {
        
        var parts = fullpath.split(separator: "/")
        var path: String = ""
        let lastIndex = parts.count-2
        for i in 0...lastIndex {
            if parts[i] != "~" {
                path += "/"
            }
            path += parts[i]
        }
        //print ("PATH found: \(path)")
        return path
    }
}

