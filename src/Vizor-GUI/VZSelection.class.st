"
I am a selection of VZEntity objects.
I can change properties of the selected entities.
I can spawn a new Vizor window containing the graph of selected entities.
"
Class {
	#name : #VZSelection,
	#superclass : #VZObject,
	#instVars : [
		'color',
		'view',
		'glyphs'
	],
	#category : #'Vizor-GUI-Views'
}

{ #category : #constants }
VZSelection class >> defaultColor [
	^ Color blue
]

{ #category : #'adding/removing' }
VZSelection >> add: aVZGlyph [
	self flag: #FIXME "Maybe there's a more specific exception that can be raised".
	(aVZGlyph isKindOf: VZGlyph) ifFalse: [ self error: 'Cannot add a ' , aVZGlyph className , ' to the selection.' ].
	glyphs addIfNotPresent: aVZGlyph ifPresentDo: [ ^ self inform: aVZGlyph printString , ' was already present in the selection.' ].
	
]

{ #category : #'adding/removing' }
VZSelection >> addAll: aCollectionOfVZGlyph [
	aCollectionOfVZGlyph do: [ :each | self add: each ]
]

{ #category : #'adding/removing' }
VZSelection >> clear [
	glyphs := Set new.
]

{ #category : #accessing }
VZSelection >> color [
	^ color
]

{ #category : #accessing }
VZSelection >> color: aColor [
	color := aColor
]

{ #category : #accessing }
VZSelection >> edgeGlyphs [
	^ self glyphs select: [ :each | each entity isEdge ]
]

{ #category : #accessing }
VZSelection >> edges [
	^ self edgeGlyphs collect: #entity.
]

{ #category : #accessing }
VZSelection >> entities [
	^ glyphs collect: #entity.
]

{ #category : #accessing }
VZSelection >> glyphs [
	^ glyphs.
]

{ #category : #modifying }
VZSelection >> hideAll [
	self view hideAll: self glyphs; viewChanged.
]

{ #category : #testing }
VZSelection >> includes: aVZGlyph [
	^ glyphs includes: aVZGlyph.
]

{ #category : #testing }
VZSelection >> includesAll: aCollectionOfVZGlyph [
	^ aCollectionOfVZGlyph allSatisfy: [ :each | self includes: each ]
]

{ #category : #initialization }
VZSelection >> initialize [
	super initialize.
	color := self class defaultColor.
	glyphs := Set new.
	
]

{ #category : #modifying }
VZSelection >> invert [
	| unSelectedGlyphs |
	unSelectedGlyphs := self view glyphs reject: #isSelected.
	self clear.
	self addAll: unSelectedGlyphs.
]

{ #category : #testing }
VZSelection >> isEmpty [
	^ self glyphs isEmpty.
]

{ #category : #accessing }
VZSelection >> nodeGlyphs [
	^ self glyphs select: [ :each | each entity isNode ]
]

{ #category : #accessing }
VZSelection >> nodes [
	^ self nodeGlyphs collect: #entity.
]

{ #category : #modifying }
VZSelection >> paint: aColor [
	self glyphs do: [ :each | each color: aColor ].
	self flag: #TODO. "Maybe this should be called by the entities when their color is changed? 
	 But then there might be dozens of events fired."
	self view viewChanged.
]

{ #category : #'adding/removing' }
VZSelection >> remove: aVZGlyph [
	self flag: #FIXME "Maybe there's a more specific exception that can be raised".
	(aVZGlyph isKindOf: VZGlyph) ifFalse: [ self error: 'Cannot remove a ' , aVZGlyph className , ' from the selection.' ].
	
	glyphs remove: aVZGlyph ifAbsent: [ nil ].
	


]

{ #category : #'adding/removing' }
VZSelection >> removeAll: aCollectionOfVZGlyph [
	aCollectionOfVZGlyph do: [ :each | self remove: each ]
]

{ #category : #accessing }
VZSelection >> size [
	^ self glyphs size.
]

{ #category : #'adding/removing' }
VZSelection >> toggleSelection: aVZGlyph [
	"If the glyph is the only one selected or the selection is empty, just toggle the glyph.
	 Otherwise if many glyphs are selected, clear the selection and select the glyph."
	| shouldSelectGlyph |
	shouldSelectGlyph := self isEmpty or: [ (self includes: aVZGlyph) not or: [ self size > 1 ] ].
	self clear.
	shouldSelectGlyph ifTrue: [ self add: aVZGlyph ].
]

{ #category : #'adding/removing' }
VZSelection >> toggleSelectionAdditive: aVZGlyph [
	"Toggle whether the glyph is selected, but keep everything else in the selection unchanged."
	(self includes: aVZGlyph)
		ifTrue: [ self remove: aVZGlyph ]
		ifFalse: [ self add: aVZGlyph ].
]

{ #category : #accessing }
VZSelection >> view [
	^ view
]

{ #category : #accessing }
VZSelection >> view: anObject [
	view := anObject
]
