 package io;

#if web
import js.Browser;
import js.html.Storage;
#end
import haxe.Json;
/**
 * This class is made to save game data as a binary file in desktop targets and Browser DOM Storage for HTML target
 */
 class LocalSave {

 	#if web
 	private var browserStorage:Storage;
 	#end

 	public function isLocalStorageSupported():Bool {
 		#if web
 		return browserStorage != null;
 		#end

 		trace("Local Storage unsupported on this target");
 		return false;
 	}

 	public function new() {
 		#if web
 		browserStorage = Browser.getLocalStorage();
 		if( !isLocalStorageSupported())
	 		trace("Local Storage unsupported. Won't be able to save anything.");
 		trace(browserStorage);
 		#end

 	}

 	public function loadData(key:String):String {
 		#if web
 		if( isLocalStorageSupported())
 			return browserStorage.getItem(key);
 		#end

 		trace("Loading not supportd on this target");
 		return "Unsupported";
 	}

 	public function saveData(key:String, data:String) {
 		#if web
 		if( isLocalStorageSupported())
 			browserStorage.setItem(key, data);
 			return;
 		#end

 		trace("Saving not supportd on this target");

 	}
 }