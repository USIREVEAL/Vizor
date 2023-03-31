"
I am a glyph that represents a VZNode. This is used as the default glyph if none is provided by
the concrete subclass of VZNode.

I have a width and a height.
"
Class {
	#name : #VZNodeGlyph,
	#superclass : #VZGlyph,
	#instVars : [
		'origin',
		'extent'
	],
	#category : #'Vizor-GUI-Glyphs'
}

{ #category : #constants }
VZNodeGlyph class >> defaultColor [
	^ Color gray
]

{ #category : #constants }
VZNodeGlyph class >> defaultHeight [
	^ 15
]

{ #category : #constants }
VZNodeGlyph class >> defaultWidth [
	^ 15
]

{ #category : #'instance creation' }
VZNodeGlyph class >> of: aVZNode [ 
	^ self new
		entity: aVZNode;
		yourself
]

{ #category : #interacting }
VZNodeGlyph >> addConnectedNodes [
	| connectedNodes |
	connectedNodes := self entity connectedNodes.
	self view addAll: connectedNodes.
	self view addAll: (self entity edges).
	self view viewChanged
]

{ #category : #accessing }
VZNodeGlyph >> extent [
	^ extent
]

{ #category : #accessing }
VZNodeGlyph >> extent: anObject [
	extent := anObject
]

{ #category : #interacting }
VZNodeGlyph >> fillContextMenu: aMenu  inContext: aVZContext [
	super fillContextMenu: aMenu inContext: aVZContext.
	aMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item name: 'Show edges';
					action: [ self showEdges ] ];
				addItem: [ :item |
					item name: 'Select connected nodes';
					action: [ self selectConnectedNodes ] ];
				addItem: [ :item |
					item name: 'Select connected nodes with edges';
					action: [ self selectConnectedNodesWithEdges ] ];
				addItem: [ :item |
					item name: 'Select transitive closure';
					action: [ self selectTransitiveClosure ] ];
				addItem: [ :item |
					item name: 'Select transitive closure with edges';
					action: [ self selectTransitiveClosureWithEdges ] ];
				addItem: [ :item |
					item name: 'Add connected nodes';
					action: [ self addConnectedNodes ] ]. ].
]

{ #category : #accessing }
VZNodeGlyph >> height [
	<vzProperty: #numerical>
	^ self extent y
]

{ #category : #accessing }
VZNodeGlyph >> height: aNumber [
	self extent: self extent x @ aNumber
]

{ #category : #initialization }
VZNodeGlyph >> initialize [
	super initialize.
	self origin: 0 @ 0.
	self extent: 0 @ 0.
]

{ #category : #accessing }
VZNodeGlyph >> origin [
	^ origin
]

{ #category : #accessing }
VZNodeGlyph >> origin: anObject [
	origin := anObject
]

{ #category : #printing }
VZNodeGlyph >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		print: origin asFloatPoint;
		nextPutAll: ' > ';
		print: extent asFloatPoint;
		nextPutAll: ')'.
]

{ #category : #selecting }
VZNodeGlyph >> selectConnectedNodes [
	| connectedNodes connectedGlyphs |
	connectedNodes := self visibleConnectedNodes.
	connectedGlyphs := self view findGlyphsForNodes: connectedNodes.
	connectedGlyphs add: self.
	self view clearAndSelectAll: connectedGlyphs.
]

{ #category : #selecting }
VZNodeGlyph >> selectConnectedNodesWithEdges [
	| connectedNodesAndEdges connectedGlyphs |
	connectedNodesAndEdges := self visibleConnectedNodesWithEdges.
	connectedGlyphs := (self view findGlyphsForEntities: connectedNodesAndEdges).
	connectedGlyphs add: self.
	self view clearAndSelectAll: connectedGlyphs.
]

{ #category : #selecting }
VZNodeGlyph >> selectTransitiveClosure [
	| closureEntities closureGlyphs |
	closureEntities := self visibleTransitiveClosure.
	closureGlyphs := self view findGlyphsForNodes: closureEntities.
	self view clearAndSelectAll: closureGlyphs.
]

{ #category : #selecting }
VZNodeGlyph >> selectTransitiveClosureWithEdges [
	| closureNodes closureEdges closureGlyphs |
	closureNodes := self visibleTransitiveClosure.
	closureEdges := (closureNodes flatCollect: [ :each | (self view findGlyphForNode: each) visibleEdges ] as: Set).
	closureGlyphs := (self view findGlyphsForNodes: closureNodes) union: (self view findGlyphsForEdges: closureEdges).
	self view clearAndSelectAll: closureGlyphs.
]

{ #category : #rendering }
VZNodeGlyph >> setPropertiesForGlyph [
	self shape
		model: self;
		width: (self width isZero ifFalse: [ self width ] ifTrue: [ self class defaultWidth ]);
		height: (self height isZero ifFalse: [ self height ] ifTrue: [ self class defaultHeight ]);
		color: self color.
	self shape translateTopLeftTo: self origin.
]

{ #category : #rendering }
VZNodeGlyph >> shapeForRoassal [
	^ RSBox new
]

{ #category : #interacting }
VZNodeGlyph >> showEdges [
	| edgesToShow |
	edgesToShow := self entity edges select: [ :each | self view includes: (each otherNodeOf: self entity) ].
	self view addAll: edgesToShow.
	self view viewChanged
]

{ #category : #accessing }
VZNodeGlyph >> transitiveClosure [
	^ self entity transitiveClosureWithConnectedNodesBlock: [ :node | node connectedNodes select: [ :each | self view includes: each ] ].
]

{ #category : #accessing }
VZNodeGlyph >> visibleConnectedNodes [
	^ (self visibleEdges
		collect: [ :each | each otherNodeOf: self entity ]
		thenSelect: [ :each | self view includes: each ]) asSet
]

{ #category : #accessing }
VZNodeGlyph >> visibleConnectedNodesWithEdges [
	^ self visibleConnectedNodes union: self visibleEdges.
]

{ #category : #accessing }
VZNodeGlyph >> visibleEdges [
	^ self entity edges select: [ :each | self view includes: each ]
]

{ #category : #accessing }
VZNodeGlyph >> visibleTransitiveClosure [
	^ self entity transitiveClosureWithConnectedNodesBlock: [ :each | (self view findGlyphForNode: each) visibleConnectedNodes ].
]

{ #category : #accessing }
VZNodeGlyph >> width [
	<vzProperty: #numerical>
	^ self extent x
]

{ #category : #accessing }
VZNodeGlyph >> width: aNumber [
	self extent: aNumber @ self extent y
]

{ #category : #accessing }
VZNodeGlyph >> x [
	^ self origin x
]

{ #category : #accessing }
VZNodeGlyph >> x: aNumber [
	self origin: aNumber @ self origin y
]

{ #category : #accessing }
VZNodeGlyph >> y [
	^ self origin y
]

{ #category : #accessing }
VZNodeGlyph >> y: aNumber [
	self origin: self origin x @ aNumber
]
