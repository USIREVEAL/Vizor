"
I am a status bar with a text.
"
Class {
	#name : #VZStatusBar,
	#superclass : #VZComponent,
	#instVars : [
		'statusText'
	],
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZStatusBar class >> defaultLayout [
	^ SpBoxLayout newHorizontal
		add: #statusText;
	yourself
]

{ #category : #initialization }
VZStatusBar >> initialize [
	super initialize.
	
	self monitor announcer
		when: VZViewChangedAnnouncement send: #whenChangedUpdateLabel: to: self;
		when: VZSelectionChangedAnnouncement send: #whenChangedUpdateLabel: to: self.

]

{ #category : #initialization }
VZStatusBar >> initializePresenters [
	statusText := self newLabel.
	
]

{ #category : #dependencies }
VZStatusBar >> release [
	self monitor announcer unsubscribe: self.
	
	super release.
]

{ #category : #accessing }
VZStatusBar >> setLabel: aString [ 
	statusText label: aString.
]

{ #category : #announcing }
VZStatusBar >> whenChangedUpdateLabel: aVZViewChangedAnnouncement [ 
	statusText label: self view statusInfoExtended.
]
