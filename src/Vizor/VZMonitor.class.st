"
I am responsible for managing an announcer for a Vizor window.
"
Class {
	#name : #VZMonitor,
	#superclass : #VZObject,
	#instVars : [
		'announcer'
	],
	#category : #'Vizor-Core-Announcements'
}

{ #category : #announce }
VZMonitor >> announce: aVZAnnouncement [
	^ self announcer announce: aVZAnnouncement.
]

{ #category : #accessing }
VZMonitor >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ].
]

{ #category : #accessing }
VZMonitor >> announcer: anObject [
	announcer := anObject
]
