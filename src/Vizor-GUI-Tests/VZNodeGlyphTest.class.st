"
A VZNodeGlyphTest is a test class for testing the behavior of VZNodeGlyph
"
Class {
	#name : #VZNodeGlyphTest,
	#superclass : #VZGlyphTest,
	#category : #'Vizor-GUI-Tests-Glyphs'
}

{ #category : #running }
VZNodeGlyphTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.

]

{ #category : #tests }
VZNodeGlyphTest >> testColor [
	self assert: nodeGlyph1 color equals: Color gray.
]

{ #category : #tests }
VZNodeGlyphTest >> testEntity [
	self assert: nodeGlyph1 entity equals: node1.
]

{ #category : #tests }
VZNodeGlyphTest >> testExtent [
	self assert: nodeGlyph1 extent equals: 0 @ 0.
]

{ #category : #tests }
VZNodeGlyphTest >> testExtent2 [
	nodeGlyph1 extent: 420 @ 69.
	self assert: nodeGlyph1 extent equals: 420 @ 69.
]

{ #category : #tests }
VZNodeGlyphTest >> testHeight [
	self assert: nodeGlyph1 height equals: 0.
]

{ #category : #tests }
VZNodeGlyphTest >> testHeight2 [
	nodeGlyph1 height: 42.
	self assert: nodeGlyph1 height equals: 42.
]

{ #category : #tests }
VZNodeGlyphTest >> testOrigin [
	self assert: nodeGlyph1 origin equals: 0 @ 0.
]

{ #category : #tests }
VZNodeGlyphTest >> testOrigin2 [
	nodeGlyph1 origin: 13 @ 12.
	self assert: nodeGlyph1 origin equals: 13 @ 12.
]

{ #category : #tests }
VZNodeGlyphTest >> testPrintOn [
	nodeGlyph1 origin: 13 @ 12; extent: 420 @ 69.
	self assert: nodeGlyph1 printString equals: 'a VZNodeGlyph ((13.0@12.0) > (420.0@69.0))'.
]

{ #category : #tests }
VZNodeGlyphTest >> testSelectTransitiveClosure [
	view hide: node1.
	nodeGlyph2 selectTransitiveClosure.
	
	"node2 is not connected to anything because we hid node1."
	self assertCollection: view selection entities hasSameElements: { node2 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testSelectTransitiveClosure2 [
	nodeGlyph2 selectTransitiveClosure.
	
	"All three nodes should be selected."
	self assertCollection: view selection entities hasSameElements: { node1 . node2 . node3 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testSelectTransitiveClosure3 [
	nodeGlyph4 selectTransitiveClosure.
	
	"node4 is not connected to anything."
	self assertCollection: view selection entities hasSameElements: { node4 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testSelectTransitiveClosureWithEdges [
	view hide: node1.
	nodeGlyph2 selectTransitiveClosureWithEdges.
	
	"node2 is not connected to anything because we hid node1.
	 The edge is not included because it is not visible (since we hide the node1)."
	self assertCollection: view selection entities hasSameElements: { node2 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testSelectTransitiveClosureWithEdges2 [
	nodeGlyph2 selectTransitiveClosureWithEdges.
	
	"All nodes and edges are selected, except for the disconnected node4."
	self assertCollection: view selection entities hasSameElements: { node1 . node2 . node3 . view edges first . view edges second }.
]

{ #category : #tests }
VZNodeGlyphTest >> testSetPropertiesForGlyph [
	nodeGlyph1 shape: nodeGlyph1 shapeForRoassal.
	nodeGlyph1 setPropertiesForGlyph.
	
	self assert: nodeGlyph1 shape isNotNil.
	self assert: nodeGlyph1 shape model equals: nodeGlyph1.
]

{ #category : #tests }
VZNodeGlyphTest >> testShape [
	self assert: nodeGlyph1 shape isNil.
]

{ #category : #tests }
VZNodeGlyphTest >> testShapeForRoassal [
	| shape |
	shape := nodeGlyph1 shapeForRoassal.
	
	self assert: shape isNotNil.
	self assert: shape class equals: RSBox.
]

{ #category : #tests }
VZNodeGlyphTest >> testTransitiveClosure [
	| transitiveClosure |
	transitiveClosure := nodeGlyph1 transitiveClosure.
	
	self assertCollection: transitiveClosure hasSameElements: { node1 . node2 . node3 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testTransitiveClosure2 [
	| transitiveClosure |
	view hide: node1.
	transitiveClosure := nodeGlyph2 transitiveClosure.
	
	"node2 is not connected to anything because we hid node1."
	self assertCollection: transitiveClosure hasSameElements: { node2 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testView [
	self assert: nodeGlyph1 view isNotNil.
]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleConnectedNodes [
	| visibleConnectedNodes |
	"Hiding a node."
	view hide: node3.
	
	visibleConnectedNodes := nodeGlyph1 visibleConnectedNodes.
	self assert: visibleConnectedNodes size equals: 1.
	self assertCollection: visibleConnectedNodes hasSameElements: { node2 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleConnectedNodes2 [
	| visibleConnectedNodes |
	"Hiding an edge."
	view hide: node3 edges first.
	
	visibleConnectedNodes := nodeGlyph1 visibleConnectedNodes.
	self assert: visibleConnectedNodes size equals: 1.
	self assertCollection: visibleConnectedNodes hasSameElements: { node2 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleConnectedNodes3 [
	| visibleConnectedNodes |
	"Nodes are returned only once even in case of multiple edges"
	view connectModel: 2 andModel: 1.
	
	visibleConnectedNodes := nodeGlyph1 visibleConnectedNodes.
	self assert: visibleConnectedNodes size equals: 2.
	self assertCollection: visibleConnectedNodes hasSameElements: { node2 . node3 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleConnectedNodesWithEdges [
	| visibleConnectedEntities |
	
	visibleConnectedEntities := nodeGlyph1 visibleConnectedNodesWithEdges.
	self assert: visibleConnectedEntities size equals: 4.
	self assertCollection: visibleConnectedEntities hasSameElements: { node2 . node3 . edge1 . edge2 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleConnectedNodesWithEdges2 [
	| visibleConnectedEntities |
	"Hiding an edge."
	view hide: node2 edges first.
	
	visibleConnectedEntities := nodeGlyph1 visibleConnectedNodesWithEdges.
	self assert: visibleConnectedEntities size equals: 2.
	self assertCollection: visibleConnectedEntities hasSameElements: { node3 . edge2 }

]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleConnectedNodesWithEdges3 [
	| visibleConnectedEntities |
	"Hiding a node."
	view hide: node3.
	
	visibleConnectedEntities := nodeGlyph1 visibleConnectedNodesWithEdges.
	self assert: visibleConnectedEntities size equals: 2.
	self assertCollection: visibleConnectedEntities hasSameElements: { node2 . edge1 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleConnectedNodesWithEdges4 [
	| newEdge visibleConnectedEntities |
	"All visible edges are returned"
	newEdge := view connectModel: 2 andModel: 1.
	
	visibleConnectedEntities := nodeGlyph1 visibleConnectedNodesWithEdges.
	self assert: visibleConnectedEntities size equals: 5.
	self assertCollection: visibleConnectedEntities hasSameElements: { node2 . node3 . edge1 . edge2 . newEdge}.

]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleEdges [
	view hide: node1 edges first.
	
	self assert: node1 edges size equals: 2.
	self assert: nodeGlyph1 visibleEdges size equals: 1.
]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleTransitiveClosure [
	"Hiding a node."
	view hide: node1.
	
	self assertCollection: nodeGlyph2 visibleTransitiveClosure hasSameElements: { node2 }.
	self assertCollection: nodeGlyph3 visibleTransitiveClosure hasSameElements: { node3 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleTransitiveClosure2 [
	"Adding an edge, but hiding another edge."
	| expectedClosure |
	view hide: node2 edges first.
	view add: (VZEdge between: node2 and: node3).
	expectedClosure := { node1 . node2 . node3 }.
	
	self assertCollection: nodeGlyph1 visibleTransitiveClosure hasSameElements: expectedClosure.
	self assertCollection: nodeGlyph2 visibleTransitiveClosure hasSameElements: expectedClosure.
	self assertCollection: nodeGlyph3 visibleTransitiveClosure hasSameElements: expectedClosure.
]

{ #category : #tests }
VZNodeGlyphTest >> testVisibleTransitiveClosure3 [
	"Hiding an edge."
	view hide: node2 edges first.
	
	self assertCollection: nodeGlyph1 visibleTransitiveClosure hasSameElements: { node1 . node3 }.
	self assertCollection: nodeGlyph2 visibleTransitiveClosure hasSameElements: { node2 }.
	self assertCollection: nodeGlyph3 visibleTransitiveClosure hasSameElements: { node1 . node3 }.
]

{ #category : #tests }
VZNodeGlyphTest >> testWidth [
	self assert: nodeGlyph1 width equals: 0.
]

{ #category : #tests }
VZNodeGlyphTest >> testWidth2 [
	nodeGlyph1 width: 1312.
	self assert: nodeGlyph1 width equals: 1312.
]

{ #category : #tests }
VZNodeGlyphTest >> testX [
	self assert: nodeGlyph1 x equals: 0.
]

{ #category : #tests }
VZNodeGlyphTest >> testX2 [
	nodeGlyph1 x: 2048.
	self assert: nodeGlyph1 x equals: 2048.
]

{ #category : #tests }
VZNodeGlyphTest >> testY [
	self assert: nodeGlyph1 y equals: 0.
]

{ #category : #tests }
VZNodeGlyphTest >> testY2 [
	nodeGlyph1 y: 2048.
	self assert: nodeGlyph1 y equals: 2048.
]
