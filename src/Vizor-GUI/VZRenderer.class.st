"
I am an abstract view.
"
Class {
	#name : #VZRenderer,
	#superclass : #VZObject,
	#instVars : [
		'owner',
		'presenter',
		'defaultNormalize'
	],
	#category : #'Vizor-GUI-Views'
}

{ #category : #'instance creation' }
VZRenderer class >> owner: aVZContentPane [ 
	^ self basicNew
		owner: aVZContentPane;
		initialize;
		yourself
]

{ #category : #interacting }
VZRenderer >> addInteractions [
	^ self subclassResponsibility
]

{ #category : #accessing }
VZRenderer >> defaultNormalize [
	^ defaultNormalize ifNil: [ defaultNormalize := (self view hasMappings) ]
]

{ #category : #accessing }
VZRenderer >> defaultNormalize: aBoolean [
	defaultNormalize := aBoolean
]

{ #category : #exporting }
VZRenderer >> exportPNGToFile: aFileReference [ 
	^ self subclassResponsibility
]

{ #category : #initialization }
VZRenderer >> initialize [
	super initialize.

	self monitor announcer
		when: VZSelectionChangedAnnouncement send: #whenSelectionChanged: to: self;
		when: VZViewChangedAnnouncement send: #whenViewChanged: to: self.

]

{ #category : #rendering }
VZRenderer >> initializeGlyphShape: aVZGlyph [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
VZRenderer >> monitor [
	^ self owner monitor
]

{ #category : #accessing }
VZRenderer >> owner [
	^ owner
]

{ #category : #accessing }
VZRenderer >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
VZRenderer >> presenter [
	^ presenter.
]

{ #category : #accessing }
VZRenderer >> refresh [
	^ self subclassResponsibility
]

{ #category : #dependencies }
VZRenderer >> release [
	self monitor announcer unsubscribe: self.
	
	super release.
]

{ #category : #updating }
VZRenderer >> render [
	self view ifNotNil: [
		self view renderOn: self.
		self updateSelection.
		self addInteractions. ].
]

{ #category : #rendering }
VZRenderer >> renderView: aVZView [ 
	^ self subclassResponsibility
]

{ #category : #updating }
VZRenderer >> updateSelection [
	^ self subclassResponsibility.
]

{ #category : #accessing }
VZRenderer >> view [
	^ self owner view
]

{ #category : #announcing }
VZRenderer >> whenSelectionChanged: aVZAnnouncement [
	self updateSelection.
]

{ #category : #announcing }
VZRenderer >> whenViewChanged: aVZAnnouncement [
	self flag: #FIXME. 
	"Instead of calling refresh, update the view shapes on the canvas.
	 This requires a redesign of how VZRenderer works.
	 For example, we do not want a complete relayout."
	self refresh.
]
