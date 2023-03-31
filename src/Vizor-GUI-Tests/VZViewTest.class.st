Class {
	#name : #VZViewTest,
	#superclass : #VZTestCase,
	#instVars : [
		'view',
		'node1',
		'node4',
		'node2',
		'node3',
		'edge1',
		'edge2'
	],
	#category : #'Vizor-GUI-Tests-Views'
}

{ #category : #running }
VZViewTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	view := VZView exampleForTests.
	node1 := view findNodeByModel: 1.
	node2 := view findNodeByModel: 2.
	node3 := view findNodeByModel: 3.
	node4 := view findNodeByModel: 4.
	edge1 := node1 edges first.
	edge2 := node1 edges second.
]

{ #category : #tests }
VZViewTest >> testAdd [
	| newNode1 newNode2 newEdge |
	newNode1 := VZNode new.
	newNode2 := VZNode new.
	newEdge := (VZEdge between: newNode1 and: newNode2).
	view add: newNode1.
	view add: newNode2.
	view add: newEdge.

	self assert: (view nodes includes: newNode1).
	self assert: (view nodes includes: newNode2).
	self assert: (view edges includes: newEdge).
]

{ #category : #tests }
VZViewTest >> testAddAll [
	| newNode1 newNode2 newEdge entities |
	newNode1 := VZNode new.
	newNode2 := VZNode new.
	newEdge := (VZEdge between: newNode1 and: newNode2) model: '1->2'.
	entities := OrderedCollection new.
	entities add: newNode1.
	entities add: newNode2.
	entities add: newEdge.
	view addAll: entities.

	self assert: (view nodes includes: newNode1).
	self assert: (view nodes includes: newNode2).
	self assert: (view edges includes: newEdge).
]

{ #category : #tests }
VZViewTest >> testAddEdge [
	| newEdge |
	newEdge := VZEdge between: node1 and: node4.
	view addEdge: newEdge.

	self assert: (view edges includes: newEdge).

]

{ #category : #tests }
VZViewTest >> testAddEdges [
	| newEdges edge1 edge2 |
	newEdges := OrderedCollection new.
	edge1 := VZEdge between: node1 and: node4.
	edge2 := VZEdge between: node2 and: node3.
	newEdges add: edge1.
	newEdges add: edge2.
	view addEdges: newEdges.

	self assert: (view edges includes: edge1).
	self assert: (view edges includes: edge2).

]

{ #category : #tests }
VZViewTest >> testAddNode [
	| newNode |
	newNode := VZNode new.
	view addNode: newNode.

	self assert: (view nodes includes: newNode).
]

{ #category : #tests }
VZViewTest >> testAddNodes [
	| newView newNodes |
	newView := VZView new.
	newNodes := OrderedCollection new.
	newNodes add: VZNode new.
	newNodes add: VZNode new.
	newView addNodes: newNodes.

	self assertCollection: newView nodes hasSameElements: newNodes.
]

{ #category : #tests }
VZViewTest >> testAddObjectToView [
	| notANode |
	notANode := Object new.
	
	self
		should: [ view add: notANode ]
		raise: Error
		whoseDescriptionIncludes: 'Can only add VZNodes or VZEdges to a VZView. Trying to add a Object'
		description: 'Adding an Object to a VZView should raise an Error.'.
]

{ #category : #tests }
VZViewTest >> testAllEdgeGlyphsHaveLinkToView [
	self assert: (view edgeGlyphs allSatisfy: [ :each | each view = view ]).
]

{ #category : #tests }
VZViewTest >> testAllNodeGlyphsHaveLinkToView [	
	self assert: (view nodeGlyphs allSatisfy: [ :each | each view = view ]).
]

{ #category : #tests }
VZViewTest >> testClearAndSelectAll [
	"After adding a node VZView>>clearAndSelectAll: should clear the previously selected entities and add only the entities in newSelection"
	| newSelection |

	view select: view nodeGlyphs first.
	newSelection := { view nodeGlyphs third . view nodeGlyphs fourth . view edgeGlyphs second }.
	view clearAndSelectAll: newSelection.

	self assertCollection: (view selection glyphs) hasSameElements: newSelection.
]

{ #category : #tests }
VZViewTest >> testClearSelection [
	"After adding a node, the VZView>>clearSelection should remove all entities from the selection, resulting in an empty selection."

	view select: view nodeGlyphs first.
	view clearSelection.

	self assert: view selection isEmpty.
]

{ #category : #tests }
VZViewTest >> testCompleteReport [
	| report |
	report := view completeReport.
	
	self assert: report equals:
'Nodes
VZNode: 4

Edges
VZEdge: 2' withInternetLineEndings.
]

{ #category : #tests }
VZViewTest >> testConnectModelAndModel [
	view connectModel: 1 andModel: 4.
	self assert: (node1 connectedNodes includes: node4).
]

{ #category : #tests }
VZViewTest >> testConnectModelAndModelReturnsCreatedEdge [
	| newEdge |
	newEdge := view connectModel: 1 andModel: 4.
	
	self assert: newEdge node1 equals: node1.
	self assert: newEdge node2 equals: node4.
]

{ #category : #tests }
VZViewTest >> testConnectModelAndModelWhenModel1IsNotPresent [
	self
		should: [ view connectModel: 6 andModel: 2 ]
		raise: Error
		whoseDescriptionIncludes: 'The first model does not correspond to a VZNode in the view.'
		description: 'When a model is not present as a VZNode in the view, VZView>>connect:and: should raise an Error.'
]

{ #category : #tests }
VZViewTest >> testConnectModelAndModelWhenModel2IsNotPresent [
	self
		should: [ view connectModel: 1 andModel: 6 ]
		raise: Error
		whoseDescriptionIncludes: 'The second model does not correspond to a VZNode in the view.'
		description: 'When a model is not present as a VZNode in the view, VZView>>connect:and: should raise an Error.'
]

{ #category : #tests }
VZViewTest >> testCopyFromSelection [
	| copy |
	view clearAndSelectAllEntities: { node1 . node2 . edge1 }.
	copy := view copyFromSelection.
	
	"The number of nodes and edges is the same as what was selected."
	self assert: copy nodes size equals: 2.
	self assert: copy edges size equals: 1.
	
	"The models of all entities should be models from the original view."
	copy nodes do: [ :each | self assert: (view nodes anySatisfy: [ :aNode | aNode model == each model ]) ].
	copy edges do: [ :each | self assert: (view edges anySatisfy: [ :anEdge | anEdge model == each model ]) ].
	
	"No node or edge glyphs should be shared between the original view and the copy."
	self deny: view equals: copy.
	self denyCollection: copy nodeGlyphs includesAny: view nodeGlyphs.
	self denyCollection: view nodeGlyphs includesAny: copy nodeGlyphs.
	self denyCollection: copy edgeGlyphs includesAny: view edgeGlyphs.
	self denyCollection: view edgeGlyphs includesAny: copy edgeGlyphs.
	
	
]

{ #category : #tests }
VZViewTest >> testCopyFromSelection2 [
	| copy |
	view clearAndSelectAllEntities: { node1 . node2 . edge1 }.
	copy := view copyFromSelection.
	
	"The new view should contain the entities in the original view's selection"
	copy entities do: [ :each | self assert: (view selection entities includes: each) ].
	
]

{ #category : #tests }
VZViewTest >> testCopyFromSelection3 [
	"Glyph properties such as color are kept in the spawned view"
	| copy |
	
	view clearAndSelectAllEntities: { node1 . node2 . edge1 }.
	view selection paint: Color green.
	copy := view copyFromSelection.
	
	copy glyphs do: [ :each | self assertCollection: (each properties) hasSameElements: ((view findGlyphForEntity: each entity) properties) ].

]

{ #category : #tests }
VZViewTest >> testCopyFromSelection4 [
	"Dangling edges are removed both from visible edges and from the original entities in the spawned view"
	| copy |
	view clearAndSelectAllEntities: { node1 . edge1 }.
	copy := view copyFromSelection.
	
	self assert: copy nodes size equals: 1.
	self assert: copy edges size equals: 0.
	self assert: copy originalEntities size equals: 1.
	self assertCollection: copy originalEntities hasSameElements: { node1 } asOrderedCollection.
]

{ #category : #tests }
VZViewTest >> testCopyFromSelection5 [
	"Edges not in the original selection are not added for nodes that are both visible"
	| copy newEdge |
	view clearAndSelectAllEntities: { node1 . node2 . edge1 }.
	newEdge := view connectModel: 2 andModel: 1.
	copy := view copyFromSelection.
	
	self assert: copy nodes size equals: 2.
	self assert: copy edges size equals: 1.
	self assert: copy originalEntities size equals: 4.
	self assertCollection: copy originalEntities hasSameElements: { node1 . node2 . edge1 . newEdge } asOrderedCollection.
]

{ #category : #tests }
VZViewTest >> testCopyFromSelectionEmpty [
	| copy |
	copy := view copyFromSelection.
	
	self assert: copy nodes isEmpty.
	self assert: copy edges isEmpty.
	
	self deny: view equals: copy.
	
	
]

{ #category : #tests }
VZViewTest >> testDeselect [
	"Removing an entity from selection should keep the other entities in the selection"
	view select: node1.
	view select: edge1.
	view deselect: node1.

	self assertCollection: (view selection entities) hasSameElements: { edge1 }.
]

{ #category : #tests }
VZViewTest >> testDirectedConnectedness [
	"Connectedness considering directed graph"

	self assert: view directedConnectedness equals: 2/12.
]

{ #category : #tests }
VZViewTest >> testDirectedConnectedness2 [
	"Connectedness in case of no edges"

	view connectModel: 1 andModel: 2.
	view hide: node1.
	self assert: view directedConnectedness equals: 0.
]

{ #category : #tests }
VZViewTest >> testDirectedConnectedness3 [
	"Info about connectedness in case of multiple edges between the same nodes"
	view connectModel: 2 andModel: 1.
	view connectModel: 2 andModel: 1.
	view connectModel: 1 andModel: 2.
	view connectModel: 1 andModel: 2.
	self assert: view directedConnectedness equals: 3/12.
]

{ #category : #tests }
VZViewTest >> testDirectedConnectedness4 [
	"Connectedness in fully connected graph"

	view connectModel: 1 andModel: 4.
	view connectModel: 2 andModel: 1.
	view connectModel: 2 andModel: 3.
	view connectModel: 2 andModel: 4.
	view connectModel: 3 andModel: 1.
	view connectModel: 3 andModel: 2.
	view connectModel: 3 andModel: 4.
	view connectModel: 4 andModel: 1.
	view connectModel: 4 andModel: 2.
	view connectModel: 4 andModel: 3.
	self assert: view directedConnectedness equals: 1.
]

{ #category : #tests }
VZViewTest >> testDirectedConnectedness5 [
	"Connectedness in case of multiple edges between the same nodes"

	view connectModel: 1 andModel: 2.
	self assert: view directedConnectedness equals: 2/12.
]

{ #category : #tests }
VZViewTest >> testDirectedConnectedness6 [
	"Connectedness in case of self connections"

	view connectModel: 1 andModel: 1.
	self assert: view directedConnectedness equals: 2/12.
]

{ #category : #tests }
VZViewTest >> testDirectedConnectedness7 [
	"Connectedness in case of empty graph"

	view hideAll: view visibleNodes.
	self assert: view directedConnectedness equals: 1.0.
]

{ #category : #tests }
VZViewTest >> testDirectedConnectedness8 [
	"Connectedness in case of single node graph"

	view hideAll: view visibleNodes.
	view addNode: node1.
	self assert: view directedConnectedness equals: 1.0.
]

{ #category : #tests }
VZViewTest >> testEdges [
	self assert: view edges size equals: 2.
]

{ #category : #tests }
VZViewTest >> testFindNodeByModel [
	| node |
	
	node := view findNodeByModel: 1.
	self assert: node equals: node1.
]

{ #category : #tests }
VZViewTest >> testFindNodeByModelReturnsNilIfNotPresent [
	| nodeNotPresent |

	nodeNotPresent := view findNodeByModel: -1.
	self assert: nodeNotPresent equals: nil.
]

{ #category : #tests }
VZViewTest >> testHide [
	view hide: edge1.
	
	self deny: (view includes: edge1).
]

{ #category : #tests }
VZViewTest >> testHideAll [
	view hideAll: { edge1 . edge2 }.
	
	self assert: (view includes: node1).
	self assert: (view includes: node2).
	self assert: (view includes: node3).
	self assert: (view includes: node4).
	self deny: (view includes: edge1).
	self deny: (view includes: edge2).
]

{ #category : #tests }
VZViewTest >> testHideAll2 [
	view hideAll: { node1 . node2 . edge2 }.
	
	self deny: (view includes: node1).
	self deny: (view includes: node2).
	self assert: (view includes: node3).
	self assert: (view includes: node4).
	"edge1 is hidden since node1 is hidden"
	self deny: (view includes: edge1).
	self deny: (view includes: edge2).
]

{ #category : #tests }
VZViewTest >> testHideAll3 [
	view hideAll: { node4 . node2 }.
	
	self assert: (view includes: node1).
	self deny: (view includes: node2).
	self assert: (view includes: node3).
	self deny: (view includes: node4).
	self deny: (view includes: edge1).
	self assert: (view includes: edge2).
]

{ #category : #tests }
VZViewTest >> testHideAndShow [
	view hide: edge1.
	view add: edge1.
	
	self assert: (view includes: edge1).
	view nodes do: [ :each | self assert: (view includes: each) ].
	view edges do: [ :each | self assert: (view includes: each) ].
]

{ #category : #test }
VZViewTest >> testIsConnectedModelAndModel [

	self assert: (view isConnectedModel: 1 andModel: 2).
	self assert: (view isConnectedModel: 1 andModel: 3).
	self deny: (view isConnectedModel: 2 andModel: 3).
	self deny: (view isConnectedModel: 4 andModel: 1).
]

{ #category : #tests }
VZViewTest >> testNodes [	
	self assert: view nodes size equals: 4.
]

{ #category : #tests }
VZViewTest >> testPropertyDescriptions [
	| propertyDescriptions |
	propertyDescriptions := view propertyDescriptions.
	
	self assert: propertyDescriptions isNotEmpty.
	self assert: propertyDescriptions size equals: 8.
]

{ #category : #tests }
VZViewTest >> testPropertyDescriptions2 [
	| propertyDescriptions |
	propertyDescriptions := view propertyDescriptions.
	
	"Numbers of property descriptions."
	self assert: (propertyDescriptions select: [ :each | each isKindOf: VZNumericalPropertyDescription ]) size equals: 3.
	self assert: (propertyDescriptions select: [ :each | each isKindOf: VZCategoricalPropertyDescription ]) size equals: 2.
	self assert: (propertyDescriptions select: [ :each | each isKindOf: VZBinaryPropertyDescription ]) size equals: 3.
	
]

{ #category : #tests }
VZViewTest >> testPropertyDescriptions3 [
	| propertyDescriptions numericalPD |
	propertyDescriptions := view propertyDescriptions.
	
	"Example of numerical property description to be tested: numberOfEdges."
	numericalPD := propertyDescriptions detect: [ :each |
		(each isKindOf: VZNumericalPropertyDescription)
			and: [ each selector = #numberOfEdges ] ].

	self assert: numericalPD numberOfInstances equals: 4.
	self assert: numericalPD min equals: 0.
	self assert: numericalPD max equals: 2.
]

{ #category : #tests }
VZViewTest >> testPropertyDescriptions4 [
	| propertyDescriptions categoricalPD |
	propertyDescriptions := view propertyDescriptions.
	
	"Example of categorical property description to be tested: color."
	categoricalPD := propertyDescriptions detect: [ :each |
		(each isKindOf: VZCategoricalPropertyDescription)
			and: [ each selector = #color ] ].

	self assert: categoricalPD numberOfInstances equals: 6.
	self assertCollection: categoricalPD values hasSameElements: { Color black . Color gray }.
]

{ #category : #tests }
VZViewTest >> testPropertyDescriptions5 [
	| propertyDescriptions binaryPD |
	propertyDescriptions := view propertyDescriptions.
	
	"Example of binary property description to be tested: hasEdges"
	binaryPD := propertyDescriptions detect: [ :each |
		(each isKindOf: VZBinaryPropertyDescription)
			and: [ each selector = #hasEdges ] ].

	self assert: binaryPD numberOfInstances equals: 4.
	self assertCollection: { binaryPD value1 . binaryPD value2 } hasSameElements: { true . false }.
]

{ #category : #tests }
VZViewTest >> testSelect [
	"After adding a node VZView>>select: should add the new entity to the selection"
	view select: node1.
	view select: node1 edges first.

	self assertCollection: (view selection entities) hasSameElements: { node1 . node1 edges first }.
]

{ #category : #tests }
VZViewTest >> testSelectAll [
	"After adding a node VZView>>selectAll: should add the entities in newSelection to the selection"
	| newSelection completeSelection |

	view select: node1.
	newSelection := { node3 . node4 . node2 edges first }.
	view selectAllEntities: newSelection.
	completeSelection := newSelection , { node1 }.

	self assertCollection: (view selection entities) hasSameElements: completeSelection.
]

{ #category : #tests }
VZViewTest >> testSelection [
	self assert: view selection isNotNil.
	self assert: view selection isEmpty.
]

{ #category : #tests }
VZViewTest >> testSelectionHasLinkToView [
	self assert: view selection view identicalTo: view.
]

{ #category : #tests }
VZViewTest >> testStatusInfo [
	| info |

	info := view statusInfo.
	self assert: info equals: 'Nodes: 4 - Edges: 2'.
]

{ #category : #tests }
VZViewTest >> testStatusInfoExtended [
	| infoExt |

	infoExt := view statusInfoExtended.
	self assert: infoExt equals: 'Nodes: 4 - Edges: 2       Selected: 0 nodes, 0 edges       Connectedness: (D) 16.7% / (U) 33.3%'.
]

{ #category : #tests }
VZViewTest >> testStatusInfoExtended2 [
	| infoExt |

	"Hiding node1 will also hide his edges, so 0 edges will be visible"
	view hide: node1.
	infoExt := view statusInfoExtended.
	self assert: infoExt equals: 'Nodes: 3 - Edges: 0       Selected: 0 nodes, 0 edges       Connectedness: (D) 0.0% / (U) 0.0%'.
]

{ #category : #tests }
VZViewTest >> testStatusInfoExtended3 [
	| infoExt |

	view hide: node4.
	infoExt := view statusInfoExtended.
	self assert: infoExt equals: 'Nodes: 3 - Edges: 2       Selected: 0 nodes, 0 edges       Connectedness: (D) 33.3% / (U) 66.7%'.
]

{ #category : #tests }
VZViewTest >> testStatusInfoExtended4 [
	| infoExt |

	view select: node4.
	view select: edge1.
	infoExt := view statusInfoExtended.
	self assert: infoExt equals: 'Nodes: 4 - Edges: 2       Selected: 1 nodes, 1 edges       Connectedness: (D) 16.7% / (U) 33.3%'.
]

{ #category : #tests }
VZViewTest >> testUndirectedConnectedness [
	"Connectedness considering undirected graph"

	self assert: view undirectedConnectedness equals: 1/3.
]

{ #category : #tests }
VZViewTest >> testUndirectedConnectedness2 [
	"Connectedness in case of no edges"

	view connectModel: 1 andModel: 2.
	view hide: node1.
	self assert: view directedConnectedness equals: 0.
]

{ #category : #tests }
VZViewTest >> testUndirectedConnectedness3 [
	"Info about connectedness in case of multiple edges between the same nodes"
	view connectModel: 2 andModel: 1.
	view connectModel: 2 andModel: 1.
	view connectModel: 1 andModel: 2.
	view connectModel: 1 andModel: 2.
	self assert: view undirectedConnectedness equals: 2/6.
]

{ #category : #tests }
VZViewTest >> testUndirectedConnectedness4 [
	"Connectedness in fully connected graph"

	view connectModel: 1 andModel: 4.
	view connectModel: 2 andModel: 1.
	view connectModel: 2 andModel: 3.
	view connectModel: 2 andModel: 4.
	view connectModel: 3 andModel: 1.
	view connectModel: 3 andModel: 2.
	view connectModel: 3 andModel: 4.
	view connectModel: 4 andModel: 1.
	view connectModel: 4 andModel: 2.
	view connectModel: 4 andModel: 3.
	self assert: view undirectedConnectedness equals: 1.
]

{ #category : #tests }
VZViewTest >> testUndirectedConnectedness5 [
	"Connectedness in case of multiple edges between the same nodes"

	view connectModel: 1 andModel: 2.
	self assert: view undirectedConnectedness equals: 1/3.
]

{ #category : #tests }
VZViewTest >> testUndirectedConnectedness6 [
	"Connectedness in case of multiple edges between the same nodes"

	view connectModel: 1 andModel: 1.
	self assert: view undirectedConnectedness equals: 1/3.
]

{ #category : #tests }
VZViewTest >> testUndirectedConnectedness7 [
	"Connectedness in case of empty graph"

	view hideAll: view visibleNodes.
	self assert: view undirectedConnectedness equals: 1.0.
]

{ #category : #tests }
VZViewTest >> testUndirectedConnectedness8 [
	"Connectedness in case of single node graph"

	view hideAll: view visibleNodes.
	view addNode: node1.
	self assert: view undirectedConnectedness equals: 1.0.
]

{ #category : #tests }
VZViewTest >> testVisibleEdges [
	| visibleEdges expectedVisibleEdges |
	
	view hideAll: node2 edges.
	visibleEdges := view visibleEdges.
	
	expectedVisibleEdges := node3 edges.
	
	self assertCollection: visibleEdges hasSameElements: expectedVisibleEdges.
]

{ #category : #tests }
VZViewTest >> testVisibleNodes [
	| visibleNodes expectedVisibleNodes |
	
	view hide: node2.
	view hide: node4.
	visibleNodes := view visibleNodes.
	
	expectedVisibleNodes := { node1 . node3 }.
	
	self assertCollection: visibleNodes hasSameElements: expectedVisibleNodes.
]
