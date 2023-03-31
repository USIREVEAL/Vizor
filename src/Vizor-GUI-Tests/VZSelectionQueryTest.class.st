"
A VZSelectionQueryTest is a test class for testing the behavior of VZSelectionQuery
"
Class {
	#name : #VZSelectionQueryTest,
	#superclass : #VZTestCase,
	#instVars : [
		'query',
		'view',
		'node2',
		'node3',
		'node1',
		'node4',
		'edge1',
		'edge2'
	],
	#category : #'Vizor-GUI-Tests-Selections'
}

{ #category : #running }
VZSelectionQueryTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	view := VZView exampleForTests.
	query := VZSelectionQuery new view: view.
	
	node1 := view findNodeByModel: 1.
	node2 := view findNodeByModel: 2.
	node3 := view findNodeByModel: 3.
	node4 := view findNodeByModel: 4.
	edge1 := node1 edges first.
	edge2 := node1 edges second.
]

{ #category : #tests }
VZSelectionQueryTest >> testAddToSelection [
	"Adding a node to a non-empty selection based on a VZSelectionQuery on its model should add the new node to the selection while keeping the old one."
	view select: node2.
	query
		selectionBlock: [ :each | each model = node3 model ];
		run;
		addToSelection.
	
	self assert: view selection entities size equals: 2.
	self assert: (view selection entities includes: node2).
	self assert: (view selection entities includes: node3).
]

{ #category : #tests }
VZSelectionQueryTest >> testAddToSelectionSame [
	"Adding the same node to the selection based on a VZSelectionQuery on its model shouldn't have any effect"
	view select: node2.
	query
		selectionBlock: [ :each | each model = node2 model ];
		run;
		addToSelection.
	
	self assert: view selection entities size equals: 1.
	self assertCollection: view selection entities hasSameElements: node2 asOrderedCollection.
]

{ #category : #tests }
VZSelectionQueryTest >> testApplySelection [
	"Select all nodes"
	query
		selectionBlock: [ :each | each isNode ];
		run;
		applySelection.
	
	self assertCollection: view selection entities hasSameElements: view nodes.
]

{ #category : #tests }
VZSelectionQueryTest >> testApplySelection2 [
	"Select all edges"
	query
		selectionBlock: [ :each | each isEdge ];
		run;
		applySelection.
	
	self assertCollection: view selection entities hasSameElements: view edges.
]

{ #category : #tests }
VZSelectionQueryTest >> testApplySelection3 [
	"Select even nodes"
	| evenNodes |
	evenNodes := { node2 . node4 }.
	query
		selectionBlock: [ :each | each isNode and: [ each model even ] ];
		run;
		applySelection.
	
	self assertCollection: view selection entities hasSameElements: evenNodes.
]

{ #category : #tests }
VZSelectionQueryTest >> testRun [
	"Query for all nodes"
	query selectionBlock: [ :each | each isKindOf: VZNode ].
	query run.
	
	self assertCollection: query result hasSameElements: view nodes.
]

{ #category : #tests }
VZSelectionQueryTest >> testRun2 [
	"Query for node 2"
	query selectionBlock: [ :each | each model = 2 ].
	query run.
	
	self assertCollection: query result hasSameElements: node2 asOrderedCollection.
]

{ #category : #tests }
VZSelectionQueryTest >> testRun3 [
	"Query for all nodes with more than one edge"
	query selectionBlock: [ :each | each isNode and: [ each edges size > 1 ] ].
	query run.
	
	self assertCollection: query result hasSameElements: node1 asOrderedCollection.
]
