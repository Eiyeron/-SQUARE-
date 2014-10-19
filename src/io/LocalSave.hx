 package io;

 #if web
 import js.Browser;
 import js.html.Storage;
 #else
 import sys.io.File;
 import sys.io.FileInput;
 import sys.io.FileOutput;
 import sys.FileSystem;
 import haxe.Json;

 #end
 /**
 * This class is made to save game data as a binary file in desktop targets and Browser DOM Storage for HTML target
 * TODO : Compress the saved content with some huffman comrpession as it's in the standard lib.
 * TODO : JSON?
 * TODO : Read config.json to fecth the save location.
 * TODO : Non static save locations.
 * TODO : Android (as the rest of the game :-°)
 */
 class LocalSave {

 	private static inline var pathToFile :String = "save/";
 	private static inline var filename   :String = "sav.dat";

 	#if web
 	private var browserStorage:Storage;
 	#else
 	private var ready:Bool;
 	#end

 	public function isLocalSaveSupported():Bool {
 		#if web
 		return browserStorage != null;
 		#else
 		return ready;
 		#end

 		trace("Local Storage unsupported on this target");
 		return false;
 	}

 	public function new() {
 		#if web
 		browserStorage = Browser.getLocalStorage();
 		if( !isLocalSaveSupported())
 		trace("Local Storage unsupported. Won't be able to save anything.");
 		#else
 		ready = true;
 		if( !FileSystem.exists(pathToFile)) {
 			FileSystem.createDirectory(pathToFile);
 		}
 		else if(FileSystem.exists(pathToFile) && !FileSystem.isDirectory(pathToFile)) { 				
 			trace(" Couldn't create folder ." + pathToFile + " as it exists as a file.");
 			ready = false;
 		}

 		if( !FileSystem.exists(pathToFile+filename)) {
 			File.write(pathToFile+filename).close();
 		}

 		#end

 	}

 	public function loadData(key:String):String {
 		if( !isLocalSaveSupported()) {
 			trace("Loading not supportd on this target");
 			return "Unsupported";
 		}
 		#if web
 		return browserStorage.getItem(key);
 		#else 
 		try {

 		return File.getContent(pathToFile + filename);
 		} catch ( e:Dynamic) {
 			trace("Loading Error : +"e);
 			trace("Disabling save/load on this instane.");
 			ready = false;
 			return "Error.";
 		}
 		#end

 	}

 	public function saveData(key:String, data:String) {
 		if( !isLocalSaveSupported()) {
 			trace("Saving not supportd on this target");
 			return;

 		}

 		#if web
 		if( isLocalSaveSupported())
 		browserStorage.setItem(key, data);

 		#else
 		try{
 			File.saveContent(pathToFile + filename, data); 			
 		}
 		catch(e:Dynamic) {
 			trace("Saving Error: " + e);
 			trace("Disabling save/load on this instane.");
 			ready = false;
 		}
 		#end


 	}
 }