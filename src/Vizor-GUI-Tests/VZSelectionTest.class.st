Class {
	#name : #VZSelectionTest,
	#superclass : #VZTestCase,
	#instVars : [
		'selection',
		'view',
		'node1',
		'node2',
		'node3',
		'node4',
		'edge1',
		'edge2'
	],
	#category : #'Vizor-GUI-Tests-Selections'
}

{ #category : #running }
VZSelectionTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	view := VZView exampleForTests.
	selection := view selection.

	node1 := view findNodeByModel: 1.
	node2 := view findNodeByModel: 2.
	node3 := view findNodeByModel: 3.
	node4 := view findNodeByModel: 4.
	edge1 := node1 edges first.
	edge2 := node1 edges second.
]

{ #category : #tests }
VZSelectionTest >> testAdd [
	| glyph1 |

	glyph1 := view findGlyphForNode: node1.
	selection add: glyph1.
	
	self assert: (selection includes: glyph1).
	self assert: (selection entities includes: node1).

]

{ #category : #tests }
VZSelectionTest >> testAdd2 [
	"Test if adding something that is not a VZEntity raises an Error."
	self
		should: [ selection add: 'foo' ]
		raise: Error
		whoseDescriptionIncludes: 'Cannot add a ByteString to the selection.'
		description: 'Adding a string to the entities should have raised an Error.'.

]

{ #category : #tests }
VZSelectionTest >> testAddAll [
	| glyph1 glyph2 glyph3 |
	glyph1 := view findGlyphForNode: node1.
	glyph2 := view findGlyphForNode: node2.
	glyph3 := view findGlyphForNode: node3.
	
	selection addAll: { glyph1 . glyph2 }.
	
	self assert: (selection includes: glyph1).
	self assert: (selection includes: glyph2).
	self deny: (selection includes: glyph3).

	self assert: (selection entities includes: node1).
	self assert: (selection entities includes: node2).
	self deny: (selection entities includes: node3).
]

{ #category : #tests }
VZSelectionTest >> testClear [
	selection add: (view findGlyphForNode: node1).

	selection clear.
	
	self assert: selection isEmpty.

]

{ #category : #tests }
VZSelectionTest >> testEdges [
	| selectedEdges |

	view select: node1.
	view selectAllEntities: node1 edges.
	view select: node2.
	view selectAllEntities: node2 edges.

	selectedEdges := selection edges.
	self deny: (selectedEdges includes: node1).
	self deny: (selectedEdges includes: node2).
	self assert: (selectedEdges includesAll: node1 edges).
	self assert: (selectedEdges includesAll: node2 edges).

]

{ #category : #tests }
VZSelectionTest >> testEntities [
	| selectedEntities |

	view select: node1.
	view selectAllEntities: node1 edges.

	selectedEntities := selection entities.
	self assert: (selectedEntities includes: node1).
	self assert: (selectedEntities includesAll: node1 edges).

]

{ #category : #tests }
VZSelectionTest >> testHideAll [
	view select: node1.
	view selectAllEntities: node1 edges.
	selection hideAll.

	self assertCollection: view entities hasSameElements: { node2 . node3. node4 }.
	self assert: selection isEmpty. "Hiding elements deselects them."

]

{ #category : #tests }
VZSelectionTest >> testIncludes [
	view select: node1.
	view selectAllEntities: node1 edges.

	self assert: (selection includes: (view findGlyphForNode: node1)).
	node1 edges do: [ :each | self assert: (selection includes: (view findGlyphForEdge: each)) ].
]

{ #category : #tests }
VZSelectionTest >> testIncludesAll [
	view selectAllEntities: node1 edges.

	self assert: (selection includesAll: (view findGlyphsForEdges: node1 edges)).

]

{ #category : #tests }
VZSelectionTest >> testInvert [
	| expectedSelectedGlyphs |
	view select: node1.
	view selectAllEntities: node1 edges.
	selection invert.
	
	expectedSelectedGlyphs := view findGlyphsForEntities: { node2 . node3. node4 }.
	self assert: (view selection includesAll: expectedSelectedGlyphs).
]

{ #category : #tests }
VZSelectionTest >> testInvert2 [
	| expectedSelectedGlyphs |
	"Inverting an empty selection should select everything."
	selection invert.
	
	expectedSelectedGlyphs := view glyphs.
	self assert: (view selection includesAll: expectedSelectedGlyphs).
]

{ #category : #tests }
VZSelectionTest >> testInvert3 [
	"Inverting an full selection should clear the selection."
	view selectAllEntities: view entities.
	selection invert.
	
	self assert: view selection isEmpty.
]

{ #category : #tests }
VZSelectionTest >> testIsEmpty [
	self assert: selection isEmpty.

]

{ #category : #tests }
VZSelectionTest >> testNodes [
	view selectAllEntities: view nodes , view edges.

	self assertCollection: selection nodes hasSameElements: view nodes.
]

{ #category : #tests }
VZSelectionTest >> testPaint [
	view select: node1.

	selection paint: Color blue.
	self assert: (view findGlyphForNode: node1) color equals: Color blue.

	selection paint: Color red.
	self assert: (view findGlyphForNode: node1) color equals: Color red.

]

{ #category : #tests }
VZSelectionTest >> testRemove [
	view select: node1.
	selection remove: (view findGlyphForNode: node1).

	self assert: (selection isEmpty).

]

{ #category : #tests }
VZSelectionTest >> testToggleSelection [
	selection toggleSelection: (view findGlyphForNode: node1).

	self assert: (selection entities includes: node1).

]

{ #category : #tests }
VZSelectionTest >> testToggleSelection2 [
	selection toggleSelection: (view findGlyphForNode: node1). "Adds node1."
	selection toggleSelection: (view findGlyphForNode: node2). "Removes node1 and adds node2."

	self deny: (selection entities includes: node1).
	self assert: (selection entities includes: node2).
]

{ #category : #tests }
VZSelectionTest >> testToggleSelection3 [
	selection toggleSelection: (view findGlyphForNode: node1). "Adds node1."
	selection toggleSelection: (view findGlyphForNode: node2). "Removes node1 and adds node2."
	selection toggleSelection: (view findGlyphForNode: node1). "Removes node2 and adds node1."

	self assert: (selection entities includes: node1).
	self deny: (selection entities includes: node2).
]

{ #category : #tests }
VZSelectionTest >> testToggleSelection4 [
	selection toggleSelection: (view findGlyphForNode: node1). "Adds node1."
	selection toggleSelection: (view findGlyphForNode: node2). "Removes node1 and adds node2."
	selection toggleSelection: (view findGlyphForNode: node1). "Removes node2 and adds node1."
	selection toggleSelection: (view findGlyphForNode: node3). "Removes node1 and adds node3."

	self deny: (selection entities includes: node1).
	self deny: (selection entities includes: node2).
	self assert: (selection entities includes: node3).
]

{ #category : #tests }
VZSelectionTest >> testToggleSelectionAdditive [
	selection toggleSelectionAdditive: (view findGlyphForNode: node1).

	self assert: (selection entities includes: node1).

]

{ #category : #tests }
VZSelectionTest >> testToggleSelectionAdditive2 [
	selection toggleSelectionAdditive: (view findGlyphForNode: node1).
	selection toggleSelectionAdditive: (view findGlyphForNode: node2).

	self assert: (selection entities includes: node1).
	self assert: (selection entities includes: node2).

]

{ #category : #tests }
VZSelectionTest >> testToggleSelectionAdditive3 [
	selection toggleSelectionAdditive: (view findGlyphForNode: node1).
	selection toggleSelectionAdditive: (view findGlyphForNode: node2).
	selection toggleSelectionAdditive: (view findGlyphForNode: node1).

	self deny: (selection entities includes: node1).
	self assert: (selection entities includes: node2).

]

{ #category : #tests }
VZSelectionTest >> testToggleSelectionAdditiveTwice [
	selection toggleSelectionAdditive: (view findGlyphForNode: node1).
	selection toggleSelectionAdditive: (view findGlyphForNode: node1).
	
	self deny: (selection entities includes: node1).
	self assert: selection isEmpty.

]

{ #category : #tests }
VZSelectionTest >> testToggleSelectionTwice [
	selection toggleSelection: (view findGlyphForNode: node1).
	selection toggleSelection: (view findGlyphForNode: node1).

	self deny: (selection entities includes: node1).
	self assert: selection isEmpty.
]

{ #category : #tests }
VZSelectionTest >> testToggleSelectionWhenManySelected [
	view selectAllEntities: view nodes.
	selection toggleSelection: (view findGlyphForNode: node1).

	self assert: (selection entities includes: node1).
	self assert: selection size equals: 1.
	
]

{ #category : #tests }
VZSelectionTest >> testToggleSelectionWhenManySelected2 [
	| glyph1 |
	selection addAll: view edgeGlyphs.
	glyph1 := view findGlyphForNode: node1.
	selection toggleSelection: glyph1.

	self assert: (selection entities includes: node1).
	self assert: selection size equals: 1.
	self assert: (selection includes: glyph1).
	
]
