"
I am a generic Vizor Graphical User Interface component.
"
Class {
	#name : #VZComponent,
	#superclass : #SpPresenter,
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZComponent class >> defaultLayout [
	^ self subclassResponsibility.
]

{ #category : #specs }
VZComponent class >> defaultSpec [
	^ self defaultLayout.
]

{ #category : #accessing }
VZComponent >> mainWindow [
	^ (self isKindOf: VZMainWindow)
		ifTrue: [ self ]
		ifFalse: [ self owner mainWindow ]
]

{ #category : #system }
VZComponent >> monitor [
	^ self mainWindow monitor.
]

{ #category : #showing }
VZComponent >> openWithSpec [
	"For compatibility with older version of Roassal"
	((((Smalltalk version splitOn: $.) at: 1) withoutPrefix: 'Pharo') asInteger >= 11)
		ifTrue: [ self open. ]
		ifFalse: [ super openWithSpec. ].
]

{ #category : #dependencies }
VZComponent >> release [
	self class instVarNames do: [ :name | self instVarNamed: name put: nil ].
	
	('Released ' , self printString) traceCr.
	super release.
]

{ #category : #system }
VZComponent >> view [
	^ self mainWindow view.
]
