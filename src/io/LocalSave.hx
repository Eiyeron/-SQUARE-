 package io;

 #if web
 import js.Browser;
 import js.html.Storage;
 #else
 import sys.io.File;
 import sys.io.FileInput;
 import sys.io.FileOutput;
 import sys.FileSystem;
 // import haxe.Json; // Not being used at this moment.

 #end
 /**
 * This class is made to save game data as a binary file in desktop targets and Browser DOM Storage for HTML target
 * TODO : Compress the saved content with some huffman comrpession as it's in the standard lib.
 * TODO : Read config.json to fecth the save location.
 * TODO : Non static save locations.
 * TODO : Android (as the rest of the game :-°)
 * TODO?: JSON
 * TODO?: Singleton
 */
 class LocalSave {

 	private static inline var pathToFile :String = "save/";
 	private static inline var filename   :String = "sav.dat";

 	#if web
 	private var _browserStorage:Storage;
 	#else
 	private var _ready:Bool;
 	#end

 	public function isLocalSaveSupported():Bool {
 		#if web
 		return _browserStorage != null;

 		#else
 		return _ready;
 		#end

 		trace("Local Storage unsupported on this target");
 		return false;
 	}

 	public function new() {
 		#if web
 		_browserStorage = Browser.getLocalStorage();
 		if( !isLocalSaveSupported())
 		trace("Local Storage unsupported. Won't be able to save anything.");

 		#elseif desktop
 		_ready = true;
 		if( !FileSystem.exists(pathToFile)) {
 			FileSystem.createDirectory(pathToFile);
 		}
 		else if(FileSystem.exists(pathToFile) && !FileSystem.isDirectory(pathToFile)) { 				
 			trace(" Couldn't create folder ." + pathToFile + " as it exists as a file.");
 			_ready = false;
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
 		return _browserStorage.getItem(key);

 		#elseif desktop
 		try {
 			return File.getContent(pathToFile + filename);
 		}
 		catch ( e:Dynamic ) {
 			trace("Loading Error : " + e);
 			trace("Disabling save/load on this instance.");
 			_ready = false;
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
 		_browserStorage.setItem(key, data);

 		#elseif desktop
 		try{
 			File.saveContent(pathToFile + filename, data); 			
 		}
 		catch(e:Dynamic) {
 			trace("Saving Error: " + e);
 			trace("Disabling save/load on this instance.");
 			_ready = false;
 		}
 		#end


 	}
 }