"
I am an event that is fired when an action performs a layout change.
I contain a symbol of the newly selected layout.
"
Class {
	#name : #VZLayoutChangedAnnouncement,
	#superclass : #VZAnnouncement,
	#instVars : [
		'newLayout'
	],
	#category : #'Vizor-Core-Announcements'
}

{ #category : #protocol }
VZLayoutChangedAnnouncement >> layout [
	^ newLayout.
]

{ #category : #protocol }
VZLayoutChangedAnnouncement >> layout: aSymbol [
	newLayout := aSymbol.
]
