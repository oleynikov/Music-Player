<?php
	function folderScan ( $folder ) {
		global $musicPath;
		global $musicUrl;
		global $xml;
		if ( is_dir ( $folder."/" ) ) {
			if ( $dirPointer = opendir ( $folder."/" ) ) {
				if ($musicPath != $folder) {
					$folderName = end ( explode ( "/" , $folder ) );
					$xml .= "<folder name=\"$folderName\">";
				}
				while ( ( $filePointer = readdir ( $dirPointer ) ) != false ) {
					if ($filePointer != "." && $filePointer != ".." ) {
						$filePath = $folder . "/" . $filePointer;
						if ( is_dir ( $filePath ) ) {
							folderScan ( $filePath  );
						}
						else if ( end ( explode ( "." , $filePath ) ) == "mp3" ) {
							$xml .= "<track name=\"$filePointer\" />";
						}
					}
				}
				if ($musicPath != $folder) {
					$xml .= "</folder>";
				}
				closedir ( $dirPointer );
			}
		}
	}
	function playlistUpdate () {
		global $musicPath;
		global $musicUrl;
		global $xml;
		$musicPath = $_SERVER['DOCUMENT_ROOT'] . "/music";
		$musicUrl = "http://".$_SERVER['HTTP_HOST']."/music/";
		$xml = '<?xml version="1.0"  encoding="UTF-8"?><folder name="music">';
		folderScan ( $musicPath );
		$xml .= '</folder>';
		$playlist = fopen ( $_SERVER['DOCUMENT_ROOT'] . "/playlist/playlist.xml" ,  "w" );
		fputs ( $playlist , $xml );
		fclose ( $playlist );
	}
	playlistUpdate ();
?>