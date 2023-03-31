"
I am a Roassal Canvas wrapper.
"
Class {
	#name : #VZRoassalCanvasRenderer,
	#superclass : #VZRenderer,
	#instVars : [
		'canvas',
		'layout',
		'highlighter',
		'elasticBox'
	],
	#category : #'Vizor-GUI-Views'
}

{ #category : #specs }
VZRoassalCanvasRenderer class >> defaultLayout [
	^ RSCircleLayout
]

{ #category : #interacting }
VZRoassalCanvasRenderer >> addCanvasInteractions [
	highlighter := RSHighlightable red.
	elasticBox := RSElasticBox new.
	elasticBox
		when: RSSelectionStartEvent do: [ :evt |
			highlighter unhighlightRecordedShapes: evt canvas ];
		when: RSSelectionChangedEvent do: [ :evt |
			highlighter doHighlightShapes: evt selectedShapes ];
		when: RSSelectionEndEvent do: [ :evt |
			self view clearAndSelectAll: (evt selectedShapes collect: #model); selectionChanged.
			highlighter unhighlightRecordedShapes: evt canvas ].
		
	"Select only nodes."
	elasticBox targetShapes: canvas nodes.
	canvas @ elasticBox.

	"Clear selection when clicking on canvas."
	canvas when: RSMouseLeftClick do: [ self view clearSelection. ].
]

{ #category : #adding }
VZRoassalCanvasRenderer >> addHoverInteractions: aRSShape [
	aRSShape
		when: RSMouseEnter do: [ :event | | entity |
			entity := aRSShape model entity.
			self monitor announce:
				(VZHoverEntityAnnouncement new
					hoveredEntity: entity;
					mappings: (self view findMetricMappingsForEntity: entity)) ].

]

{ #category : #interacting }
VZRoassalCanvasRenderer >> addInteractions [
	(self view glyphs reject: [ :each | each shape isNil ] thenCollect: #shape) do: [ :each |
		self addLeftClickInteraction: each.
		self addRightClickInteraction: each.
		self addHoverInteractions: each.
		self addOtherInteractions: each.
	].
	self addCanvasInteractions.
]

{ #category : #interacting }
VZRoassalCanvasRenderer >> addLeftClickInteraction: aRSShape [
	aRSShape
		when: RSMouseLeftClick do: [ :event |
			event shiftKeyPressed
				ifTrue: [ aRSShape model toggleSelectionAdditive ]
				ifFalse: [ aRSShape model toggleSelection ] ]
]

{ #category : #interacting }
VZRoassalCanvasRenderer >> addOtherInteractions: aRSShape [ 
	(aRSShape model isKindOf: VZNodeGlyph)
			ifTrue: [ aRSShape @ RSDraggable ].
	aRSShape @ (RSPopup text: #label).
]

{ #category : #interacting }
VZRoassalCanvasRenderer >> addRightClickInteraction: aRSShape [ 
	aRSShape when: RSMouseRightClick do: [
		aRSShape model openContextMenu ].
]

{ #category : #accessing }
VZRoassalCanvasRenderer >> canvas [
	^ canvas
]

{ #category : #updating }
VZRoassalCanvasRenderer >> configureCanvas [
	canvas zoomToFit.
	canvas @ RSCanvasController.
]

{ #category : #exporting }
VZRoassalCanvasRenderer >> exportPNGToFile: aFileReference [
	self canvas extent: self canvas extent * 4.
	self canvas pngExporter
		noFixedShapes;
		zoomToCurrentCamera;
		fileName: aFileReference pathString;
		export
]

{ #category : #initialization }
VZRoassalCanvasRenderer >> initialize [
	super initialize.
	canvas := RSCanvas new.
	presenter := SpRoassalPresenter new.
	presenter script: [ :aCanvas |
		canvas := aCanvas.
		self configureCanvas.
		self render.
	].
]

{ #category : #rendering }
VZRoassalCanvasRenderer >> initializeGlyphShape: aVZGlyph [
	| shape |
	shape := aVZGlyph shapeForRoassal.
	aVZGlyph shape: shape.
	^ shape
]

{ #category : #updating }
VZRoassalCanvasRenderer >> refresh [
	^ self presenter refresh.
]

{ #category : #rendering }
VZRoassalCanvasRenderer >> renderView: aVZView [ 
	| nodeGlyphs edgeGlyphs nodeShapes edgeShapes |
	
	"Render glyphs."
	nodeGlyphs := aVZView nodeGlyphs.
	edgeGlyphs := aVZView edgeGlyphs.
	nodeShapes := nodeGlyphs collect: [ :each | each renderOn: self ].
	edgeShapes := edgeGlyphs
		select: [ :each | aVZView includesAll: { each entity node1 . each entity node2 } ]
		thenCollect: [ :each | each renderOn: self ].
	
	"Connect rendered shapes."
	edgeShapes do: [ :each |
		each
			from: (aVZView findGlyphForNode: each model entity node1) shape;
			to: (aVZView findGlyphForNode: each model entity node2) shape. ].
		
	canvas
		addAll: edgeShapes;
		addAll: nodeShapes.

	aVZView layoutClass on: canvas nodes.
	
	self flag: #FIXME. "This code is an experimental hack done for testing"
	"Override coordinates in case of partial layouting"
	(aVZView layoutClass includesBehavior: RSNoLayout)
		ifFalse:	[
			nodeShapes do: [ :each |
				each translateBy: each model origin ] ].
]

{ #category : #updating }
VZRoassalCanvasRenderer >> updateSelection [
	| selection selectedShapes |
	selection := self view selection.

	"Reset rendering of selection on shapes."
	canvas nodes do: [ :each | each border: nil ].
	canvas edges do: [ :each | each color: each model color ].

	"Find new selected shapes and color them."
	selectedShapes := canvas shapes select: [ :each | selection includes: each model ].
	selectedShapes do: [ :each |
		each isNode ifTrue: [ 
			each border: (RSBorder new
				width: 1;
				color: selection color;
				yourself)
		].
		each isEdge ifTrue: [ each color: selection color ].
	].
	
	canvas signalUpdate.
]
